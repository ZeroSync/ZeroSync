use std::fs::File;
use std::io::{ BufReader, Read, Result };
use serde::{ Deserialize, Serialize };
use winterfell::{StarkProof};
use winter_utils::{Deserializable, SliceReader};

use std::env;

use winterfell::Air;
use winter_air::proof::{Context, Queries, Commitments};
use winter_air::{ TraceLayout };
use winter_crypto::hashers::Blake3_256;
use giza_core::Felt;
use winter_crypto::Digest;
use air::{ ProcessorAir, PublicInputs };


mod memory;
use memory::{ MemoryEntry, Writeable, DynamicMemory };

#[derive(Serialize, Deserialize)]
struct ProofData {
    input_bytes: Vec<u8>,
    proof_bytes: Vec<u8>,
}

fn main() -> Result<()> {
    let args: Vec<String> = env::args().collect();
    let proof_path = &args[1];

    let file = File::open(proof_path)?;
    let mut buf_reader = BufReader::new(file);
    
    let mut data = Vec::new();
    buf_reader.read_to_end(&mut data).expect("Unable to read data");
    
    let data: ProofData = bincode::deserialize( &data ).unwrap();
    let proof = StarkProof::from_bytes(&data.proof_bytes).unwrap();
    let pub_inputs = PublicInputs::read_from(&mut SliceReader::new(&data.input_bytes[..])).unwrap();

    let air = ProcessorAir::new(proof.get_trace_info(), pub_inputs, proof.options().clone());

    let mut memories = Vec::<Vec<MemoryEntry>>::new();
    let mut dynamic_memory = DynamicMemory::new(&mut memories, &air);

    proof.write_into(&mut dynamic_memory);

    let memory = dynamic_memory.serialize();

    let json_arr = serde_json::to_string(&memory)?;
    println!( "{}", json_arr );

    Ok(())
}



impl Writeable<ProcessorAir> for TraceLayout {

    fn write_into(&self, target: &mut DynamicMemory<ProcessorAir>) {
        let mut aux_segement_widths = Vec::new();
        let mut aux_segment_rands = Vec::new();

        for i in 0..self.num_aux_segments() {
            aux_segement_widths.push( self.get_aux_segment_width(i) );
            aux_segment_rands.push( self.get_aux_segment_rand_elements(i) );
        }

        self.main_trace_width().write_into(target);
        self.num_aux_segments().write_into(target);
        target.write_array(aux_segement_widths);
        target.write_array(aux_segment_rands);
    }

}

impl Writeable<ProcessorAir> for Context {

    fn write_into(&self, target: &mut DynamicMemory<ProcessorAir>) {
        
        self.trace_layout().write_into(target);

        self.trace_length().write_into(target); // Do not serialize as a power of two
        
        self.get_trace_info().meta().len().write_into(target);
        target.write_array(self.get_trace_info().meta().to_vec());
        
        self.field_modulus_bytes().len().write_into(target);
        target.write_array(self.field_modulus_bytes().to_vec());
    }

}

type HashFn = Blake3_256<Felt>;

impl Writeable<ProcessorAir> for [u8; 32] {
    
    fn write_into(&self, target: &mut DynamicMemory<ProcessorAir>) {
        let mut uint32_array = Vec::new();
        for i in 0..8 {
            let mut uint32 = 0;
            // Store as big endian
            let mut base = 1 << 24;
            for j in 0..4 {
                let index = (i * 4 + j) as usize;
                uint32 += base * self[ index ] as usize;
                base >>= 8;
            }
            uint32_array.push( uint32 );
        }
        target.write_array( uint32_array );
    }

}

impl Writeable<ProcessorAir> for Queries {

    fn write_into(&self, target: &mut DynamicMemory<ProcessorAir>) {
        let air = target.context;

        let domain_size = air.lde_domain_size();
        let num_queries = air.options().num_queries();
        let values_per_query = air.trace_layout().main_trace_width();
        // let (proofs, table) = self.clone().parse::<HashFn, Felt>(domain_size, num_queries, values_per_query).unwrap();
    }

}


impl Writeable<ProcessorAir> for Commitments {

    fn write_into(&self, target: &mut DynamicMemory<ProcessorAir>) {
        let air = target.context;
        
        let num_trace_segments = air.trace_layout().num_segments();
        let lde_domain_size = air.lde_domain_size();
        let fri_options = air.options().to_fri_options();
        let num_fri_layers = 1; // fri_options.num_fri_layers(lde_domain_size);

        let (trace_commitments, constraint_commitment, fri_commitments) = self.clone().parse::<HashFn>(
                num_trace_segments,  num_fri_layers ).unwrap();

        for trace_commitment in trace_commitments {
            trace_commitment.as_bytes().write_into(target);
        }

        constraint_commitment.as_bytes().write_into(target);
        
        for fri_commitment in fri_commitments {
            fri_commitment.as_bytes().write_into(target);
        }
    }

}


impl Writeable<ProcessorAir> for StarkProof {
    
    fn write_into(&self, target: &mut DynamicMemory<ProcessorAir>) {
        self.context.write_into(target);
        self.pow_nonce.write_into(target);
        self.commitments.write_into(target);

        target.write_array(self.trace_queries.clone());
        self.constraint_queries.write_into(target);
    }
    
}
