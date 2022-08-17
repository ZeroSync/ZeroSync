from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy

from buffer import byte_size_to_felt_size, UINT32_SIZE

from src.crypto.sha256.sha256 import _sha256

# A hash has 32 bytes
const HASH_SIZE = 32
# A 256-bit hash is represented as an array of 8 x Uint32
const HASH_FELT_SIZE = 8

func sha256d{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    input: felt*, byte_size: felt
) -> (result: felt*):
    alloc_locals
    let (felt_size) = byte_size_to_felt_size(byte_size)
    let (hash) = _compute_double_sha256(felt_size, input, byte_size)
    return (hash)
end

# Hashing 
func sha256d_felt_sized{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    input: felt*, felt_size: felt
) -> (result: felt*):
    alloc_locals
    let byte_size = felt_size * UINT32_SIZE
    let (hash) = _compute_double_sha256(felt_size, input, byte_size)
    return (hash)
end

func _compute_double_sha256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    felt_size: felt, input: felt*, byte_size: felt
) -> (result: felt*):
    alloc_locals
    let (hash_first_round) = _sha256(felt_size, input, byte_size)
    let (hash_second_round) = _sha256(HASH_FELT_SIZE, hash_first_round, HASH_SIZE)
    return (hash_second_round)
end

# Copy a hash represented as an array of 8 x Uint32. 
# It reads from `source` and writes to `destination`
func copy_hash(source: felt*, destination: felt*):
    memcpy(destination, source, HASH_FELT_SIZE)
    return ()
end

# Assert equality of two hashes represented as an array of 8 x Uint32
func assert_hashes_equal(hash1: felt*, hash2: felt*):
    # TODO: ensure hash1 is not empty
    # Otherwise, we perform a copy here and pass where we should fail!
    memcpy(hash2, hash1, HASH_FELT_SIZE)
    return ()
end