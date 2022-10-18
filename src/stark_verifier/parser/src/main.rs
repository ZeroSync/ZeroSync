use std::fs::File;
use std::io::{ BufReader, Read, Result };
use serde::{ Deserialize, Serialize };
use winterfell::StarkProof;

use std::env;

use winter_air::proof::{Context};
use winter_air::TraceLayout;
use winter_crypto::hashers::Blake3_256;
use giza_core::Felt;
use winter_crypto::Digest;

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

    let mut memories = Vec::<Vec<MemoryEntry>>::new();
    let mut dynamic_memory = DynamicMemory::new(&mut memories);

    proof.write_into(&mut dynamic_memory);

    let memory = dynamic_memory.serialize();

    let json_arr = serde_json::to_string(&memory)?;
    println!( "{}", json_arr );

    Ok(())
}


impl Writeable for u8 {
    fn write_into(&self, target: &mut DynamicMemory) {
        target.write_value(*self as u64)
    }
}

impl Writeable for u64 {
    fn write_into(&self, target: &mut DynamicMemory) {
        target.write_value(*self)
    }
}

impl Writeable for usize {
    fn write_into(&self, target: &mut DynamicMemory) {
        target.write_value(*self as u64)
    }
}

impl Writeable for u32 {
    fn write_into(&self, target: &mut DynamicMemory) {
        target.write_value(*self as u64)
    }
}


impl Writeable for TraceLayout {

    fn write_into(&self, target: &mut DynamicMemory) {
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

type HashFn = Blake3_256<Felt>;

impl Writeable for [u8; 32] {
    
    fn write_into(&self, target: &mut DynamicMemory) {
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

impl Writeable for StarkProof {
    
    fn write_into(&self, target: &mut DynamicMemory) {
        self.context.write_into(target);
        self.pow_nonce.write_into(target);
        let num_layers = self.fri_proof.num_layers();
        let num_trace_segments = 1; // self.context.trace_layout().num_segments(); // TODO: why is num_segments wrong here??
        let commitments = self.commitments.clone();
        let (trace_commitments, constraint_commitment, fri_commitments) = commitments.parse::<HashFn>(num_trace_segments, num_layers).unwrap();

        for trace_commitment in trace_commitments {
            trace_commitment.as_bytes().write_into(target);
        }

        constraint_commitment.as_bytes().write_into(target);
        
        for fri_commitment in fri_commitments {
            fri_commitment.as_bytes().write_into(target);
        }
    }
    
}
