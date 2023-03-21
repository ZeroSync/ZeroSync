from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.hash import HashBuiltin
from starkware.cairo.common.hash_state import hash_finalize, hash_init, hash_update
from starkware.cairo.common.math import assert_nn_le, assert_le, split_felt
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.memset import memset
from utils.pow2 import pow2
from utils.endianness import byteswap32

from stark_verifier.air.pub_inputs import MemEntry, PublicInputs, get_raw_memory
from stark_verifier.air.transitions.frame import EvaluationFrame


// Pseudo-random element generator for finite fields.
struct PublicCoin {
    seed: felt,
    counter: felt,
}

// Returns a new random coin instantiated with the provided `seed`.
func random_coin_new{range_check_ptr, pedersen_ptr: HashBuiltin*}(seed: felt) -> PublicCoin {
    alloc_locals;
    tempvar data: felt* = new (seed);
    let (hash_state_ptr) = hash_init();
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(
        hash_state_ptr=hash_state_ptr,
        data_ptr=data,
        data_length=1
    );
    let (digest) = hash_finalize{hash_ptr=pedersen_ptr}(hash_state_ptr=hash_state_ptr);
    let public_coin = PublicCoin(seed=digest, counter=0);
    return public_coin;
}


// Returns a hash of two digests. This method is intended for use in construction of
// Merkle trees. Preserves the endianness of value
func merge{range_check_ptr, pedersen_ptr: HashBuiltin*}(
    seed: felt, value: felt
) -> felt {
    alloc_locals;
    tempvar data: felt* = new (seed, value);
    let (hash_state_ptr) = hash_init();
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(
        hash_state_ptr=hash_state_ptr,
        data_ptr=data,
        data_length=2
    );
    let (digest) = hash_finalize{hash_ptr=pedersen_ptr}(hash_state_ptr=hash_state_ptr);
    return digest;
}


// Returns hash(`seed` || `value`). This method is intended for use in PRNG and PoW contexts.
// This function does not ensure that value fits within a u64 integer.
func merge_with_int{range_check_ptr, pedersen_ptr: HashBuiltin*}(
    seed: felt, value: felt
) -> felt {
    alloc_locals;
    tempvar data: felt* = new (seed, value);
    let (hash_state_ptr) = hash_init();
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(
        hash_state_ptr=hash_state_ptr,
        data_ptr=data,
        data_length=2
    );
    let (digest) = hash_finalize{hash_ptr=pedersen_ptr}(hash_state_ptr=hash_state_ptr);
    return digest;
}

func hash_elements{range_check_ptr, pedersen_ptr: HashBuiltin*}(
    n_elements: felt, elements: felt*
) -> felt {
    let (hash_state_ptr) = hash_init();
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(
        hash_state_ptr=hash_state_ptr,
        data_ptr=elements,
        data_length=n_elements
    );
    let (res) = hash_finalize{hash_ptr=pedersen_ptr}(hash_state_ptr=hash_state_ptr);
    return res;
}


// Reseeds the coin with the specified data by setting the new seed to hash(`seed` || `value`).
// where value is a U256 integer representing a hash digest.
func reseed{range_check_ptr, pedersen_ptr: HashBuiltin*, public_coin: PublicCoin}(value: felt) {
    let digest = merge(seed=public_coin.seed, value=value);
    let public_coin = PublicCoin(seed=digest, counter=0);
    return ();
}


// Reseeds the coin with the specified value by setting the new seed to hash(`seed` || `value`)
// where value is a u64 integer.
// This function ensures that value fits within a u64 integer.
func reseed_with_int{range_check_ptr, pedersen_ptr: HashBuiltin*, public_coin: PublicCoin}(value: felt) {
    with_attr error_message("Value (${value}) is negative or greater than (2 ** 64 - 1).") {
        assert_nn_le(value, 2 ** 64 - 1);
    }
    let digest = merge_with_int(seed=public_coin.seed, value=value);
    let public_coin = PublicCoin(seed=digest, counter=0);
    return ();
}

func reseed_with_ood_frames{
    range_check_ptr, pedersen_ptr: HashBuiltin*, public_coin: PublicCoin
}(ood_main_trace_frame: EvaluationFrame, ood_aux_trace_frame: EvaluationFrame) {
    alloc_locals;

    let (elements) = alloc();
    let elements_start = elements;
    memcpy(elements, ood_main_trace_frame.current, ood_main_trace_frame.current_len);
    let elements = elements + ood_main_trace_frame.current_len;
    memcpy(elements, ood_aux_trace_frame.current, ood_aux_trace_frame.current_len);
    let elements = elements + ood_aux_trace_frame.current_len;
    let n_elements = elements - elements_start;
    let elements_hash = hash_elements(n_elements, elements_start);
    reseed(elements_hash);

    let (elements) = alloc();
    let elements_start = elements;
    memcpy(elements, ood_main_trace_frame.next, ood_main_trace_frame.next_len);
    let elements = elements + ood_main_trace_frame.next_len;
    memcpy(elements, ood_aux_trace_frame.next, ood_aux_trace_frame.next_len);
    let elements = elements + ood_aux_trace_frame.next_len;
    let n_elements = elements - elements_start;
    let elements_hash = hash_elements(n_elements, elements_start);
    reseed(elements_hash);

    return ();
}

func byteswap128{bitwise_ptr: BitwiseBuiltin*}(uint128) -> felt {
    assert bitwise_ptr[0].x = uint128;
    assert bitwise_ptr[0].y = 0xFF00FF00FF00FF00FF00FF00FF00FF00;
    assert bitwise_ptr[1].x = bitwise_ptr[0].x_and_y / 2 ** 8 + (bitwise_ptr[0].x - bitwise_ptr[0].x_and_y) * 2 ** 8;
    assert bitwise_ptr[1].y = 0xFFFF0000FFFF0000FFFF0000FFFF0000;
    assert bitwise_ptr[2].x = bitwise_ptr[1].x_and_y / 2 ** 16 + (bitwise_ptr[1].x - bitwise_ptr[1].x_and_y) * 2 ** 16;
    assert bitwise_ptr[2].y = 0xFFFFFFFF00000000FFFFFFFF00000000;
    assert bitwise_ptr[3].x = bitwise_ptr[2].x_and_y / 2 ** 32 + (bitwise_ptr[2].x - bitwise_ptr[2].x_and_y) * 2 ** 32;
    assert bitwise_ptr[3].y = 0xFFFFFFFFFFFFFFFF0000000000000000;
    let uint128_endian = bitwise_ptr[3].x_and_y  / 2 ** 64 + (bitwise_ptr[3].x - bitwise_ptr[3].x_and_y) * 2 ** 64;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE * 4;
    return uint128;
}

// Returns the next pseudo-random field element
func draw{
    range_check_ptr, pedersen_ptr: HashBuiltin*, public_coin: PublicCoin
}() -> felt {
    alloc_locals;
    let value = public_coin.counter + 1;
    let digest = merge_with_int(public_coin.seed, value);
    let public_coin = PublicCoin(public_coin.seed, value);
    return digest;
}

func draw_pair{
    range_check_ptr, pedersen_ptr: HashBuiltin*, public_coin: PublicCoin
}() -> (res1: felt, res2: felt) {
    alloc_locals;
    with pedersen_ptr, public_coin {
        let res1 = draw();
        let res2 = draw();
    }
    return (res1=res1, res2=res2);
}

func draw_elements{
    range_check_ptr, pedersen_ptr: HashBuiltin*, public_coin: PublicCoin
}(n_elements: felt, elements: felt*) {
    if (n_elements == 0) {
        return ();
    }
    with pedersen_ptr, public_coin {
        let res = draw();
    }
    assert [elements] = res;
    draw_elements(n_elements=n_elements - 1, elements=&elements[1]);
    return ();
}

func contains(element: felt, array: felt*, array_len: felt) -> felt {
    if (array_len == 0) {
        return 0;
    }
    if ([array] == element) {
        return 1;
    }

    return contains(element, array + 1, array_len - 1);
}


// Returns the next pseudo-random field element
func draw_digest{
    range_check_ptr, pedersen_ptr: HashBuiltin*, public_coin: PublicCoin
}() -> felt {
    alloc_locals;
    tempvar public_coin = PublicCoin(public_coin.seed, public_coin.counter + 1);
    let digest = merge_with_int(seed=public_coin.seed, value=public_coin.counter);
    return digest;
}


func _draw_integers_loop{
    range_check_ptr, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, public_coin: PublicCoin
}(n_elements: felt, elements: felt*, domain_size: felt, index: felt) {
    alloc_locals;
    if (n_elements == index) {
        return ();
    }

    // determine how many bits are needed to represent valid values in the domain
    let v_mask = domain_size - 1;

    // draw values from PRNG until we get as many unique values as specified by n_elements
    let element = draw_digest();

    // convert to integer and limit the integer to the number of bits which can fit
    // into the specified domain
    assert [bitwise_ptr].x = element;
    assert [bitwise_ptr].y = v_mask;
    let value = [bitwise_ptr].x_and_y;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;

    let is_contained = contains(value, elements, index);
    if (is_contained != FALSE) {
        return _draw_integers_loop(n_elements, elements, domain_size, index);
    }

    assert elements[index] = value;

    return _draw_integers_loop(n_elements, elements, domain_size, index + 1);
}

// / Returns a vector of unique integers selected from the range [0, domain_size).
// /
// / Errors if:
// / - `domain_size` is not a power of two.
// / - `n_elements` is greater than or equal to `domain_size`.
// /
// /See also: https://github.com/ZeroSync/winterfell/blob/main/crypto/src/random/mod.rs#L252
func draw_integers{
    range_check_ptr, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, public_coin: PublicCoin
}(n_elements: felt, elements: felt*, domain_size: felt) {
    return _draw_integers_loop(n_elements, elements, domain_size, 0);
}

func seed_with_pub_inputs{
    range_check_ptr, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*
}(pub_inputs: PublicInputs*) -> felt {
    alloc_locals;

    let (mem_values: felt*) = alloc();
    let mem_length = pub_inputs.mem_length;
    get_raw_memory(pub_inputs.mem, pub_inputs.mem_length, mem_values);

    let (hash_state_ptr) = hash_init();
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(
        hash_state_ptr=hash_state_ptr,
        data_ptr=mem_values,
        data_length=mem_length
    );
    let (pub_mem_hash) = hash_finalize{hash_ptr=pedersen_ptr}(hash_state_ptr=hash_state_ptr);

    let (hash_state_ptr) = hash_init();
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(
        hash_state_ptr=hash_state_ptr,
        data_ptr = new (
            pub_inputs.init._pc,
            pub_inputs.init._ap,
            pub_inputs.init._fp,
            pub_inputs.fin._pc,
            pub_inputs.fin._ap,
            pub_inputs.fin._fp,
            pub_inputs.rc_min,
            pub_inputs.rc_max,
            mem_length,
            pub_mem_hash,
            pub_inputs.num_steps
        ),
        data_length = 11
    );
    let (res) = hash_finalize{hash_ptr=pedersen_ptr}(hash_state_ptr=hash_state_ptr);
    return res;
}

func get_leading_zeros{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(seed: felt) -> felt {
    alloc_locals;

    local lzcnt;
    %{
        # Count high bits in use
        n_bits = len( bin(ids.seed).replace('0b', '') )
        assert 0 <= n_bits <= 256, "expected 256 bits"

        # Store leading zeros count
        ids.lzcnt = 256 - n_bits
    %}

    // // Verify leading zeros count
    // let ceil_pow2 = pow2(256 - lzcnt);

    // // 2**(log2-1) < seed <= 2**log2
    // with_attr error_message(
    //         "Error in 2**(log2-1) < seed <= 2**log2 verification.") {
    //     assert_le(seed, ceil_pow2 - 1);
    //     assert_le(ceil_pow2 / 2, seed);
    // }

    return lzcnt;
}
