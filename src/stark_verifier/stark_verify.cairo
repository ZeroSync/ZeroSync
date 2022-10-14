%builtins range_check bitwise

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_blake2s.blake2s import finalize_blake2s
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256

from stark_verifier.channel import (
    Channel,
    channel_new,
    read_constraint_commitment,
    read_ood_trace_frame,
    read_ood_constraint_evaluations,
    read_trace_commitments,
)
from stark_verifier.crypto.random import (
    PublicCoin,
    draw_random,
    hash_elements,
    random_coin_new,
    reseed,
    reseed_with_int,
    seed_with_pub_inputs,
    seed_with_proof_context,
)
from stark_verifier.air.air_instance import (
    AirInstance,
    air_instance_new,
    get_constraint_composition_coefficients,
)
from stark_verifier.air.pub_inputs import PublicInputs
from stark_verifier.air.stark_proof import (
    Queries,
    Context,
    TraceLayout,
    ProofOptions,
    Commitments,
    FriProof,
    OodFrame,
    StarkProof,
    read_stark_proof,
)

// Verifies that the specified computation was executed correctly against the specified inputs.
func verify{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
}(proof: StarkProof, pub_inputs: PublicInputs) -> () {
    alloc_locals;

    // Build a seed for the public coin; the initial seed is the hash of public inputs and proof
    // context, but as the protocol progresses, the coin will be reseeded with the info received
    // from the prover.
    //
    // TODO: Winterfell serializes public input and context structs into a vector of bytes, which 
    // is expensive to do in Cairo (but doable). We may want to modify the prover so that these 
    // are serialized using field elements.
    //
    //let (public_coin_seed: felt*) = alloc();
    //let (public_coin_seed_2) = seed_with_pub_inputs(pub_inputs, seed=public_coin_seed);
    //let (public_coin_seed_3) = seed_with_proof_context(proof.context, seed=public_coin_seed_2);

    // Create an AIR instance for the computation specified in the proof.
    let (air) = air_instance_new();

    // Create a public coin and channel struct
    let (public_coin) = random_coin_new(Uint256(0,0)); //public_coin_seed_3);
    let (channel) = channel_new(air, proof);

    // Initialize hasher
    let (blake2s_ptr: felt*) = alloc();
    local blake2s_ptr_start: felt* = blake2s_ptr;

    with blake2s_ptr, channel, public_coin { 
        perform_verification(air=air);
    }

    finalize_blake2s(blake2s_ptr_start, blake2s_ptr);

    return ();
}

// Performs the actual verification by reading the data from the `channel` and making sure it
// attests to a correct execution of the computation specified by the provided `air`.
func perform_verification{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    channel: Channel,
    public_coin: PublicCoin,
}(
    air: AirInstance
) -> () {
    alloc_locals;

    // 1 ----- Trace commitment -------------------------------------------------------------------

    // Read the commitments to evaluations of the trace polynomials over the LDE domain.
    let (trace_commitments) = read_trace_commitments();

    // Reseed the coin with the commitment to the main trace segment
    reseed(value=trace_commitments[0]);

    // Process auxiliary trace segments (if any), to build a set of random elements for each segment,
    // and to reseed the coin.
    let (aux_trace_rand_elements: felt*) = alloc();
    process_aux_segments(
        trace_commitments=trace_commitments + 1,
        aux_trace_rand_elements=aux_trace_rand_elements,
    );

    // Build random coefficients for the composition polynomial
    let (constraint_coeffs) = get_constraint_composition_coefficients(air=air);

    // 2 ----- Constraint commitment --------------------------------------------------------------

    // Read the commitment to evaluations of the constraint composition polynomial over the LDE
    // domain sent by the prover.
    let (constraint_commitment) = read_constraint_commitment();
    
    // Update the public coin.
    reseed(value=constraint_commitment);
    
    // Draw an out-of-domain point z from the coin.
    let (z) = draw_random();

    // 3 ----- OOD consistency check --------------------------------------------------------------

    // Read the out-of-domain trace frames (the main trace frame and auxiliary trace frame, if
    // provided) sent by the prover.
    // let (ood_main_trace_frame, ood_aux_trace_frame) = read_ood_trace_frame();

    // Evaluate constraints over the OOD frames.
    // let (ood_constraint_evaluation_1) = evaluate_constraints(
    //     air=air,
    //     constraint_coeffs=constraint_coeffs,
    //     ood_main_trace_frame=ood_main_trace_frame,
    //     ood_aux_trace_frame=ood_aux_trace_frame,
    //     aux_trace_rand_elements=aux_trace_rand_elements,
    //     z=z,
    // );

    // Reseed the public coin with the OOD frames.
    // reseed_with_ood_frames(
    //     ood_main_trace_frame=ood_main_trace_frame,
    //     ood_aux_trace_frame=ood_aux_trace_frame,
    // );

    // read evaluations of composition polynomial columns sent by the prover, and reduce them into
    // a single value by computing sum(z^i * value_i), where value_i is the evaluation of the ith
    // column polynomial at z^m, where m is the total number of column polynomials; also, reseed
    // the public coin with the OOD constraint evaluations received from the prover.
    // let (ood_constraint_evaluations) = read_ood_constraint_evaluations();

    // let (ood_constraint_evaluation_2) = reduce_evaluations(evaluations=ood_constraint_evaluations);
    // reseed(value=hash_elements(
    //     n_elements=ood_constraint_evaluations.n_elements,
    //     elements=ood_constraint_evaluations.elements,
    // ));

    // finally, make sure the values are the same
    // assert ood_constraint_evaluation_1 == ood_constraint_evaluation_2;

    return ();
}

func process_aux_segments{
    channel: Channel,
    public_coin: PublicCoin,
}(trace_commitments: Uint256*, aux_trace_rand_elements: felt*) -> () {
    // TODO
    return ();
}

func main{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
}() -> () {
    
    // TODO: Deserialize proof
    let (constraint_queries: Queries*) = alloc();
    let (trace_meta) = alloc();
    let (field_modulus_bytes) = alloc();
    let proof = StarkProof(
        context=Context(TraceLayout(0,0,0,0), 0, trace_meta, field_modulus_bytes, ProofOptions(0,0,0,0,0,0,0) ),
        commitments=Commitments(),
        trace_queries=Queries(),
        constraint_queries=constraint_queries,
        ood_frame=OodFrame(),
        fri_proof=FriProof(),
        pow_nonce=0,
    );
    let pub_inputs = PublicInputs();

    verify(proof=proof, pub_inputs=pub_inputs);
    return ();
}
