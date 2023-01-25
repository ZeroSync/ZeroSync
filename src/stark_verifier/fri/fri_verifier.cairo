from stark_verifier.air.air_instance import AirInstance
from stark_verifier.channel import Channel
from stark_verifier.air.stark_proof import ProofOptions
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from stark_verifier.crypto.random import PublicCoin, reseed, draw, reseed_endian
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_le, assert_not_zero
from starkware.cairo.common.pow import pow
from utils.pow2 import pow2
from stark_verifier.channel import verify_merkle_proof, QueriesProofs, QueriesProof
from stark_verifier.crypto.random import contains

struct FriOptions {
    folding_factor: felt,
    max_remainder_size: felt,
    blowup_factor: felt,
}

func to_fri_options(proof_options: ProofOptions) -> FriOptions {
    let folding_factor = proof_options.fri_folding_factor;
    let max_remainder_size = proof_options.fri_max_remainder_size; // stored as power of 2
    let fri_options = FriOptions(proof_options.blowup_factor, folding_factor, max_remainder_size);
    return fri_options;
}

struct FriVerifier {
    max_poly_degree: felt,
    domain_size: felt,
    domain_generator: felt,
    layer_commitments: felt*,
    layer_alphas: felt*,
    options: FriOptions,
    num_partitions: felt,
}

func _fri_verifier_new{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    public_coin: PublicCoin,
}(options: FriOptions, max_degree_plus_1, layer_commitment_ptr: felt*, layer_alpha_ptr: felt*, count) {
    if (count == 0) {
        return ();
    }
    alloc_locals;

    reseed_endian(layer_commitment_ptr);
    let alpha = draw();
    assert [layer_alpha_ptr] = alpha;


    _fri_verifier_new(options, max_degree_plus_1 / options.folding_factor, layer_commitment_ptr + 8, layer_alpha_ptr + 1, count - 1);
    return ();
}

func fri_verifier_new{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    public_coin: PublicCoin,
    channel: Channel
}(options: FriOptions, max_poly_degree) -> FriVerifier {

    alloc_locals;

    let _next_power_of_two = next_power_of_two(max_poly_degree);
    let domain_size = _next_power_of_two * options.blowup_factor;

    let domain_size_log2 = log2(domain_size);
    let domain_generator = get_root_of_unity(domain_size_log2);
    // air.trace_domain_generator ?
    // air.lde_domain_generator ?

    let num_partitions = 1;
    // channel.read_fri_num_partitions() ?

    // read layer commitments from the channel and use them to build a list of alphas
    let (layer_alphas) = alloc();
    let layer_commitments = channel.fri_roots;
    %{ print('fri_roots_len', ids.channel.fri_roots_len) %}
    _fri_verifier_new(options, max_poly_degree + 1, layer_commitments, layer_alphas, channel.fri_roots_len);

    let res = FriVerifier(
        max_poly_degree,
        domain_size,
        domain_generator,
        layer_commitments,
        layer_alphas,
        options,
        num_partitions
    );
    return res;
}

func next_power_of_two{range_check_ptr}(x) -> felt {
    alloc_locals;
    local n_bits;
    %{
        ids.n_bits = len( bin(ids.x - 1).replace('0b', '') )
    %}
    let next_power_of_two = pow2(n_bits);
    local next_power_of_two = next_power_of_two;
    local x2_1 = x*2-1;
    with_attr error_message("{x} <= {next_power_of_two} <= {x2_1}") {
        assert_le(x, next_power_of_two);
        assert_le(next_power_of_two, x * 2 - 1);
    }
    return next_power_of_two;
}

const TWO_ADICITY = 192;
const TWO_ADIC_ROOT_OF_UNITY = 145784604816374866144131285430889962727208297722245411306711449302875041684;

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


func verify_fri_merkle_proofs {
    range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*
}(proofs: QueriesProof*, positions: felt*, trace_roots: felt*, loop_counter, evaluations: felt*, n_evaluations: felt){
    if(loop_counter == 0){
        return ();
    }

    // let digest = hash_elements(n_elements=n_evaluations, elements=evaluations);    // TODO: hash the evaluation correctly
    // assert_hashes_equal(digest, proofs[0].digests);

    verify_merkle_proof( proofs[0].length, proofs[0].digests, positions[0], trace_roots );
    verify_fri_merkle_proofs(&proofs[1], positions + 1, trace_roots, loop_counter - 1, evaluations + n_evaluations, n_evaluations);
    return ();
}

func verify_fri_proofs {
    range_check_ptr, blake2s_ptr: felt*, channel: Channel, bitwise_ptr: BitwiseBuiltin*
    }(evaluations: felt*, positions: felt*){
    alloc_locals;

    let (local next_positions: felt*) = alloc();
    let new_len = fold_positions(positions, next_positions, 54, 0);

    let (local fri_queries_proof_ptr: QueriesProofs*) = alloc();
    %{
        import json
        import subprocess
        from src.stark_verifier.utils import write_into_memory

        positions = []
        for i in range(ids.new_len):
            positions.append( memory[ids.next_positions + i] )

        positions = json.dumps( positions )

        completed_process = subprocess.run([
            'bin/stark_parser',
            'tests/integration/stark_proofs/fibonacci.bin', # TODO: this path shouldn't be hardcoded here!
            'fri-queries',
            positions
            ],
            capture_output=True)
        
        json_data = completed_process.stdout
        write_into_memory(ids.fri_queries_proof_ptr, json_data, segments)
    %}
    let n_cols = 1;
    
    // Authenticate proof paths
    // TODO: loop folding here
    verify_fri_merkle_proofs(
        fri_queries_proof_ptr[0].proofs, next_positions, channel.fri_roots, new_len, evaluations, n_cols);
    
    return();
}

func fold_positions(positions: felt*, next_positions: felt*, loop_counter, elems_count) -> felt {
    if (loop_counter == 0){
        return elems_count;
    }
    alloc_locals;
    let prev_position = [positions];
    local next_position;
    // TODO: this hint is an insecure hack. Replace it
    %{ 
        domain_size = 512
        fri_folding_factor = 8
        modulus = domain_size // fri_folding_factor
        ids.next_position = ids.prev_position % modulus
    %}
    let is_contained = contains(next_position, next_positions - elems_count, elems_count);
    if(is_contained == 1){
        return fold_positions(positions + 1, next_positions, loop_counter - 1, elems_count);
    } else {
        assert next_positions[0] = next_position;
        return fold_positions(positions + 1, next_positions + 1, loop_counter - 1, elems_count + 1);
    }
}

func fri_verify{
    range_check_ptr, blake2s_ptr: felt*, channel: Channel, bitwise_ptr: BitwiseBuiltin*}(
    fri_verifier: FriVerifier, evaluations: felt*, positions: felt*
) {
    verify_fri_proofs(evaluations, positions);
    // TODO
    return ();
}
