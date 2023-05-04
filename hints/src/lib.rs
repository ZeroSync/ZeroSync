use std::collections::HashMap;

use winter_air::EvaluationFrame;
use winter_crypto::{hashers::Pedersen_256, Hasher, Digest, ElementHasher, RandomCoin};
use winter_math::FieldElement;
use winter_utils::{Deserializable, Serializable, SliceReader};
use winterfell::{evaluate_constraints, AuxTraceRandElements, VerifierChannel, VerifierError, FriVerifier, DeepComposer};

use giza_air::{AuxEvaluationFrame, MainEvaluationFrame};
use giza_core::Felt;

use starknet_crypto::pedersen_hash;
use starknet_ff::FieldElement as Fe;

use pyo3::exceptions::PyValueError;
use pyo3::prelude::*;

use zerosync_parser::{
    Air, BinaryProofData, ProcessorAir, ProcessorAirParams, PublicInputs, StarkProof,
};

use zerosync_parser::memory::{Writeable, WriteableWith};

struct WinterVerifierError(VerifierError);

impl From<WinterVerifierError> for PyErr {
    fn from(error: WinterVerifierError) -> Self {
        PyValueError::new_err(print!("{:?}", error.0))
    }
}

impl From<VerifierError> for WinterVerifierError {
    fn from(other: VerifierError) -> Self {
        Self(other)
    }
}

#[pyfunction]
fn merge() -> Result<String, PyErr> {
    let e = [Felt::from(0x5337u16), Felt::from(1u8)];
    let digest: [u8; 32] = Pedersen_256::hash_elements(&e).0;
    let mut digest_endian = [0u8; 32];
    for (src, dst) in digest.iter().rev().zip(digest_endian.iter_mut()) {
        *dst = *src;
    }
    let hex_string = hex::encode(digest_endian);
    Ok(hex_string)
}

#[pyfunction]
fn reseed_with_int() -> Result<String, PyErr> {
    let seed = vec![1,0,0,0, 2,0,0,0, 3,0,0,0, 4,0,0,0,
                    5,0,0,0, 6,0,0,0, 7,0,0,0, 8,0,0,0];
    let mut coin = RandomCoin::<Felt, Pedersen_256<Felt>>::new(&seed);
    coin.reseed_with_int(1337);
    let reseed_coin_z = coin.draw::<Felt>();
    let digest = reseed_coin_z.unwrap().to_raw();
    let mut digest_endian = [0u8; 32];
    write_be_bytes(digest.0, &mut digest_endian);
    let hex_string = hex::encode(digest_endian);
    Ok(hex_string)
}

#[pyfunction]
fn merge_with_int() -> Result<String, PyErr> {
    // the first 32 bytes are zeros
    let mut seed = [0u8; 32];
    seed[0..2].copy_from_slice(&0x5337u16.to_le_bytes());
    let digest: [u8; 32] = Pedersen_256::<Felt>::merge_with_int(winter_crypto::hash::ByteDigest(seed), 1u64).0;
    let mut digest_endian = [0u8; 32];
    for (src, dst) in digest.iter().rev().zip(digest_endian.iter_mut()) {
        *dst = *src;
    }
    let hex_string = hex::encode(digest_endian);
    Ok(hex_string)
}

#[pyfunction]
fn draw_felt() -> Result<String, WinterVerifierError> {
    let mut public_coin_seed = vec![0u8; 32];
    public_coin_seed[0..2].copy_from_slice(&0x5337u16.to_le_bytes());
    let mut public_coin = RandomCoin::<Felt, Pedersen_256<Felt>>::new(&public_coin_seed);
    let z = public_coin
        .draw::<Felt>()
        .map_err(|_| VerifierError::RandomCoinError)?;
    let digest = z.to_raw();
    let mut digest_endian = [0u8; 32];
    write_be_bytes(digest.0, &mut digest_endian);
    let hex_string = hex::encode(digest_endian);
    Ok(hex_string)
}

#[pyfunction]
fn draw_integers() -> Result<String, WinterVerifierError> {
    let mut public_coin_seed = vec![0u8; 32];
    public_coin_seed[0..2].copy_from_slice(&0x5337u16.to_le_bytes());
    let mut public_coin = RandomCoin::<Felt, Pedersen_256<Felt>>::new(&public_coin_seed);
    let z = public_coin
        .draw_integers(20, 64)
        .map_err(|_| VerifierError::RandomCoinError)?;

    let hex_string = z[0].to_string(); // TODO: serialize all ints to hex
    Ok(hex_string)
}

#[pyfunction]
fn hash_elements() -> Result<String, PyErr> {
    let mut data = Vec::new();
    data.push(Felt::from(1u8));
    data.push(Felt::from(0u8));
    let mut digest: [u8; 32] = Pedersen_256::hash_elements(&data)
        .as_bytes()
        .try_into()
        .expect("slice with incorrect length");
    digest.reverse();
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
    let path = String::from("tests/integration/stark_proofs/fibonacci.bin");
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
    let path = String::from("tests/integration/stark_proofs/fibonacci.bin");
    let data = BinaryProofData::from_file(&path);
    let pub_inputs = PublicInputs::read_from(&mut SliceReader::new(&data.input_bytes[..])).unwrap();

    let mut pub_mem_hash = get_pub_mem_hash().to_bytes_be();
    pub_mem_hash.reverse();
    let digest = pedersen_hash(&[
            pub_inputs.init.pc,
            pub_inputs.init.ap,
            pub_inputs.init.fp,
            pub_inputs.fin.pc,
            pub_inputs.fin.ap,
            pub_inputs.fin.fp,
            Felt::from(pub_inputs.rc_min),
            Felt::from(pub_inputs.rc_max),
            Felt::from(pub_inputs.mem.0.len()),
            Felt::from(pub_mem_hash),
            Felt::from(pub_inputs.num_steps),
        ].iter().map(|x| Fe::from_bytes_be(&{
            let mut data = [0u8; 32];
            for (src, dst) in x.to_raw().to_le_bytes().iter().rev().zip(data.iter_mut()) {
                *dst = *src;
            }
            data
        }).unwrap()).fold(Fe::from(0u8), |hash, item| pedersen_hash(&hash, &item)),
        &Fe::from(11u8)
    );

    let hex_string = hex::encode(digest.to_bytes_be());
    Ok(hex_string)
}

#[pyfunction]
fn evaluation_data<'a>() -> Result<HashMap<&'a str, String>, WinterVerifierError> {
    let path = String::from("tests/integration/stark_proofs/fibonacci.bin");

    let data = BinaryProofData::from_file(&path);
    let proof = StarkProof::from_bytes(&data.proof_bytes).unwrap();
    let pub_inputs = PublicInputs::read_from(&mut SliceReader::new(&data.input_bytes[..])).unwrap();

    let mut public_coin_seed = Vec::new();
    Serializable::write_into(&pub_inputs, &mut public_coin_seed);

    let air = ProcessorAir::new(
        proof.get_trace_info(),
        pub_inputs.clone(),
        proof.options().clone(),
    );

    let mut public_coin = RandomCoin::<Felt, Pedersen_256<Felt>>::new(&public_coin_seed);
    let mut channel = VerifierChannel::<
        Felt,
        Pedersen_256<Felt>,
        MainEvaluationFrame<Felt>,
        AuxEvaluationFrame<Felt>,
    >::new(&air, proof.clone())?;

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
    let constraint_coeffs_coin = public_coin.to_cairo_memory();
    let constraint_coeffs = air
        .get_constraint_composition_coefficients::<Felt, Pedersen_256<Felt>>(&mut public_coin)
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
        constraint_coeffs.clone(),
        &ood_main_trace_frame,
        &ood_aux_trace_frame,
        aux_trace_rand_elements.clone(),
        z,
    );

    if let Some(ref aux_trace_frame) = ood_aux_trace_frame {
        for i in 0..<ProcessorAir as Air>::Frame::<Felt>::num_rows() {
            let mut row = ood_main_trace_frame.row(i).to_vec();
            row.extend_from_slice(aux_trace_frame.row(i));
            public_coin.reseed(Pedersen_256::<Felt>::hash_elements(&row));
        }
    } else {
        for i in 0..<ProcessorAir as Air>::Frame::<Felt>::num_rows() {
            public_coin.reseed(Pedersen_256::<Felt>::hash_elements(ood_main_trace_frame.row(i)));
        }
    }

    // Constraint evaluations
    let t_constraints = air.get_transition_constraints(&constraint_coeffs.transition);
    let mut t_evaluations1 = Felt::zeroed_vector(t_constraints.num_main_constraints());
    let mut t_evaluations2 = Felt::zeroed_vector(t_constraints.num_aux_constraints());
    air.evaluate_transition(&ood_main_trace_frame, &[], &mut t_evaluations1);
    air.evaluate_aux_transition(
        &ood_main_trace_frame,
        &ood_aux_trace_frame.as_ref().unwrap(),
        &[],
        &aux_trace_rand_elements,
        &mut t_evaluations2,
    );

    // reduce_pub_mem
    //
    let last_step = air.context().trace_len() - 1;
    let random_elements = aux_trace_rand_elements.get_segment_elements(0);
    let mem = pub_inputs.clone().mem;
    let z0 = random_elements[0];
    let alpha = random_elements[1];
    let num = z0.exp((mem.0.len() as u64).into());

    let den = mem
        .0
        .iter()
        .zip(&mem.1)
        .map(|(a, v)| z0 - (Felt::from(*a as u64) + alpha * Felt::from(v.unwrap().word())))
        .reduce(|a, b| a * b)
        .unwrap();

    let reduced_pub_mem = num / den;

    // Boundary constraint evaluations
    let b_constraints =
        air.get_boundary_constraints(&aux_trace_rand_elements, &constraint_coeffs.boundary);
    let mut degree_adjustment = b_constraints.main_constraints()[0].degree_adjustment();
    let mut xp = z.exp(degree_adjustment.into());
    let mut b_constraints_main_result = Felt::ZERO;
    let mut b_constraints_aux_result = Felt::ZERO;
    for group in b_constraints.main_constraints().iter() {
        if group.degree_adjustment() != degree_adjustment {
            degree_adjustment = group.degree_adjustment();
            xp = z.exp(degree_adjustment.into());
        }
        b_constraints_main_result += group.evaluate_at(ood_main_trace_frame.row(0), z, xp);
    }
    for group in b_constraints.aux_constraints().iter() {
        if group.degree_adjustment() != degree_adjustment {
            degree_adjustment = group.degree_adjustment();
            xp = z.exp(degree_adjustment.into());
        }
        b_constraints_aux_result +=
            group.evaluate_at(ood_aux_trace_frame.as_ref().unwrap().row(0), z, xp);
    }

    let ood_constraint_evaluations = channel.read_ood_constraint_evaluations();
    public_coin.reseed(Pedersen_256::<Felt>::hash_elements(&ood_constraint_evaluations));


    // 4 ----- FRI commitments --------------------------------------------------------------------
    // draw coefficients for computing DEEP composition polynomial from the public coin; in the
    // interactive version of the protocol, the verifier sends these coefficients to the prover
    // and the prover uses them to compute the DEEP composition polynomial. the prover, then
    // applies FRI protocol to the evaluations of the DEEP composition polynomial.
    let deep_coefficients_coin = public_coin.to_cairo_memory();
    let deep_coefficients = air
        .get_deep_composition_coefficients::<Felt, Pedersen_256<Felt>>(&mut public_coin)
        .map_err(|_| VerifierError::RandomCoinError)?;

    // instantiates a FRI verifier with the FRI layer commitments read from the channel. From the
    // verifier's perspective, this is equivalent to executing the commit phase of the FRI protocol.
    // The verifier uses these commitments to update the public coin and draw random points alpha
    // from them; in the interactive version of the protocol, the verifier sends these alphas to
    // the prover, and the prover uses them to compute and commit to the subsequent FRI layers.
    let fri_verifier = FriVerifier::new(
        &mut channel,
        &mut public_coin,
        air.options().to_fri_options(),
        air.trace_poly_degree(),
    )
    .map_err(VerifierError::FriVerificationFailed)?;


    // 5 ----- trace and constraint queries -------------------------------------------------------
    // read proof-of-work nonce sent by the prover and update the public coin with it
    let pow_nonce = channel.read_pow_nonce();
    public_coin.reseed_with_int(pow_nonce);

    // make sure the proof-of-work specified by the grinding factor is satisfied
    if public_coin.leading_zeros() < air.options().grinding_factor() {
        return Err(WinterVerifierError(VerifierError::QuerySeedProofOfWorkVerificationFailed));
    }


    // draw pseudo-random query positions for the LDE domain from the public coin; in the
    // interactive version of the protocol, the verifier sends these query positions to the prover,
    // and the prover responds with decommitments against these positions for trace and constraint
    // composition polynomial evaluations.
    let query_positions = public_coin
        .draw_integers(air.options().num_queries(), air.lde_domain_size())
        .map_err(|_| VerifierError::RandomCoinError)?;

    // read evaluations of trace and constraint composition polynomials at the queried positions;
    // this also checks that the read values are valid against trace and constraint commitments
    let (queried_main_trace_states, queried_aux_trace_states) =
        channel.read_queried_trace_states(&query_positions)?;
    let queried_constraint_evaluations = channel.read_constraint_evaluations(&query_positions)?;

    // 6 ----- DEEP composition -------------------------------------------------------------------
    // compute evaluations of the DEEP composition polynomial at the queried positions
    let composer = DeepComposer::new(&air, &query_positions, z, deep_coefficients.clone());
    let t_composition = composer.compose_trace_columns(
        queried_main_trace_states.clone(),
        queried_aux_trace_states.clone(),
        ood_main_trace_frame.clone(),
        ood_aux_trace_frame.clone(),
    );
    let c_composition = composer
        .compose_constraint_evaluations(queried_constraint_evaluations.clone(), ood_constraint_evaluations.clone());
    let deep_evaluations = composer.combine_compositions(t_composition.clone(), c_composition.clone());

    // Evaluation data
    let mut data = HashMap::new();
    data.insert(
        "air",
        air.to_cairo_memory(ProcessorAirParams {
            proof: &proof,
            public_inputs: &pub_inputs,
        }),
    );
    data.insert(
        "aux_trace_rand_elements",
        aux_trace_rand_elements.to_cairo_memory(),
    );
    data.insert(
        "b_constraints_main_result",
        b_constraints_main_result.to_raw().to_string(),
    );
    data.insert(
        "b_constraints_aux_result",
        b_constraints_aux_result.to_raw().to_string(),
    );
    data.insert(
        "combine_evaluations_result",
        t_constraints
            .combine_evaluations::<Felt>(&t_evaluations1, &t_evaluations2, z)
            .to_raw()
            .to_string(),
    );
    data.insert("constraint_coeffs", constraint_coeffs.to_cairo_memory());
    data.insert("constraint_coeffs_coin", constraint_coeffs_coin);
    data.insert(
        "ood_constraint_evaluation",
        ood_constraint_evaluation_1.to_raw().to_string(),
    );
    data.insert(
        "ood_constraint_evaluations",
        ood_constraint_evaluations
            .iter()
            .fold(String::new(), |a, x| a + ", " + &x.to_raw().to_string()),
    );
    data.insert(
        "ood_main_trace_frame",
        ood_main_trace_frame.to_cairo_memory(),
    );
    data.insert(
        "ood_aux_trace_frame",
        ood_aux_trace_frame.unwrap().to_cairo_memory(),
    );
    data.insert("reduced_pub_mem", reduced_pub_mem.to_raw().to_string());
    data.insert(
        "t_evaluations1",
        t_evaluations1
            .iter()
            .fold(String::new(), |a, x| a + ", " + &x.to_raw().to_string()),
    );
    data.insert(
        "t_evaluations2",
        t_evaluations2
            .iter()
            .fold(String::new(), |a, x| a + ", " + &x.to_raw().to_string()),
    );
    data.insert(
        "deep_coefficients",
        deep_coefficients.to_cairo_memory(),
    );
    data.insert(
        "deep_coefficients_coin",
        deep_coefficients_coin,
    );
    data.insert(
        "deep_coefficients_trace_len",
        deep_coefficients.trace.len().to_string()
    );
    data.insert(
        "deep_coefficients_constraints_len",
        deep_coefficients.constraints.len().to_string()
    );
    data.insert(
        "composer",
        composer.to_cairo_memory()
    );
    data.insert(
        "queried_constraint_evaluations",
        queried_constraint_evaluations.to_cairo_memory()
    );
    data.insert(
        "c_composition",
        c_composition
        .iter()
        .fold(String::new(), |a, x| a + ", " + &x.to_raw().to_string()),
    );
    data.insert(
        "t_composition",
        t_composition
        .iter()
        .fold(String::new(), |a, x| a + ", " + &x.to_raw().to_string()),
    );
    data.insert(
        "deep_evaluations",
        deep_evaluations
        .iter()
        .fold(String::new(), |a, x| a + ", " + &x.to_raw().to_string()),
    );
    data.insert("z", z.to_raw().to_string());
    data.insert(
        "queried_main_trace_states",
        queried_main_trace_states.to_cairo_memory()
    );
    data.insert(
        "queried_aux_trace_states",
        queried_aux_trace_states.as_ref().unwrap().to_cairo_memory()
    );

    Ok(data)
}

/// A Python module implemented in Rust. The name of this function must ßmatch
/// the `lib.name` setting in the `Cargo.toml`, else Python will not be able to
/// import the module.
#[pymodule]
fn zerosync_hints(_py: Python<'_>, m: &PyModule) -> PyResult<()> {
    // Random coin
    m.add_function(wrap_pyfunction!(merge, m)?)?;
    m.add_function(wrap_pyfunction!(reseed_with_int, m)?)?;
    m.add_function(wrap_pyfunction!(merge_with_int, m)?)?;
    m.add_function(wrap_pyfunction!(draw_felt, m)?)?;
    m.add_function(wrap_pyfunction!(draw_integers, m)?)?;
    m.add_function(wrap_pyfunction!(hash_elements, m)?)?;
    // Seeding
    m.add_function(wrap_pyfunction!(pedersen_chain, m)?)?;
    m.add_function(wrap_pyfunction!(hash_pub_inputs, m)?)?;
    m.add_function(wrap_pyfunction!(seed_with_pub_inputs, m)?)?;
    // Evaluation
    m.add_function(wrap_pyfunction!(evaluation_data, m)?)?;
    Ok(())
}

fn write_be_bytes(value: [u64; 4], out: &mut [u8; 32]) {
    for (src, dst) in value.iter().rev().cloned().zip(out.chunks_exact_mut(8)) {
        dst.copy_from_slice(&src.to_be_bytes());
    }
}

fn write_le_bytes(value: [u64; 4], out: &mut [u8; 32]) {
    for (src, dst) in value.iter().zip(out.chunks_exact_mut(8)) {
        dst.copy_from_slice(&src.to_le_bytes());
    }
}
