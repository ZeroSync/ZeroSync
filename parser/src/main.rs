use winter_utils::{Deserializable, SliceReader};
use zerosync_parser::{
    memory::{DynamicMemory, MemoryEntry, Writeable, WriteableWith},
    Air, BinaryProofData, ProcessorAir, PublicInputs, StarkProof,
};

use clap::{Parser, Subcommand};

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
