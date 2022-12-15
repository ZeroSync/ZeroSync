from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_blake2s.blake2s import (
    blake2s_add_felt,
    blake2s_bigend,
    blake2s_felts,
    blake2s_add_felts,
    blake2s,
    blake2s_as_words,
)
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.hash import HashBuiltin
from starkware.cairo.common.hash_state import hash_finalize, hash_init, hash_update
from starkware.cairo.common.math import assert_nn_le, assert_le
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.memset import memset
from utils.pow2 import pow2
from utils.endianness import byteswap32

from stark_verifier.air.pub_inputs import MemEntry, PublicInputs, read_mem_values
from stark_verifier.air.stark_proof import Context
from stark_verifier.air.transitions.frame import EvaluationFrame


// Pseudo-random element generator for finite fields.
struct PublicCoin {
    seed: felt*,
    counter: felt,
}

// Returns a new random coin instantiated with the provided `seed`.
func random_coin_new{range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*}(seed: felt*, n_bytes: felt) -> PublicCoin {
    let (digest) = blake2s_as_words(data=seed, n_bytes=n_bytes);
    let public_coin = PublicCoin(seed=digest, counter=0);
    return public_coin;
}

// Returns a hash of two digests. This method is intended for use in construction of
// Merkle trees.
func merge{range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*}(
    seed: felt*, value: felt*
) -> felt* {
    alloc_locals;
    let (data: felt*) = alloc();

    memcpy(data, seed, 8);
    
    let be_value = data + 8;
    assert be_value[0] = byteswap32(value[0]);
    assert be_value[1] = byteswap32(value[1]);
    assert be_value[2] = byteswap32(value[2]);
    assert be_value[3] = byteswap32(value[3]);
    assert be_value[4] = byteswap32(value[4]);
    assert be_value[5] = byteswap32(value[5]);
    assert be_value[6] = byteswap32(value[6]);
    assert be_value[7] = byteswap32(value[7]);

    let (digest) = blake2s_as_words(data=data, n_bytes=64);

    return digest;
}

// Returns hash(`seed` || `value`). This method is intended for use in PRNG and PoW contexts.
// This function does not ensure that value fits within a u64 integer.
func merge_with_int{range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*}(
    seed: felt*, value: felt
) -> felt* {
    alloc_locals;
    let (data: felt*) = alloc();
    let data_start = data;

    memcpy(data, seed, 8);
    let data = data + 8;

    // Convert value : u64 -> (high: u32, low:u32)  
    assert [bitwise_ptr].x = value;
    assert [bitwise_ptr].y = 0xffffffff;
    let low = [bitwise_ptr].x_and_y;
    let high = (value - low) / 2**32;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;

    // Write high and low into data in little endian order
    assert data[0] = low;
    assert data[1] = high;

    // Compute the blake2s hash
    let (digest) = blake2s_as_words(data=data_start, n_bytes=40);
    return digest;
}

func hash_elements{range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*}(
    n_elements: felt, elements: felt*
) -> felt* {
    alloc_locals;
    let (data) = alloc();
    let data_start = data;
    with data {
        blake2s_add_felts(n_elements=n_elements, elements=elements, bigend=0);
    }
    let (res) = blake2s_as_words(data=data_start, n_bytes = n_elements * 32);
    return res;
}


// Reseeds the coin with the specified data by setting the new seed to hash(`seed` || `value`).
// where value is a U256 integer representing a hash digest
func reseed{
    range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*, public_coin: PublicCoin
}(value: felt*) {
    let digest = merge(seed=public_coin.seed, value=value);
    let public_coin = PublicCoin(seed=digest, counter=0);
    return ();
}



// Reseeds the coin with the specified value by setting the new seed to hash(`seed` || `value`)
// where value is a u64 integer.
// This function ensures that value fits within a u64 integer.
func reseed_with_int{
    range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*, public_coin: PublicCoin
}(value: felt) {
    with_attr error_message("Value (${value}) is negative or greater than (2 ** 64 - 1).") {
        assert_nn_le(value, 2 ** 64 - 1);
    }
    let digest = merge_with_int(seed=public_coin.seed, value=value);
    let public_coin = PublicCoin(seed=digest, counter=0);
    return ();
}

func reseed_with_ood_frames{
    range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*, public_coin: PublicCoin
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
    reseed_endian(elements_hash);


    let (elements) = alloc();
    let elements_start = elements;
    memcpy(elements, ood_main_trace_frame.next, ood_main_trace_frame.next_len);
    let elements = elements + ood_main_trace_frame.next_len;
    memcpy(elements, ood_aux_trace_frame.next, ood_aux_trace_frame.next_len);
    let elements = elements + ood_aux_trace_frame.next_len;
    let n_elements = elements - elements_start;
    let elements_hash = hash_elements(n_elements, elements_start);
    reseed_endian(elements_hash);

    return ();
}

// Returns the next pseudo-random field element
func draw{
    range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*, public_coin: PublicCoin
}() -> felt {
    alloc_locals;
    tempvar public_coin = PublicCoin(public_coin.seed, public_coin.counter + 1);
    let digest = merge_with_int(seed=public_coin.seed, value=public_coin.counter);
    
    let low = digest[0] + digest[1] * 2 ** 32 + digest[2] * 2 ** 64 + digest[3] * 2 ** 96;
    let high = digest[4] + digest[5] * 2 ** 32 + digest[6] * 2 ** 64 + digest[7] * 2 ** 96;

    return high * 2**128 + low;
}


func draw_pair{
    range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*, public_coin: PublicCoin
}() -> (res1: felt, res2: felt) {
    alloc_locals;
    let res1 = draw();
    let res2 = draw();
    return (res1=res1, res2=res2);
}

func draw_elements{
    range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*, public_coin: PublicCoin
}(n_elements: felt, elements: felt*) {
    if (n_elements == 0) {
        return ();
    }
    let res = draw();
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

func _draw_integers_loop{
    range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*, public_coin: PublicCoin
}(n_elements: felt, elements: felt*, domain_size: felt, index: felt) {
    alloc_locals;
    if (n_elements == index) {
        return ();
    }

    // determine how many bits are needed to represent valid values in the domain
    let v_mask = domain_size - 1;

    // draw values from PRNG until we get as many unique values as specified by n_elements
    let element = draw();

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
    range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*, public_coin: PublicCoin
}(n_elements: felt, elements: felt*, domain_size: felt) {
    return _draw_integers_loop(n_elements, elements, domain_size, 0);
}

func seed_with_pub_inputs{
    range_check_ptr, blake2s_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*
}(pub_inputs: PublicInputs*) -> felt* {
    alloc_locals;

    let (mem_values: felt*) = alloc();
    let mem_length = pub_inputs.mem_length;
    read_mem_values(
        mem=pub_inputs.mem,
        address=0,
        length=mem_length,
        output=mem_values
    );

    let (hash_state_ptr) = hash_init();
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(
        hash_state_ptr=hash_state_ptr,
        data_ptr=mem_values,
        data_length=mem_length
    );
    let (pub_mem_hash) = hash_finalize{hash_ptr=pedersen_ptr}(hash_state_ptr=hash_state_ptr);

    let (data: felt*) = alloc();
    let data_start = data;
    with data {
        blake2s_add_felt(num=pub_inputs.init._pc, bigend=0);
        blake2s_add_felt(num=pub_inputs.init._ap, bigend=0);
        blake2s_add_felt(num=pub_inputs.init._fp, bigend=0);

        blake2s_add_felt(num=pub_inputs.fin._pc, bigend=0);
        blake2s_add_felt(num=pub_inputs.fin._ap, bigend=0);
        blake2s_add_felt(num=pub_inputs.fin._fp, bigend=0);

        blake2s_add_felt(num=pub_inputs.rc_min, bigend=0);
        blake2s_add_felt(num=pub_inputs.rc_max, bigend=0);

        blake2s_add_felt(num=mem_length, bigend=0);
        blake2s_add_felt(num=pub_mem_hash, bigend=0);

        blake2s_add_felt(num=pub_inputs.num_steps, bigend=0);
    }

    let n_bytes = (data - data_start) * 4;
    let (res) = blake2s_as_words(data=data_start, n_bytes=n_bytes);
    return res;
}

func get_leading_zeros{range_check_ptr, public_coin: PublicCoin}() -> felt {
    alloc_locals;

    let seed = public_coin.seed + 4;
    let high = seed[0] + seed[1] * 2 ** 32 + seed[2] * 2 ** 64 + seed[3] * 2 ** 96;

    local lzcnt;
    %{
        # Count high bits in use
        n_bits = len( bin(ids.high).replace('0b', '') )
        assert 0 <= n_bits <= 128, "expected 128 bits"

        # Store leading zeros count
        ids.lzcnt = 128 - n_bits
    %}

    // Verify leading zeros count
    let ceil_pow2 = pow2(128 - lzcnt);

    // 2**(log2-1) < public_coin.seed.high <= 2**log2
    with_attr error_message(
            "Error in 2**(log2-1) < public_coin.seed.high <= 2**log2 verification.") {
        assert_le(high, ceil_pow2 - 1);
        assert_le(ceil_pow2 / 2, high);
    }
    // Ensure that less or equal 64 leading zeros
    let is_lzcnt_le_64 = is_le(lzcnt, 64);
    if (is_lzcnt_le_64 == TRUE) {
        return lzcnt;
    } else {
        return 64;
    }
}




// Reseeds the coin with the specified data by setting the new seed to hash(`seed` || `value`).
// where value is a U256 integer representing a hash digest. Preserves the endianness of value
func reseed_endian{
    range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*, public_coin: PublicCoin
}(value: felt*) {
    let digest = merge_endian(seed=public_coin.seed, value=value);
    let public_coin = PublicCoin(seed=digest, counter=0);
    return ();
}

// Returns a hash of two digests. This method is intended for use in construction of
// Merkle trees. Preserves the endianness of value
func merge_endian{range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*}(
    seed: felt*, value: felt*
) -> felt* {
    alloc_locals;
    let (data: felt*) = alloc();

    memcpy(data, seed, 8);
    memcpy(data+8, value, 8);
   
    let (digest) = blake2s_as_words(data=data, n_bytes=64);

    return digest;
}