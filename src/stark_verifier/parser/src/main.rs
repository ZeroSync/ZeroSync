use serde::{Deserialize, Serialize};
use std::fs::File;
use std::io::{BufReader, Read};
use winter_utils::{Deserializable, SliceReader};
use winterfell::StarkProof;

use std::env;

use winter_air::proof::{Commitments, Context, OodFrame, Queries};
use winter_air::DefaultEvaluationFrame;
use winter_air::{ProofOptions, Table, TraceLayout};
use winter_crypto::hashers::Blake3_192;
use winter_crypto::{BatchMerkleProof, Digest};
use winter_fri::FriProof;
use winterfell::Air;

use giza_air::{ProcessorAir, PublicInputs};
use giza_core::Felt;

mod memory;
use memory::{DynamicMemory, MemoryEntry, Writeable, WriteableWith};

#[derive(Serialize, Deserialize)]
struct BinaryProofData {
    input_bytes: Vec<u8>,
    proof_bytes: Vec<u8>,
}

impl BinaryProofData {
    fn from_file(file_path: &String) -> BinaryProofData {
        let file = File::open(file_path).unwrap();
        let mut buf_reader = BufReader::new(file);

        let mut data = Vec::new();
        buf_reader
            .read_to_end(&mut data)
            .expect("Unable to read data");

        bincode::deserialize(&data).unwrap()
    }
}

fn main() {
    // Load the proof and its public inputs from a file into byte strings
    let args: Vec<String> = env::args().collect();
    let proof_path = &args[1];
    let data = BinaryProofData::from_file(proof_path);

    // Parse a proof_data object
    let proof = StarkProof::from_bytes(&data.proof_bytes).unwrap();
    let pub_inputs = PublicInputs::read_from(&mut SliceReader::new(&data.input_bytes[..])).unwrap();
    let air = ProcessorAir::new(proof.get_trace_info(), pub_inputs, proof.options().clone());
    let proof_data = ProofData {
        stark_proof: proof,
        air,
    };

    // Serialize proof_data into a Cairo memory
    let mut memories = Vec::<Vec<MemoryEntry>>::new();
    let mut dynamic_memory = DynamicMemory::new(&mut memories);
    proof_data.write_into(&mut dynamic_memory);
    let memory = dynamic_memory.assemble();

    // Serialize the memory to JSON and print it
    let json_arr = serde_json::to_string(&memory).unwrap();
    println!("{}", json_arr);
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

impl Writeable for Context {
    fn write_into(&self, target: &mut DynamicMemory) {
        self.trace_layout().write_into(target);

        self.trace_length().write_into(target); // Do not serialize as a power of two

        self.get_trace_info().meta().len().write_into(target);
        target.write_array(self.get_trace_info().meta().to_vec());

        self.field_modulus_bytes().len().write_into(target);
        target.write_array(self.field_modulus_bytes().to_vec());
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

type HashFn = Blake3_192<Felt>;

struct QueriesParams {
    domain_size: usize,
    num_queries: usize,
    values_per_query: usize,
}

impl Writeable for BatchMerkleProof<HashFn> {
    fn write_into(&self, target: &mut DynamicMemory) {
        // TODO: implement me
        // https://github.com/novifinancial/winterfell/blob/main/crypto/src/merkle/proofs.rs#L265
        // let indexes = ???
        // self.into_paths(indexes).unwrap();
    }
}

impl Writeable for Felt {
    fn write_into(&self, target: &mut DynamicMemory) {
        let mut hex_string = "0x".to_owned();
        for byte in self.to_raw().to_le_bytes() {
            hex_string += format!("{:02x?}", byte).as_str();
        }
        target.write_hex_value(hex_string);
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

impl WriteableWith<QueriesParams> for Queries {
    fn write_into(&self, target: &mut DynamicMemory, params: QueriesParams) {
        let (proofs, table) = self
            .clone()
            .parse::<HashFn, Felt>(
                params.domain_size,
                params.num_queries,
                params.values_per_query,
            )
            .unwrap();
        table.write_into(target);
        proofs.write_into(target);
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
            .parse::<HashFn>(num_trace_segments, num_fri_layers)
            .unwrap();

        for trace_commitment in trace_commitments {
            trace_commitment.as_bytes().write_into(target);
        }

        constraint_commitment.as_bytes().write_into(target);

        for fri_commitment in fri_commitments {
            fri_commitment.as_bytes().write_into(target);
        }
    }
}

impl WriteableWith<&ProcessorAir> for StarkProof {
    fn write_into(&self, target: &mut DynamicMemory, air: &ProcessorAir) {
        self.context.write_into(target);
        self.pow_nonce.write_into(target);

        self.commitments.write_into(target, air);
        self.ood_frame.write_into(target, air);

        //target.write_array_with(self.trace_queries.clone(), |index| {
        //    let values_per_query;
        //    if index == 0 {
        //        values_per_query = air.trace_layout().main_trace_width();
        //    } else {
        //        values_per_query = air
        //            .trace_layout()
        //            .get_aux_segment_width((index - 1).try_into().unwrap());
        //    }
        //    QueriesParams {
        //        domain_size: air.lde_domain_size(),
        //        num_queries: air.options().num_queries(),
        //        values_per_query,
        //    }
        //});

        //self.constraint_queries.write_into(
        //    target,
        //    QueriesParams {
        //        domain_size: air.lde_domain_size(),
        //        num_queries: air.options().num_queries(),
        //        values_per_query: air.ce_blowup_factor(),
        //    },
        //);
    }
}

struct ProofData {
    stark_proof: StarkProof,
    air: ProcessorAir,
}

impl Writeable for ProcessorAir {
    fn write_into(&self, target: &mut DynamicMemory) {
        // TODO: implement me
        // Make `pub_inputs` public?
        // https://github.com/ZeroSync/giza/blob/master/air/src/lib.rs#L32
    }
}

impl Writeable for ProofData {
    fn write_into(&self, target: &mut DynamicMemory) {
        self.stark_proof.write_into(target, &self.air);
        self.air.write_into(target);
    }
}

impl Writeable for ProofOptions {
    fn write_into(&self, target: &mut DynamicMemory) {
        // TODO: implement me
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

impl Writeable for DefaultEvaluationFrame<Felt> {
    fn write_into(&self, target: &mut DynamicMemory) {
        target.write_sized_array(self.current().to_vec());
        target.write_sized_array(self.next().to_vec());
    }
}

impl Writeable for FriProof {
    fn write_into(&self, target: &mut DynamicMemory) {
        // TODO: implement me
        // make fields public
    }
}

// impl Writeable for FriProofLayer {
//     fn write_into(&self, target: &mut DynamicMemory) {
//         // TODO: implement me
//         // Make struct FriProofLayer public
//     }
// }
