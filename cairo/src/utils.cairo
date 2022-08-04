from sha256.sha256 import compute_sha256
from starkware.cairo.common.uint256 import (Uint256, uint256_eq, uint256_le)
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

const FELT_HASH_LEN = 8
const N_BYTES_HASH = 32

func bytes_to_uint256(bytes: felt*) -> (result: Uint256):
    let low  = bytes[0] + bytes[1] * 0x100000000 + bytes[2] * 0x10000000000000000 + bytes[3] * 0x1000000000000000000000000
    let high = bytes[4] + bytes[5] * 0x100000000 + bytes[6] * 0x10000000000000000 + bytes[7] * 0x1000000000000000000000000
    let result = Uint256(low, high)
    return (result)
end

func _compute_double_sha256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    input_len : felt, input : felt*, n_bytes : felt
) -> (sha : felt*):
    alloc_locals
    let (output_first) = compute_sha256(input_len, input, n_bytes)
    let (output_second) = compute_sha256(FELT_HASH_LEN, output_first, N_BYTES_HASH)
    return (output_second)
end

func compute_double_sha256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    input_len : felt, input : felt*, n_bytes : felt
) -> (sha : Uint256):
    alloc_locals
    let (hash_tmp) = _compute_double_sha256(input_len, input, n_bytes)
    let (hash) = bytes_to_uint256(hash_tmp)
    return (hash)
end

func felt_to_uint256(input: felt) -> (output: Uint256):
    let (high, low) = unsigned_div_rem(input, 2**128)
    let result = Uint256(low, high)
    return (result)
end
