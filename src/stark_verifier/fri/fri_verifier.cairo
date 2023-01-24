from stark_verifier.air.air_instance import AirInstance
from stark_verifier.channel import Channel
from stark_verifier.air.stark_proof import ProofOptions
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from stark_verifier.crypto.random import PublicCoin, reseed, draw, reseed_endian
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_le, assert_not_zero
from starkware.cairo.common.pow import pow
from utils.pow2 import pow2

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
        assert n = next_power_of_two;
    }
    return n_bits;
}

func fri_verify{channel: Channel}(
    fri_verifier: FriVerifier, evaluations: felt*, positions: felt*
) {
    // TODO
    return ();
}
