from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_blake2s.blake2s import finalize_blake2s, STATE_SIZE_FELTS
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.hash import HashBuiltin
from starkware.cairo.common.math import assert_lt, assert_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.pow import pow
from starkware.cairo.common.hash_state import hash_finalize, hash_init, hash_update

from stark_verifier.air.air_instance import (
    AirInstance,
    air_instance_new,
    get_constraint_composition_coefficients,
    get_deep_composition_coefficients,
    ConstraintCompositionCoefficients
)
from stark_verifier.air.pub_inputs import PublicInputs, read_public_inputs, read_mem_values
from stark_verifier.air.stark_proof import (
    TraceLayout,
    ProofOptions,
    StarkProof,
    read_stark_proof
)
from stark_verifier.air.trace_info import TraceInfo
from stark_verifier.channel import (
    Channel,
    channel_new,
    read_constraint_commitment,
    read_constraint_evaluations,
    read_ood_trace_frame,
    read_ood_constraint_evaluations,
    read_pow_nonce,
    read_trace_commitments,
    read_queried_trace_states,
)
from stark_verifier.composer import (
    compose_constraint_evaluations,
    combine_compositions,
    compose_trace_columns,
    deep_composer_new,
)
from stark_verifier.crypto.random import (
    PublicCoin,
    draw,
    draw_elements,
    draw_integers,
    get_leading_zeros,
    hash_elements,
    random_coin_new,
    reseed,
    reseed_with_int,
    reseed_with_ood_frames,
    seed_with_pub_inputs,
    reseed_endian,
)
from stark_verifier.evaluator import evaluate_constraints
from stark_verifier.fri.fri_verifier import fri_verifier_new, fri_verify, to_fri_options
from stark_verifier.utils import Vec



// Verifies that the specified computation was executed correctly against the specified inputs.
//
// These subroutines are intended to be as close to a line-by-line transcription of the
// Winterfell verifier code (see https://github.com/novifinancial/winterfell and the associated
// LICENSE.winterfell.md)
func verify{range_check_ptr, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*}(
    proof: StarkProof*, pub_inputs: PublicInputs*
) {
    alloc_locals;

    let (__fp__, _) = get_fp_and_pc();

    // Initialize hasher
    let (blake2s_ptr: felt*) = alloc();
    local blake2s_ptr_start: felt* = blake2s_ptr;

    // Build a seed for the public coin; the initial seed is the hash of public inputs
    let public_coin_seed: felt* = seed_with_pub_inputs{blake2s_ptr=blake2s_ptr}(pub_inputs);

    // Create an AIR instance for the computation specified in the proof.
    let air = air_instance_new(proof, pub_inputs, proof.context.options);

    // Create a public coin and channel struct
    with blake2s_ptr {
        let public_coin = random_coin_new(public_coin_seed, 32);
    }
    let channel = channel_new(air, proof);

    with blake2s_ptr, channel, public_coin {
        perform_verification(air=air);
    }

    // finalize_blake2s(blake2s_ptr_start, blake2s_ptr); // TODO: uncomment this line before deployment. Otherwise, the proof is INSECURE!

    return ();
}

// Performs the actual verification by reading the data from the `channel` and making sure it
// attests to a correct execution of the computation specified by the provided `air`.
func perform_verification{
    range_check_ptr,
    blake2s_ptr: felt*,
    pedersen_ptr: HashBuiltin*, 
    bitwise_ptr: BitwiseBuiltin*,
    channel: Channel,
    public_coin: PublicCoin,
}(air: AirInstance) {
    alloc_locals;

    // 1 ----- Trace commitment -------------------------------------------------------------------

    // Read the commitments to evaluations of the trace polynomials over the LDE domain.
    let trace_commitments = read_trace_commitments();

    // Reseed the coin with the commitment to the main trace segment
    reseed_endian(value=trace_commitments);

    // Process auxiliary trace segments to build a set of random elements for each segment,
    // and to reseed the coin.
    let (aux_trace_rand_elements: felt**) = alloc();
    process_aux_segments(
        trace_commitments=trace_commitments + STATE_SIZE_FELTS,
        trace_commitments_len=air.context.trace_layout.num_aux_segments,
        aux_segment_rands=air.context.trace_layout.aux_segment_rands,
        aux_trace_rand_elements=aux_trace_rand_elements,
    );


    // Build random coefficients for the composition polynomial
    let constraint_coeffs = get_constraint_composition_coefficients(air=air);

    // 2 ----- Constraint commitment --------------------------------------------------------------

    // Read the commitment to evaluations of the constraint composition polynomial over the LDE
    // domain sent by the prover.
    let constraint_commitment = read_constraint_commitment();

    // Update the public coin.
    reseed_endian(value=constraint_commitment);

    // Draw an out-of-domain point z from the coin.
    let z = draw();

    // 3 ----- OOD consistency check --------------------------------------------------------------

    // Read the out-of-domain trace frames (the main trace frame and auxiliary trace frame, if
    // provided) sent by the prover.
    let (ood_main_trace_frame, ood_aux_trace_frame) = read_ood_trace_frame();

    // Evaluate constraints over the OOD frames.
    let ood_constraint_evaluation_1 = evaluate_constraints(
        air=air,
        coeffs=constraint_coeffs,
        ood_main_trace_frame=ood_main_trace_frame,
        ood_aux_trace_frame=ood_aux_trace_frame,
        aux_trace_rand_elements=aux_trace_rand_elements,
        z=z,
    );

    // Reseed the public coin with the OOD frames.
    reseed_with_ood_frames(
       ood_main_trace_frame=ood_main_trace_frame, ood_aux_trace_frame=ood_aux_trace_frame
    );

    // Read evaluations of composition polynomial columns sent by the prover, and reduce them into
    // a single value by computing sum(z^i * value_i), where value_i is the evaluation of the ith
    // column polynomial at z^m, where m is the total number of column polynomials. Also, reseed
    // the public coin with the OOD constraint evaluations received from the prover.
    let ood_constraint_evaluations = read_ood_constraint_evaluations();
    let ood_constraint_evaluation_2 = reduce_evaluations(
        evaluations=ood_constraint_evaluations.elements, 
        evaluations_len=ood_constraint_evaluations.n_elements, 
        z=z,
        index=0
    );
    let value = hash_elements(
       n_elements=ood_constraint_evaluations.n_elements,
       elements=ood_constraint_evaluations.elements,
    );
    reseed_endian(value=value);

    // Finally, make sure the values are the same.
    with_attr error_message(
           "Ood constraint evaluations differ. ${ood_constraint_evaluation_1} != ${ood_constraint_evaluation_2}") {
       assert ood_constraint_evaluation_1 = ood_constraint_evaluation_2;
    }

    // 4 ----- FRI commitments --------------------------------------------------------------------

    // Draw coefficients for computing DEEP composition polynomial from the public coin.
    let deep_coefficients = get_deep_composition_coefficients(air=air);

    // Instantiates a FRI verifier with the FRI layer commitments read from the channel. From the
    // verifier's perspective, this is equivalent to executing the commit phase of the FRI protocol.
    // The verifier uses these commitments to update the public coin and draw random points alpha
    // from them.
    let fri_context = to_fri_options(air.context.options);
    let max_poly_degree = air.context.trace_length - 1;
    let fri_verifier = fri_verifier_new(fri_context, max_poly_degree);


    // 5 ----- Trace and constraint queries -------------------------------------------------------

    // Read proof-of-work nonce sent by the prover and update the public coin with it.
    let pow_nonce = read_pow_nonce();
    reseed_with_int(pow_nonce);

    // Make sure the proof-of-work specified by the grinding factor is satisfied.
    let leading_zeros = get_leading_zeros(public_coin.seed);
    with_attr error_message("Insufficient proof of work") {
        assert_le(air.options.grinding_factor, leading_zeros);
    }

    // Draw pseudorandom query positions for the LDE domain from the public coin.
    let (query_positions: felt*) = alloc();
    draw_integers(
       n_elements=air.options.num_queries,
       elements=query_positions,
       domain_size=air.context.lde_domain_size,
    );

    // Read evaluations of trace and constraint composition polynomials at the queried positions.
    // This also checks that the read values are valid against trace and constraint commitments.
    let (queried_main_trace_states, queried_aux_trace_states) = read_queried_trace_states(
       query_positions
    );
    let queried_constraint_evaluations = read_constraint_evaluations(query_positions);

    // 6 ----- DEEP composition -------------------------------------------------------------------

    // Compute evaluations of the DEEP composition polynomial at the queried positions.
    let composer = deep_composer_new(
        air=air, query_positions=query_positions, z=z, cc=deep_coefficients
    );
    let t_composition = compose_trace_columns(
        composer,
        queried_main_trace_states,
        queried_aux_trace_states,
        ood_main_trace_frame,
        ood_aux_trace_frame,
    );
    let c_composition = compose_constraint_evaluations(
        composer, queried_constraint_evaluations, ood_constraint_evaluations
    );
    let deep_evaluations = combine_compositions(composer, t_composition, c_composition);

    // 7 ----- Verify low-degree proof -------------------------------------------------------------

    // Make sure that evaluations of the DEEP composition polynomial we computed in the previous
    // step are in fact evaluations of a polynomial of degree equal to trace polynomial degree.
    fri_verify(fri_verifier, deep_evaluations, query_positions);

    return ();
}

func process_aux_segments{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    channel: Channel,
    public_coin: PublicCoin,
}(
    trace_commitments: felt*,
    trace_commitments_len: felt,
    aux_segment_rands: felt*,
    aux_trace_rand_elements: felt**,
) {
    if (trace_commitments_len == 0) {
        return ();
    }
    let (elements) = alloc();
    assert [aux_trace_rand_elements] = elements;
    draw_elements(n_elements=[aux_segment_rands], elements=elements);
    reseed_endian(value=trace_commitments);
    process_aux_segments(
        trace_commitments=trace_commitments + STATE_SIZE_FELTS,
        trace_commitments_len=trace_commitments_len - 1,
        aux_segment_rands=aux_segment_rands + 1,
        aux_trace_rand_elements=aux_trace_rand_elements + 1,
    );
    return ();
}

func reduce_evaluations{
    range_check_ptr
}(
    evaluations: felt*,
    evaluations_len,
    z,
    index
) -> felt {
    if (evaluations_len == 0){
        return 0;
    }
    alloc_locals;
    let acc = reduce_evaluations(evaluations + 1, evaluations_len - 1, z, index + 1);
    let (pow_z) = pow(z, index);
    return acc + pow_z * [evaluations];
}



func read_and_verify_stark_proof{
        pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
    }() -> (felt, felt*){
    alloc_locals;
    let pub_inputs_ptr = read_public_inputs();
    let pub_inputs = [pub_inputs_ptr];

    let initial_pc = pub_inputs.init._pc;
    let initial_fp = pub_inputs.init._ap;
    let memory = pub_inputs.mem + initial_pc;
    // Read the program from the public memory
    let (program: felt*) = alloc();
    let program_end_pc = initial_fp - 2;
    let program_length = program_end_pc - initial_pc;
    read_mem_values(
        mem=memory, address=6, length=program_length, output=program
    );


    // Compute the program hash
    let (hash_state_ptr) = hash_init();
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(
        hash_state_ptr=hash_state_ptr, data_ptr=program, data_length=program_length
    );
    let (program_hash) = hash_finalize{hash_ptr=pedersen_ptr}(hash_state_ptr=hash_state_ptr);

    // Read the parent proof from the location it was written to by main.py
    let proof = read_stark_proof();

    // Verify the proof with its public inputs using the verifier
    verify(proof, pub_inputs_ptr);

    // Read the output values from the public memory    
    let (mem_values: felt*) = alloc();
    let memory = memory + program_length;
    let mem_values_len = pub_inputs.mem_length - program_length - initial_pc;
    read_mem_values(
        mem=memory, address=6+program_length, length=mem_values_len, output=mem_values
    );

    return (program_hash, mem_values);
}

