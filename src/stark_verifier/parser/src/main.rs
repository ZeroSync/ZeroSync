#![feature(array_chunks)]

use serde::{Deserialize, Serialize};
use std::fs::File;
use std::io::{BufReader, Read};
use std::iter::zip;
use winter_utils::{Deserializable, SliceReader};
use winterfell::{FieldExtension, HashFunction, StarkProof};

use winter_air::proof::{Commitments, Context, OodFrame};
use winter_air::DefaultEvaluationFrame;
use winter_air::{ProofOptions, Table, TraceLayout};
use winter_crypto::{hashers::Blake2s_256, Digest};
use winterfell::Air;

use giza_air::{ProcessorAir, PublicInputs};
use giza_core::{Felt, RegisterState, Word};

use clap::{Parser, Subcommand};

mod memory;
use memory::{DynamicMemory, MemoryEntry, Writeable, WriteableWith};

#[derive(Parser)]
#[command(name = "parser")]
#[command(about = "A parser for reencoding STARK proofs", long_about = None)]
struct Cli {
    path: String,
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    Proof,
    PublicInputs,
}

fn main() {
    let cli = Cli::parse();

    // Load the proof and its public inputs from file
    let data = BinaryProofData::from_file(&cli.path);
    let proof = StarkProof::from_bytes(&data.proof_bytes).unwrap();
    let pub_inputs = PublicInputs::read_from(&mut SliceReader::new(&data.input_bytes[..])).unwrap();

    // Serialize to Cairo-compatible memory
    let mut memories = Vec::<Vec<MemoryEntry>>::new();
    let mut dynamic_memory = DynamicMemory::new(&mut memories);
    match &cli.command {
        Commands::Proof => {
            let air =
                ProcessorAir::new(proof.get_trace_info(), pub_inputs, proof.options().clone());
            proof.write_into(&mut dynamic_memory, &air);
        }
        Commands::PublicInputs => {
            pub_inputs.write_into(&mut dynamic_memory);
        }
    }

    // Serialize to JSON and print to stdout
    let memory = dynamic_memory.assemble();
    let json_arr = serde_json::to_string(&memory).unwrap();
    println!("{}", json_arr);
}

#[derive(Serialize, Deserialize)]
struct BinaryProofData {
    input_bytes: Vec<u8>,
    proof_bytes: Vec<u8>,
}

impl BinaryProofData {
    fn from_file(file_path: &String) -> BinaryProofData {
        let file = File::open(file_path).unwrap();
        let mut data = Vec::new();
        BufReader::new(file)
            .read_to_end(&mut data)
            .expect("Unable to read data");
        bincode::deserialize(&data).unwrap()
    }
}

impl Writeable for PublicInputs {
    fn write_into(&self, target: &mut DynamicMemory) {
        self.init.write_into(target);
        self.fin.write_into(target);
        self.rc_min.write_into(target);
        self.rc_max.write_into(target);
        self.mem.write_into(target);
        self.mem.0.len().write_into(target);
        self.num_steps.write_into(target);
    }
}

impl Writeable for (Vec<u64>, Vec<Option<Word>>) {
    fn write_into(&self, target: &mut DynamicMemory) {
        let mut res = Vec::new();
        for (idx, word) in zip(&self.0, &self.1) {
            res.push((idx, word.unwrap().word()));
        }
        target.write_array(res);
    }
}

impl Writeable for (&u64, Felt) {
    fn write_into(&self, target: &mut DynamicMemory) {
        self.0.write_into(target);
        self.1.write_into(target);
    }
}

impl Writeable for RegisterState {
    fn write_into(&self, target: &mut DynamicMemory) {
        self.pc.write_into(target);
        self.ap.write_into(target);
        self.fp.write_into(target);
    }
}

impl WriteableWith<&ProcessorAir> for StarkProof {
    fn write_into(&self, target: &mut DynamicMemory, air: &ProcessorAir) {
        self.context.write_into(target);
        self.commitments.write_into(target, air);
        self.ood_frame.write_into(target, air);
        self.pow_nonce.write_into(target);
    }
}

impl Writeable for Context {
    fn write_into(&self, target: &mut DynamicMemory) {
        self.trace_layout().write_into(target);
        self.trace_length().write_into(target); // Do not serialize as a power of two

        self.get_trace_info().meta().len().write_into(target);
        target.write_array(self.get_trace_info().meta().to_vec());

        self.field_modulus_bytes().len().write_into(target);
        target.write_array(self.field_modulus_bytes().to_vec());

        self.options().write_into(target);
    }
}

impl WriteableWith<&ProcessorAir> for Commitments {
    fn write_into(&self, target: &mut DynamicMemory, air: &ProcessorAir) {
        let num_trace_segments = air.trace_layout().num_segments();
        let lde_domain_size = air.lde_domain_size();
        let fri_options = air.options().to_fri_options();
        let num_fri_layers = fri_options.num_fri_layers(lde_domain_size);

        let (trace_commitments, constraint_commitment, fri_commitments) = self
            .clone()
            .parse::<Blake2s_256<Felt>>(num_trace_segments, num_fri_layers)
            .unwrap();

        target.write_array(
            trace_commitments
                .iter()
                .map(|x| ByteDigest(x.as_bytes()))
                .collect::<Vec<_>>(),
        );

        let mut temp_memory = target.alloc();
        ByteDigest(constraint_commitment.as_bytes()).write_into(&mut temp_memory);

        target.write_array(
            fri_commitments
                .iter()
                .map(|x| ByteDigest(x.as_bytes()))
                .collect::<Vec<_>>(),
        );
    }
}

struct ByteDigest<const N: usize>([u8; N]);

impl Writeable for ByteDigest<32> {
    fn write_into(&self, target: &mut DynamicMemory) {
        for chunk in self.0.array_chunks::<4>() {
            let int = u32::from_be_bytes(*chunk);
            int.write_into(target);
        }
    }
}

impl WriteableWith<&ProcessorAir> for OodFrame {
    fn write_into(&self, target: &mut DynamicMemory, air: &ProcessorAir) {
        let main_trace_width = air.trace_layout().main_trace_width();
        let aux_trace_width = air.trace_layout().aux_trace_width();
        let (ood_main_trace_frame, ood_aux_trace_frame, ood_constraint_evaluations) = self
            .clone()
            .parse::<Felt, DefaultEvaluationFrame<Felt>, DefaultEvaluationFrame<Felt>>(
                main_trace_width,
                aux_trace_width,
                air.eval_frame_size::<Felt>(),
                air.ce_blowup_factor(),
            )
            .unwrap();

        ood_main_trace_frame.write_into(target);
        ood_aux_trace_frame.clone().unwrap().write_into(target);

        target.write_array(ood_constraint_evaluations);
    }
}

impl Writeable for TraceLayout {
    fn write_into(&self, target: &mut DynamicMemory) {
        let mut aux_segment_widths = Vec::new();
        let mut aux_segment_rands = Vec::new();

        for i in 0..self.num_aux_segments() {
            aux_segment_widths.push(self.get_aux_segment_width(i));
            aux_segment_rands.push(self.get_aux_segment_rand_elements(i));
        }

        self.main_trace_width().write_into(target);
        self.num_aux_segments().write_into(target);
        target.write_array(aux_segment_widths);
        target.write_array(aux_segment_rands);
    }
}

impl Writeable for ProofOptions {
    fn write_into(&self, target: &mut DynamicMemory) {
        self.num_queries().write_into(target);
        self.blowup_factor().write_into(target);
        self.grinding_factor().write_into(target);

        self.hash_fn().write_into(target);
        self.field_extension().write_into(target);

        let fri_options = self.to_fri_options();
        fri_options.folding_factor().write_into(target);
        fri_options.max_remainder_size().write_into(target);
    }
}

impl Writeable for HashFunction {
    fn write_into(&self, target: &mut DynamicMemory) {
        (*self as u8).write_into(target);
    }
}

impl Writeable for FieldExtension {
    fn write_into(&self, target: &mut DynamicMemory) {
        (*self as u8).write_into(target);
    }
}

impl Writeable for DefaultEvaluationFrame<Felt> {
    fn write_into(&self, target: &mut DynamicMemory) {
        target.write_sized_array(self.current().to_vec());
        target.write_sized_array(self.next().to_vec());
    }
}

impl Writeable for Table<Felt> {
    fn write_into(&self, target: &mut DynamicMemory) {
        for i in 0..self.num_rows() {
            // a trace segment column or a constraint evaluation column
            let column = self.get_row(i);
            target.write_array(column.to_vec());
        }
    }
}

impl Writeable for Felt {
    fn write_into(&self, target: &mut DynamicMemory) {
        let mut hex_string = "0x".to_owned();
        for chunk in self.to_raw().0.iter().rev() {
            for byte in chunk.to_be_bytes() {
                hex_string += format!("{:02x?}", byte).as_str();
            }
        }
        target.write_hex_value(hex_string);
    }
}

impl Writeable for [u8; 32] {
    // Convert 32 x u8 to 8 x u32
    fn write_into(&self, target: &mut DynamicMemory) {
        let mut uint32_array = Vec::new();
        for i in 0..8 {
            let mut uint32 = 0;
            // Store as big endian
            let mut base = 1 << 24;
            for j in 0..4 {
                let index = (i * 4 + j) as usize;
                uint32 += base * self[index] as usize;
                base >>= 8;
            }
            uint32_array.push(uint32);
        }
        target.write_array(uint32_array);
    }
}
