use winter_utils::{Deserializable, SliceReader};
use zerosync_parser::{
    memory::{Writeable, WriteableWith},
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
    let json_arr = match &cli.command {
        Commands::Proof => {
            let air =
                ProcessorAir::new(proof.get_trace_info(), pub_inputs, proof.options().clone());
            proof.to_cairo_memory(&air)
        }
        Commands::PublicInputs => pub_inputs.to_cairo_memory(),
    };

    println!("{}", json_arr);
}
