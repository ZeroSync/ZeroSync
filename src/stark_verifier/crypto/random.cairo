from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_blake2s.blake2s import (
    blake2s_add_felt,
    blake2s_bigend,
    blake2s_felts,
    blake2s_add_uint256_bigend,
)
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.hash import HashBuiltin
from starkware.cairo.common.hash_state import hash_finalize, hash_init, hash_update
from starkware.cairo.common.math import assert_nn_le, assert_le
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.pow import pow
from starkware.cairo.common.uint256 import Uint256, uint256_lt

from stark_verifier.air.pub_inputs import (
    MemEntry,
    PublicInputs,
)
from stark_verifier.air.stark_proof import Context
from stark_verifier.air.transitions.frame import EvaluationFrame

// Montgomery constant
const R_MONTGOMERY = 2 ** 256;

// Pseudo-random element generator for finite fields.
struct PublicCoin {
    seed: Uint256,
    counter: felt,
}

// Returns a new random coin instantiated with the provided `seed`.
func random_coin_new(seed: Uint256) -> (res: PublicCoin) {
    return (res=PublicCoin(seed=seed, counter=0));
}

// Returns a hash of two digests. This method is intended for use in construction of
// Merkle trees.
func merge{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*
}(seed: Uint256, value: Uint256) -> (digest: Uint256) {
    alloc_locals;
    let (data: felt*) = alloc();
    let data_start = data;
    blake2s_add_uint256_bigend{data=data}(seed);
    blake2s_add_uint256_bigend{data=data}(value);
    let (digest) = blake2s_bigend(data=data_start, n_bytes=64);
    return (digest=digest);
}

// Returns hash(`seed` || `value`). This method is intended for use in PRNG and PoW contexts.
// This function does not ensure that value fits within a u64 integer.
func merge_with_int{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
}(seed: Uint256, value: felt) -> (digest: Uint256) {
    alloc_locals;
    let (data: felt*) = alloc();
    let data_start = data;
    blake2s_add_uint256_bigend{data=data}(seed);
    blake2s_add_uint256_bigend{data=data}(
        Uint256(
            low=value,
            high=value * 2 ** 64,
        )
    );
    let (digest) = blake2s_bigend(data=data_start, n_bytes=40);
    return (digest=digest);
}

func hash_elements{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
}(n_elements: felt, elements: felt*) -> (res: Uint256) {
    let (res) = blake2s_felts(n_elements=n_elements, elements=elements, bigend=1);
    return (res=res);
}

// Reseeds the coin with the specified data by setting the new seed to hash(`seed` || `value`).
// where value is a U256 integer representing a hash digest
func reseed{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    public_coin: PublicCoin,
}(value: Uint256) -> () {
    let (digest) = merge(seed=public_coin.seed, value=value);
    let public_coin = PublicCoin(seed=digest, counter=0);
    return ();
}

// Reseeds the coin with the specified value by setting the new seed to hash(`seed` || `value`)
// where value is a u64 integer.
// This function ensures that value fits within a u64 integer.
func reseed_with_int{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    public_coin: PublicCoin,
}(value: felt) -> () {
    with_attr error_message("Value is negative or greater than (2 ** 64 - 1)") {
        assert_nn_le(value, 2 ** 64 - 1);
    }
    let (digest) = merge_with_int(seed=public_coin.seed, value=value);
    let public_coin = PublicCoin(seed=digest, counter=0);
    return ();
}

func reseed_with_ood_frames{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    public_coin: PublicCoin,
}(
    ood_main_trace_frame: EvaluationFrame,
    ood_aux_trace_frame: EvaluationFrame,
) -> () {
    // TODO
    return ();
}

// Returns the next pseudo-random field element
func draw{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    public_coin: PublicCoin,
}() -> (res: felt) {
    alloc_locals;
    tempvar public_coin = PublicCoin(public_coin.seed, public_coin.counter + 1);
    let (local num: Uint256) = merge_with_int(seed=public_coin.seed, value=public_coin.counter);
    let (is_valid) = uint256_lt(
        num,
        Uint256(
            low=31,
            high=329648542954659146201578277794459156480
        )
    );
    if (is_valid == 1) {
        let res = (num.low + num.high * 2 ** 128) / R_MONTGOMERY;
        return (res=res);
    } else {
        return draw();
    }
}

func draw_pair{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    public_coin: PublicCoin,
}() -> (res1: felt, res2: felt) {
    alloc_locals;
    let (res1) = draw();
    let (res2) = draw();
    return (res1=res1, res2=res2);
}

func draw_elements{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    public_coin: PublicCoin,
}(
    n_elements: felt,
    elements: felt*,
) -> () {
    if (n_elements == 0) {
        return ();
    }
    let (res) = draw();
    assert [elements] = res;
    draw_elements(n_elements=n_elements - 1, elements=&elements[1]);
    return ();
}


func contains(element:felt, array: felt*, array_len:felt) -> felt {
    if( array_len == 0 ){
        return 0;
    }
    if( [array] == element ){
        return 1;
    }

    return contains(element, array + 1, array_len - 1);
}

func _draw_integers_loop {
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    public_coin: PublicCoin,
}(
    n_elements: felt,
    elements: felt*,
    domain_size: felt,
    index: felt,
) -> () {
    alloc_locals;
    if (n_elements == index) {
        return ();
    }

    // determine how many bits are needed to represent valid values in the domain
    let v_mask = domain_size - 1;

    // draw values from PRNG until we get as many unique values as specified by n_elements
    let (element) = draw();

    // convert to integer and limit the integer to the number of bits which can fit
    // into the specified domain
    assert [bitwise_ptr].x = element;
    assert [bitwise_ptr].y = v_mask;
    let value = [bitwise_ptr].x_and_y;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;

    // TODO: Limit number of recursion calls to 1000
    let is_contained = contains(value, elements, index);
    if (is_contained == 1) {
        return _draw_integers_loop(n_elements, elements, domain_size, index);
    }

    assert elements[index] = value;

    return _draw_integers_loop(n_elements, elements, domain_size, index + 1);
}

/// Returns a vector of unique integers selected from the range [0, domain_size).
///
/// Errors if:
/// - the specified number of unique integers could not be generated
///   after 1000 calls to the PRNG.
/// - `domain_size` is not a power of two.
/// - `n_elements` is greater than or equal to `domain_size`.
///
///See also: https://github.com/ZeroSync/winterfell/blob/main/crypto/src/random/mod.rs#L252
func draw_integers {
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    public_coin: PublicCoin,
}(
    n_elements: felt,
    elements: felt*,
    domain_size: felt,
) -> () {
    return _draw_integers_loop(n_elements, elements, domain_size, 0);
}


func seed_with_pub_inputs{
    range_check_ptr,
    blake2s_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    bitwise_ptr: BitwiseBuiltin*,
}(
    pub_inputs: PublicInputs,
) -> (res: Uint256) {
    alloc_locals;

    let (hash_state_ptr) = hash_init();
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(
        hash_state_ptr=hash_state_ptr,
        data_ptr=pub_inputs.mem.elements,
        data_length=pub_inputs.mem.n_elements * MemEntry.SIZE,
    );
    let (pub_mem_hash) = hash_finalize{hash_ptr=pedersen_ptr}(hash_state_ptr=hash_state_ptr);

    let (data: felt*) = alloc();
    let data_start = data;
    with data {
        blake2s_add_felt(num=pub_inputs.init._pc, bigend=1);
        blake2s_add_felt(num=pub_inputs.init._ap, bigend=1);
        blake2s_add_felt(num=pub_inputs.init._fp, bigend=1);

        blake2s_add_felt(num=pub_inputs.fin._pc, bigend=1);
        blake2s_add_felt(num=pub_inputs.fin._ap, bigend=1);
        blake2s_add_felt(num=pub_inputs.fin._fp, bigend=1);

        blake2s_add_felt(num=pub_inputs.rc_min, bigend=1);
        blake2s_add_felt(num=pub_inputs.rc_max, bigend=1);

        blake2s_add_felt(num=pub_inputs.mem.n_elements, bigend=1);
        blake2s_add_felt(num=pub_mem_hash, bigend=1);

        blake2s_add_felt(num=pub_inputs.num_steps, bigend=1);
    }

    let n_bytes = (data - data_start) * 4;
    let (res) = blake2s_bigend(data=data_start, n_bytes=n_bytes);
    return (res=res);
}

func get_leading_zeros{range_check_ptr, public_coin: PublicCoin}() -> (res: felt) {
    alloc_locals;
    local lzcnt; 
    %{
        # Count high bits in use
        n_bits = len( bin(ids.public_coin.seed.high).replace('0b', '') )
        assert 0 <= n_bits <= 128, "expected 128-bit"

        # Store leading zeros count
        ids.lzcnt = 128 - n_bits
    %}

    // Verify leading zeros count
    let (ceil_pow2) = pow(2, 128 - lzcnt);

    // 2**(log2-1) < public_coin.seed.high <= 2**log2
    with_attr error_message("Error in 2**(log2-1) < public_coin.seed.high <= 2**log2 verification.") {
        assert_le(public_coin.seed.high, ceil_pow2 - 1);
        assert_le(ceil_pow2 / 2, public_coin.seed.high);
    }
    // Ensure that less or equal 64 leading zeros
    let is_lzcnt_le_64 = is_le(lzcnt, 64);
    if(is_lzcnt_le_64 == TRUE){
        return (lzcnt,);
    } else {
        return (64,);
    }
}
