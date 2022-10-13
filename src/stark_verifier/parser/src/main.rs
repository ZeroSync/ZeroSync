use winterfell::StarkProof;
use std::fs::File;
use std::io::BufReader;
use serde::{Deserialize, Serialize};
use std::io::Read;

fn main() -> std::io::Result<()> {
    let file = File::open("./src/proof_9.bin")?;
    let mut buf_reader = BufReader::new(file);
    
    let mut data = Vec::new();
    buf_reader.read_to_end(&mut data).expect("Unable to read data");
    
    let data: ProofData = bincode::deserialize( &data ).unwrap();
    let proof = StarkProof::from_bytes(&data.proof_bytes).unwrap();

    println!( "{}", proof.pow_nonce );

    Ok(())
}



#[derive(Serialize, Deserialize)]
struct ProofData {
    input_bytes: Vec<u8>,
    proof_bytes: Vec<u8>,
}
