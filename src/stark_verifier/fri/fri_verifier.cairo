from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.hash import HashBuiltin
from starkware.cairo.common.math import assert_le, assert_nn_le, assert_not_zero, horner_eval, unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.pow import pow
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.memset import memset
from starkware.cairo.common.registers import get_fp_and_pc

from stark_verifier.air.air_instance import AirInstance
from stark_verifier.air.stark_proof import ProofOptions
from stark_verifier.crypto.random import PublicCoin, draw, reseed, contains, hash_elements
from stark_verifier.fri.polynomials import lagrange_eval, interpolate_poly_and_verify
from utils.pow2 import pow2
from stark_verifier.channel import Channel, verify_merkle_proof, QueriesProof, read_remainder
from crypto.hash_utils import assert_hashes_equal, HASH_FELT_SIZE
from stark_verifier.parameters import TWO_ADIC_ROOT_OF_UNITY, TWO_ADICITY, FOLDING_FACTOR, MULTIPLICATIVE_GENERATOR, NUM_QUERIES
from stark_verifier.utils import Vec

// g: domain offset
const g = MULTIPLICATIVE_GENERATOR;

struct FriQueryProof{
    length : felt,
    path : felt*,
    values: felt*,
}

func read_fri_proofs {
    range_check_ptr, blake2s_ptr: felt*, channel: Channel, bitwise_ptr: BitwiseBuiltin*
    }(positions: felt*) -> FriQueryProof** {
    alloc_locals;

    let (local fri_queries_proof_ptr: FriQueryProof**) = alloc();
    %{
        from src.stark_verifier.utils import read_fri_queries_proofs
        read_fri_queries_proofs(ids.positions, ids.fri_queries_proof_ptr, ids.NUM_QUERIES, memory, segments)
    %}

    return fri_queries_proof_ptr;
}


struct FriOptions {
    max_remainder_size: felt,
    blowup_factor: felt,
}

func to_fri_options(proof_options: ProofOptions) -> FriOptions {
    let max_remainder_size = proof_options.fri_max_remainder_size;
    let fri_options = FriOptions(
        max_remainder_size,
        proof_options.blowup_factor
    );
    return fri_options;
}

struct FriVerifier {
    max_poly_degree: felt,
    domain_size: felt,
    domain_generator: felt,
    layer_commitments: felt*,
    layer_alphas: felt*,
    options: FriOptions,
    max_remainder_degree: felt,
}


func _fri_verifier_new{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    public_coin: PublicCoin,
}(
    layer_commitment_ptr: felt*,
    layer_alpha_ptr: felt*,
    count: felt,
) {
    if (count == 0) {
        return ();
    }
    alloc_locals;

    reseed(layer_commitment_ptr);
    let alpha = draw();
    assert [layer_alpha_ptr] = alpha;

    return _fri_verifier_new(
        layer_commitment_ptr + HASH_FELT_SIZE,
        layer_alpha_ptr + 1,
        count - 1
    );
}

func fri_verifier_new{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    public_coin: PublicCoin,
    channel: Channel
}(
    options: FriOptions,
    max_poly_degree
) -> FriVerifier {

    alloc_locals;

    let _next_power_of_two = next_power_of_two(max_poly_degree);
    let domain_size = _next_power_of_two * options.blowup_factor;

    let domain_size_log2 = log2(domain_size);
    let domain_generator = get_root_of_unity(domain_size_log2);

    // read layer commitments from the channel and use them to build a list of alphas
    let (layer_alphas) = alloc();
    let layer_commitments = channel.fri_roots;
    _fri_verifier_new(
        layer_commitment_ptr = layer_commitments,
        layer_alpha_ptr = layer_alphas,
        count = channel.fri_roots_len
    );

    let num_folding_factor_bits = log2(FOLDING_FACTOR);
    // This  log2  implementation verifies  max_poly_degree + 1  to be a power of two.
    let num_max_poly_degree_bits = log2(max_poly_degree + 1);
    let max_degree = pow2(num_max_poly_degree_bits - (channel.fri_roots_len - 1) * num_folding_factor_bits);
    let max_degree_plus_1 = max_degree + 1;

    let res = FriVerifier(
        max_poly_degree,
        domain_size,
        domain_generator,
        layer_commitments,
        layer_alphas,
        options,
        max_degree_plus_1,
    );
    return res;
}


func next_power_of_two{range_check_ptr}(x) -> felt {
    alloc_locals;
    local n_bits;
    %{
        ids.n_bits = len( bin(ids.x - 1).replace('0b', '') )
    %}
    local next_power_of_two = pow2(n_bits);
    local x2_1 = x*2-1;
    with_attr error_message("{x} <= {next_power_of_two} <= {x2_1}") {
        assert_le(x, next_power_of_two);
        assert_le(next_power_of_two, x * 2 - 1);
    }
    return next_power_of_two;
}

func get_root_of_unity{range_check_ptr}(n) -> felt {
    with_attr error_message("cannot get root of unity for n = 0") {
        assert_not_zero(n);
    }
    with_attr error_message("order cannot exceed 2^{TWO_ADICITY}") {
        assert_le(n, TWO_ADICITY);
    }
    let power = pow2(TWO_ADICITY - n);
    let (root_of_unity) = pow(TWO_ADIC_ROOT_OF_UNITY, power);
    return root_of_unity;
}

func log2(n) -> felt {
    alloc_locals;
    local n_bits;
    %{
        ids.n_bits = len( bin(ids.n - 1).replace('0b', '') )
    %}
    let next_power_of_two = pow2(n_bits);
    with_attr error_message("n must be a power of two") {
        assert next_power_of_two = n;
    }
    return n_bits;
}


func fri_verify{
    range_check_ptr, pedersen_ptr: HashBuiltin*, blake2s_ptr: felt*, channel: Channel, bitwise_ptr: BitwiseBuiltin*
    }(fri_verifier: FriVerifier, evaluations: felt*, positions: felt*
) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    // Read FRI Merkle proofs from a hint
    let fri_proofs = read_fri_proofs(positions);

    // Read remainders from a hint 
    // and check that a Merkle tree of the claimed remainders hash to the final layer commitment
    let remainder: Vec = read_remainder();
    let remainder_ptr: Vec* = &remainder;


    let num_layers = num_fri_layers(&fri_verifier, fri_verifier.domain_size); 

    // Initialize an empty array of verified positions for each layer
    let (local verified_positions: felt**) = alloc();
    tempvar verified_positions_ptr = verified_positions;
    tempvar n = num_layers;
    init_loop:
        let (array) = alloc();
        assert [verified_positions_ptr] = array;
        tempvar verified_positions_ptr = verified_positions_ptr + 1;
        tempvar n = n - 1;
    jmp init_loop if n != 0;

    let (verified_positions_len: felt*) = alloc();
    memset(verified_positions_len, 0, num_layers);

    // Compute the remaining folded roots of unity
    let (folding_roots) = alloc(); 
    let log2_domain_size = log2(fri_verifier.domain_size);
    compute_folding_roots(
        omega_folded = folding_roots,
        omega = fri_verifier.domain_generator,
        log_degree = log2_domain_size,
        i = 0
    );

    // Verify a round for each query
    verify_queries(
        &fri_verifier, 
        positions, 
        evaluations,
        NUM_QUERIES,
        fri_proofs,
        num_layers,
        verified_positions,
        verified_positions_len,
        folding_roots,
        remainder_ptr
    );

    // Ensure that the interpolated remainder polynomial is of degree <= max_remainder_degree
    verify_remainder_degree(
        remainders=remainder.elements,
        remainders_len=remainder.n_elements,
        max_degree=fri_verifier.max_remainder_degree - 1,
        domain_generator=fri_verifier.domain_generator,
        domain_size=fri_verifier.domain_size 
    );

    return ();
}


func verify_queries{
    range_check_ptr, 
    channel: Channel, 
    blake2s_ptr:felt*,
    bitwise_ptr: BitwiseBuiltin*
}(
    fri_verifier: FriVerifier*,
    positions: felt*,
    query_evaluations: felt*,
    num_queries: felt,
    fri_proofs: FriQueryProof**,
    num_layers: felt,
    verified_positions: felt**,
    verified_positions_len: felt*,
    folding_roots: felt*,
    remainders: Vec*
) {
    if (num_queries == 0) {
        return ();
    }
    alloc_locals;

    // Iterate over the layers within this query
    verify_layers(
        omega = fri_verifier.domain_generator,
        alphas = fri_verifier.layer_alphas,
        position = [positions],
        query_evaluations = query_evaluations,
        num_layer_evaluations = FOLDING_FACTOR * num_layers,
        num_layers = num_layers,
        previous_eval = 0,
        fri_proofs = fri_proofs,
        modulus = fri_verifier.domain_size / FOLDING_FACTOR,
        verified_positions = verified_positions,
        verified_positions_len = verified_positions_len,
        next_verified_positions_len = &verified_positions_len[num_layers],
        layer_commitments = channel.fri_roots,
        folding_roots = folding_roots,
        remainders = remainders
    );

    // Iterate over the remaining queries
    verify_queries(
        fri_verifier,
        &positions[1],
        &query_evaluations[1],
        num_queries - 1,
        fri_proofs,
        num_layers,
        verified_positions,
        &verified_positions_len[num_layers],
        folding_roots,
        remainders
    );
    return ();
}

func num_fri_layers{
        range_check_ptr
    }(fri_verifier: FriVerifier*, domain_size) -> felt{
    let is_leq = is_le(fri_verifier.options.max_remainder_size + 1, domain_size);
    if(is_leq == 0){
        return 0;
    }
    let res = num_fri_layers(fri_verifier, domain_size/FOLDING_FACTOR);
    return 1 + res;
}

// pre-compute roots of unity used in computing x coordinates in the folded domain
func compute_folding_roots{
    range_check_ptr
    }(omega_folded: felt*, omega, log_degree: felt, i: felt) {
    if (i == FOLDING_FACTOR) {
        return ();
    }
    let degree = pow2(log_degree);
    let new_domain_size = degree / FOLDING_FACTOR * i;
    let (res) = pow(omega, new_domain_size);
    assert [omega_folded] = res;
    compute_folding_roots(omega_folded + 1, omega, log_degree, i + 1);
    return ();
}

func verify_layers{
    range_check_ptr, 
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*
}(
    omega: felt,
    alphas: felt*,
    position: felt,
    query_evaluations: felt*,
    num_layer_evaluations: felt,
    num_layers: felt,
    previous_eval: felt,
    fri_proofs: FriQueryProof**,
    modulus: felt,
    verified_positions: felt**,
    verified_positions_len: felt*,
    next_verified_positions_len: felt*,
    layer_commitments: felt*,
    folding_roots: felt*,
    remainders: Vec*
) {
    alloc_locals;
    if (num_layers == 0) {
        // Check that the claimed remainder is equal to the final evaluation.
        assert_contains(remainders.elements, remainders.n_elements, query_evaluations[0]);
        return ();
    }

    let (_, folded_position) = unsigned_div_rem(position, modulus);


    // Check if we have already verified this folded_position
    local index: felt;
    let curr_len = verified_positions_len[0];
    let prev_positions = verified_positions[0];
    // This hint gives us the index of the position if included, or it returns -1
    %{
        from src.stark_verifier.utils import index_of
        ids.index = index_of(ids.prev_positions, ids.curr_len, ids.folded_position, memory)
    %}
    // If so, copy the previous verified_positions_len, and we're done
    if (index != -1){
        // Verify the index given by the hint
        assert folded_position = verified_positions[0][index];
        // Copy previous lenghts
        memcpy(next_verified_positions_len, verified_positions_len, num_layers);
        return ();
    }
    let index = curr_len;

    // Otherwise, verify this folded_position 
    assert verified_positions[0][index] = folded_position;
    // and add it to verified_positions
    assert next_verified_positions_len[0] = index + 1;


    // Verify that evaluations are consistent with the layer commitment
    let query_proof = fri_proofs[0][index];
    verify_merkle_proof(query_proof.length, query_proof.path, folded_position, layer_commitments);
    let leaf_hash = hash_elements(n_elements=FOLDING_FACTOR, elements=query_proof.values);
    assert_hashes_equal(leaf_hash, query_proof.path);                                                                                                                                                        
    let is_contained = contains(query_evaluations[0], query_proof.values, FOLDING_FACTOR);
    assert_not_zero(is_contained);

    // TODO: Compare previous polynomial evaluation with the current layer evaluation
    // if (previous_eval != 0) {
    //     assert previous_eval = query_evaluations[1];
    // }

    // Interpolate the evaluations at the x-coordinates, and evaluate at alpha.
    let alpha = [alphas];
    let (xe) = pow(omega, folded_position);
    local xe = xe * g;
    let (local x_values) = alloc();

    tempvar i = FOLDING_FACTOR;
    loop:
        assert x_values[i-1] = folding_roots[i-1] * xe;
        tempvar i = i - 1;
    jmp loop if i != 0;

    let previous_eval = lagrange_eval(query_proof.values, x_values, FOLDING_FACTOR, alpha);

    // Update variables for the next layer
    let (omega) = pow(omega, FOLDING_FACTOR);
    let modulus = modulus / FOLDING_FACTOR;
    let (query_evaluations) = alloc();
    assert query_evaluations[0] = previous_eval;

    return verify_layers(
        omega,
        alphas + 1,
        folded_position,
        query_evaluations,
        num_layer_evaluations,
        num_layers - 1,
        previous_eval,
        &fri_proofs[1],
        modulus,
        &verified_positions[1],
        &verified_positions_len[1],
        &next_verified_positions_len[1],
        &layer_commitments[HASH_FELT_SIZE],
        folding_roots,
        remainders
    );
}

func verify_remainder_degree{range_check_ptr, pedersen_ptr: HashBuiltin*}(
    remainders: felt*, remainders_len: felt, max_degree: felt, domain_generator, domain_size
) {
    alloc_locals;
    
    with_attr error_message("Remainder degree not valid"){
        assert_le(max_degree + 1, remainders_len);
    }

    // Roots of unity for remainder evaluation domain
    let k = log2(remainders_len);
    let omega_n = get_root_of_unity(k);
    let (omega_i) = alloc();
    get_roots_of_unity(omega_i, omega_n, 0, remainders_len);
    
    let remainders_poly = interpolate_poly_and_verify(omega_i, remainders, remainders_len);

    // Check that all polynomial coefficients greater than 'max_degree' are zero
    with_attr error_message("Remainder degree mismatch"){
        assert_zeroes(remainders_poly + max_degree, remainders_len - max_degree);
    }
    return ();
}

func get_roots_of_unity{range_check_ptr}(omega_i: felt*, omega_n: felt, i: felt, len: felt) {
    if (i == len) {
        return ();
    }
    let (x) = pow(omega_n, i);
    assert [omega_i] = x;
    get_roots_of_unity(omega_i + 1, omega_n, i + 1, len);
    return ();
}


func get_power_series(
    result: felt*, 
    base: felt, 
    loop_counter: felt, 
    accu: felt
    ){
    if (loop_counter == 0){
        return ();
    }
    assert [result] = accu;
    return get_power_series(result + 1, base, loop_counter - 1, accu * base);
}


func assert_zeroes(array: felt*, array_len){
    if(array_len == 0){
        return ();
    }
    assert 0 = [array];
    assert_zeroes(array + 1, array_len - 1);
    return ();
}

func assert_contains(elements:felt*, n_elements, element){
    alloc_locals;
    local index: felt;
    %{
        ids.index = index_of(ids.elements, ids.n_elements, ids.element, memory)
    %}
    // TODO: Do we have to verify that `0 < index < n_elements` here?
    assert element = elements[index];
    return ();
}