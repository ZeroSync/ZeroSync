use giza_core::Felt;
use serde_json::from_str;
use winter_crypto::hashers::Blake2s_256;
use winter_utils::{Deserializable, SliceReader};
use winterfell::VerifierChannel;
use zerosync_parser::{
    memory::{Writeable, WriteableWith},
    Air, BinaryProofData, ProcessorAir, PublicInputs, StarkProof, MainEvaluationFrame, AuxEvaluationFrame,
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
    TraceQueries{ indices:Option<String> },
    ConstraintQueries{ indices:Option<String> },
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
        Commands::TraceQueries { indices } => {
            let air = ProcessorAir::new(
                proof.get_trace_info(), pub_inputs.clone(),proof.options().clone(),
            );

            let indexes : Vec<usize> = from_str(&indices.clone().unwrap()).unwrap();
        
            let channel = VerifierChannel::<
                Felt,
                Blake2s_256<Felt>,
                MainEvaluationFrame<Felt>,
                AuxEvaluationFrame<Felt>,
            >::new(&air, proof.clone()).unwrap();

            channel.trace_queries.unwrap().to_cairo_memory(&indexes)
        },
        Commands::ConstraintQueries { indices } => {
            let air = ProcessorAir::new(
                proof.get_trace_info(), pub_inputs.clone(),proof.options().clone(),
            );

            let indexes : Vec<usize> = from_str(&indices.clone().unwrap()).unwrap();
        
            let channel = VerifierChannel::<
                Felt,
                Blake2s_256<Felt>,
                MainEvaluationFrame<Felt>,
                AuxEvaluationFrame<Felt>,
            >::new(&air, proof.clone()).unwrap();

            channel.constraint_queries.unwrap().to_cairo_memory(&indexes)
        },
    };

    println!("{}", json_arr);
}
