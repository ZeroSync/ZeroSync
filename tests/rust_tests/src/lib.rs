use serde::{Deserialize, Serialize};
use std::fs::File;
use std::io::{BufReader, Read};

use winter_crypto::{hashers::Blake2s_256, Digest, ElementHasher, RandomCoin};
use winter_utils::{Deserializable, Serializable, SliceReader};
use winterfell::{Air, AuxTraceRandElements, StarkProof, VerifierChannel, VerifierError};
use winterfell::evaluate_constraints;
use giza_air::{MainEvaluationFrame, AuxEvaluationFrame};

use giza_air::{ProcessorAir, PublicInputs};
use giza_core::Felt;

use starknet_crypto::pedersen_hash;
use starknet_ff::FieldElement as Fe;

use blake2::blake2s::blake2s;

use pyo3::exceptions::PyValueError;
use pyo3::prelude::*;

struct WinterVerifierError(VerifierError);

impl From<WinterVerifierError> for PyErr {
    fn from(error: WinterVerifierError) -> Self {
        PyValueError::new_err(print!("{}", error.0))
    }
}

impl From<VerifierError> for WinterVerifierError {
    fn from(other: VerifierError) -> Self {
        Self(other)
    }
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

#[pyfunction]
fn merge() -> Result<String, PyErr> {
    let data = [0; 64];
    let digest: [u8; 32] = blake2s(32, &[], &data)
        .as_bytes()
        .try_into()
        .expect("slice with incorrect length");
    let hex_string = hex::encode(digest);
    Ok(hex_string)
}

#[pyfunction]
fn merge_with_int() -> Result<String, PyErr> {
    let value = 1u64;
    let mut data = [0; 40];
    // the first 32 bytes are zeros
    // the 8 remaining bytes are the 64 bits of the value
    data[32..].copy_from_slice(&value.to_le_bytes());
    let digest: [u8; 32] = blake2s(32, &[], &data)
        .as_bytes()
        .try_into()
        .expect("slice with incorrect length");
    let hex_string = hex::encode(digest);
    Ok(hex_string)
}

#[pyfunction]
fn draw_felt() -> Result<String, WinterVerifierError> {
    let public_coin_seed = vec![0u8; 32];
    let mut public_coin = RandomCoin::<Felt, Blake2s_256<Felt>>::new(&public_coin_seed);
    let z = public_coin
        .draw::<Felt>()
        .map_err(|_| VerifierError::RandomCoinError)?;
    let digest = z.to_raw();
    let hex_string = digest.to_string();
    Ok(hex_string)
}

#[pyfunction]
fn draw_integers() -> Result<String, WinterVerifierError> {
    let public_coin_seed = vec![0u8; 32];
    let mut public_coin = RandomCoin::<Felt, Blake2s_256<Felt>>::new(&public_coin_seed);
    let z = public_coin
        .draw_integers(20, 64)
        .map_err(|_| VerifierError::RandomCoinError)?;
    let hex_string = z[0].to_string(); // TODO: serialize all ints to hex
    Ok(hex_string)
}

#[pyfunction]
fn hash_elements() -> Result<String, PyErr> {
    let mut data = Vec::new();
    let mut a = [0u8; 32];
    a[31] = 1u8;
    data.push(Felt::from(a));
    data.push(Felt::from([0u8; 32]));

    let digest: [u8; 32] = Blake2s_256::hash_elements(&data)
        .as_bytes()
        .try_into()
        .expect("slice with incorrect length");
    let hex_string = hex::encode(digest);
    Ok(hex_string)
}

#[pyfunction]
fn pedersen_chain() -> Result<String, PyErr> {
    let values = vec![1u8, 1u8].into_iter().map(Fe::from).collect::<Vec<_>>();
    let len = Fe::from(values.len());
    let digest = values
        .iter()
        .fold(Fe::from(0u8), |hash, item| pedersen_hash(&hash, &item));
    let digest = pedersen_hash(&digest, &len);
    let hex_string = hex::encode(digest.to_bytes_be());
    Ok(hex_string)
}

// TODO: Refactor, to reuse code in pedersen_chain test
fn get_pub_mem_hash() -> Fe {
    let path = String::from("tests/stark_proofs/fibonacci.bin");
    let data = BinaryProofData::from_file(&path);
    let pub_inputs = PublicInputs::read_from(&mut SliceReader::new(&data.input_bytes[..])).unwrap();
    let len = Fe::from(pub_inputs.mem.1.len());
    let pub_mem_hash = pub_inputs
        .mem
        .1
        .iter()
        .map(|x| {
            Fe::from_bytes_be(&{
                let mut data = [0; 32];
                write_be_bytes(x.unwrap().word().to_raw().0, &mut data);
                data
            })
            .unwrap()
        })
        .fold(Fe::from(0u8), |hash, item| pedersen_hash(&hash, &item));
    pedersen_hash(&pub_mem_hash, &len)
}

#[pyfunction]
fn hash_pub_inputs() -> Result<String, PyErr> {
    let digest = get_pub_mem_hash();
    let hex_string = hex::encode(digest.to_bytes_be());
    Ok(hex_string)
}

#[pyfunction]
fn seed_with_pub_inputs() -> Result<String, PyErr> {
    let path = String::from("tests/stark_proofs/fibonacci.bin");
    let data = BinaryProofData::from_file(&path);
    let pub_inputs = PublicInputs::read_from(&mut SliceReader::new(&data.input_bytes[..])).unwrap();

    let digest = get_pub_mem_hash();
    let pub_mem_hash = {
        let mut bytes = digest.to_bytes_be();
        bytes.reverse();
        Felt::from(bytes)
    };

    let mut data = Vec::new();
    data.push(pub_inputs.init.pc);
    data.push(pub_inputs.init.ap);
    data.push(pub_inputs.init.fp);
    data.push(pub_inputs.fin.pc);
    data.push(pub_inputs.fin.ap);
    data.push(pub_inputs.fin.fp);
    data.push(pub_inputs.rc_min.into());
    data.push(pub_inputs.rc_max.into());
    data.push(pub_inputs.mem.0.len().into());
    data.push(pub_mem_hash);
    data.push(pub_inputs.num_steps.into());

    let digest: [u8; 32] = Blake2s_256::hash_elements(&data)
        .as_bytes()
        .try_into()
        .expect("slice with incorrect length");
    let hex_string = hex::encode(digest);
    Ok(hex_string)
}

#[pyfunction]
fn draw_ood_point_z() -> Result<String, WinterVerifierError> {
    let path = String::from("tests/stark_proofs/fibonacci.bin");

    let data = BinaryProofData::from_file(&path);
    let proof = StarkProof::from_bytes(&data.proof_bytes).unwrap();
    let pub_inputs = PublicInputs::read_from(&mut SliceReader::new(&data.input_bytes[..])).unwrap();

    let mut public_coin_seed = Vec::new();
    pub_inputs.write_into(&mut public_coin_seed);

    let air = ProcessorAir::new(proof.get_trace_info(), pub_inputs, proof.options().clone());

    let mut public_coin = RandomCoin::<Felt, Blake2s_256<Felt>>::new(&public_coin_seed);
    let channel = VerifierChannel::<
        Felt,
        Blake2s_256<Felt>,
        MainEvaluationFrame<Felt>,
        AuxEvaluationFrame<Felt>,
    >::new(&air, proof)?;

    let trace_commitments = channel.read_trace_commitments();

    // reseed the coin with the commitment to the main trace segment
    public_coin.reseed(trace_commitments[0]);

    // process auxiliary trace segments (if any), to build a set of random elements for each segment
    let mut aux_trace_rand_elements = AuxTraceRandElements::<Felt>::new();
    for (i, commitment) in trace_commitments.iter().skip(1).enumerate() {
        let rand_elements = air
            .get_aux_trace_segment_random_elements(i, &mut public_coin)
            .map_err(|_| VerifierError::RandomCoinError)?;
        aux_trace_rand_elements.add_segment_elements(rand_elements);
        public_coin.reseed(*commitment);
    }

    // build random coefficients for the composition polynomial
    let _constraint_coeffs = air
        .get_constraint_composition_coefficients::<Felt, Blake2s_256<Felt>>(&mut public_coin)
        .map_err(|_| VerifierError::RandomCoinError)?;

    // 2 ----- constraint commitment --------------------------------------------------------------
    // read the commitment to evaluations of the constraint composition polynomial over the LDE
    // domain sent by the prover, use it to update the public coin, and draw an out-of-domain point
    // z from the coin; in the interactive version of the protocol, the verifier sends this point z
    // to the prover, and the prover evaluates trace and constraint composition polynomials at z,
    // and sends the results back to the verifier.
    let constraint_commitment = channel.read_constraint_commitment();
    public_coin.reseed(constraint_commitment);
    let z = public_coin
        .draw::<Felt>()
        .map_err(|_| VerifierError::RandomCoinError)?;

    let hex_string = z.to_raw().to_string();
    Ok(hex_string)
}

fn write_be_bytes(value: [u64; 4], out: &mut [u8; 32]) {
    for (src, dst) in value.iter().rev().cloned().zip(out.chunks_exact_mut(8)) {
        dst.copy_from_slice(&src.to_be_bytes());
    }
}

#[pyfunction]
fn constraint_evaluation() -> Result<String, WinterVerifierError> {
    let path = String::from("tests/stark_proofs/fibonacci.bin");

    let data = BinaryProofData::from_file(&path);
    let proof = StarkProof::from_bytes(&data.proof_bytes).unwrap();
    let pub_inputs = PublicInputs::read_from(&mut SliceReader::new(&data.input_bytes[..])).unwrap();

    let mut public_coin_seed = Vec::new();
    pub_inputs.write_into(&mut public_coin_seed);

    let air = ProcessorAir::new(proof.get_trace_info(), pub_inputs, proof.options().clone());

    let mut public_coin = RandomCoin::<Felt, Blake2s_256<Felt>>::new(&public_coin_seed);
    let mut channel = VerifierChannel::<
        Felt,
        Blake2s_256<Felt>,
        MainEvaluationFrame<Felt>,
        AuxEvaluationFrame<Felt>,
    >::new(&air, proof)?;

    let trace_commitments = channel.read_trace_commitments();

    // reseed the coin with the commitment to the main trace segment
    public_coin.reseed(trace_commitments[0]);

    // process auxiliary trace segments (if any), to build a set of random elements for each segment
    let mut aux_trace_rand_elements = AuxTraceRandElements::<Felt>::new();
    for (i, commitment) in trace_commitments.iter().skip(1).enumerate() {
        let rand_elements = air
            .get_aux_trace_segment_random_elements(i, &mut public_coin)
            .map_err(|_| VerifierError::RandomCoinError)?;
        aux_trace_rand_elements.add_segment_elements(rand_elements);
        public_coin.reseed(*commitment);
    }

    // build random coefficients for the composition polynomial
    let constraint_coeffs = air
        .get_constraint_composition_coefficients::<Felt, Blake2s_256<Felt>>(&mut public_coin)
        .map_err(|_| VerifierError::RandomCoinError)?;

    // 2 ----- constraint commitment --------------------------------------------------------------
    // read the commitment to evaluations of the constraint composition polynomial over the LDE
    // domain sent by the prover, use it to update the public coin, and draw an out-of-domain point
    // z from the coin; in the interactive version of the protocol, the verifier sends this point z
    // to the prover, and the prover evaluates trace and constraint composition polynomials at z,
    // and sends the results back to the verifier.
    let constraint_commitment = channel.read_constraint_commitment();
    public_coin.reseed(constraint_commitment);
    let z = public_coin
        .draw::<Felt>()
        .map_err(|_| VerifierError::RandomCoinError)?;


    // 3 ----- OOD consistency check --------------------------------------------------------------
    // make sure that evaluations obtained by evaluating constraints over the out-of-domain frame
    // are consistent with the evaluations of composition polynomial columns sent by the prover

    // read the out-of-domain trace frames (the main trace frame and auxiliary trace frame, if
    // provided) sent by the prover and evaluate constraints over them; also, reseed the public
    // coin with the OOD frames received from the prover.
    let (ood_main_trace_frame, ood_aux_trace_frame) = channel.read_ood_trace_frame();
    let ood_constraint_evaluation_1 = evaluate_constraints(
        &air,
        constraint_coeffs,
        &ood_main_trace_frame,
        &ood_aux_trace_frame,
        aux_trace_rand_elements,
        z,
    );

    let hex_string = ood_constraint_evaluation_1.to_raw().to_string();

    Ok(hex_string)
}



/// A Python module implemented in Rust. The name of this function must match
/// the `lib.name` setting in the `Cargo.toml`, else Python will not be able to
/// import the module.
#[pymodule]
fn zerosync_tests(_py: Python<'_>, m: &PyModule) -> PyResult<()> {
    // Random coin
    m.add_function(wrap_pyfunction!(merge, m)?)?;
    m.add_function(wrap_pyfunction!(merge_with_int, m)?)?;
    m.add_function(wrap_pyfunction!(draw_felt, m)?)?;
    m.add_function(wrap_pyfunction!(draw_integers, m)?)?;
    m.add_function(wrap_pyfunction!(hash_elements, m)?)?;
    // Seeding
    m.add_function(wrap_pyfunction!(pedersen_chain, m)?)?;
    m.add_function(wrap_pyfunction!(hash_pub_inputs, m)?)?;
    m.add_function(wrap_pyfunction!(seed_with_pub_inputs, m)?)?;
    m.add_function(wrap_pyfunction!(draw_ood_point_z, m)?)?;

    m.add_function(wrap_pyfunction!(constraint_evaluation, m)?)?;
    Ok(())
}
