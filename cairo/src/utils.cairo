from sha256.sha256 import compute_sha256
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_le
from starkware.cairo.common.math import split_felt
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.bitwise import bitwise_and

const FELT_HASH_LEN = 8
const N_BYTES_HASH = 32

# Convert an array of 32-bit unsigned integers to a Uint256
func array_to_uint256(array: felt*) -> (result: Uint256):
    let low  = array[0] + array[1] * 2**32 + array[2] * 2**64 + array[3] * 2**96
    let high = array[4] + array[5] * 2**32 + array[6] * 2**64 + array[7] * 2**96
    let result = Uint256(low, high)
    return (result)
end

# Compute double sha256 hash of the input 
# given as an array of 32-bit unsigned integers
# and returns a Uint256.
func compute_double_sha256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    input_len : felt, input : felt*, n_bytes : felt
) -> (sha : Uint256):
    alloc_locals
    let (hash_first_round) = compute_sha256(input_len, input, n_bytes)
    let (hash_second_round) = compute_sha256(FELT_HASH_LEN, hash_first_round, N_BYTES_HASH)
    let (result) = array_to_uint256(hash_second_round)
    return (result)
end

# Convert a felt into a Uint256
func to_uint256{range_check_ptr}(input: felt) -> (output: Uint256):
    let (high, low) = split_felt(input)
    let result = Uint256(low, high)
    return (result)
end

# Convert 32-bit unsigned integer to big endian
func to_big_endian{bitwise_ptr : BitwiseBuiltin*}(a : felt) -> (result : felt):
    let (byte1) = bitwise_and(a, 0x000000FF)
    let (byte2) = bitwise_and(a, 0x0000FF00)
    let (byte3) = bitwise_and(a, 0x00FF0000)
    let (byte4) = bitwise_and(a, 0xFF000000)
    let b = byte1 * 0x1000000 + byte2 * 0x100 + byte3 / 0x100 + byte4 / 0x1000000
    return (result=b)
end