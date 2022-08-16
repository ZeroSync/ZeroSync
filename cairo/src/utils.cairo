from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_le
from starkware.cairo.common.math import split_felt, unsigned_div_rem
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.memcpy import memcpy

from buffer import byte_size_to_felt_size, UINT32_SIZE
from sha256.sha256 import sha256, finalize_sha256

# A hash has 32 bytes
const HASH_SIZE = 32
# A 256-bit hash is represented as an array of 8 x Uint32
const HASH_FELT_SIZE = 8

func _compute_sha256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    felt_size, input:felt*, byte_size) -> (hash: felt*):

    # return _compute_sha256_real(felt_size, input, byte_size)
    return _compute_sha256_fake(felt_size, input, byte_size)
end

func _compute_sha256_real{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    felt_size, input:felt*, byte_size) -> (hash:felt*):
    alloc_locals
    let sha256_ptr: felt* = alloc()
    let sha256_ptr_start = sha256_ptr
    let hash: felt* = sha256{sha256_ptr=sha256_ptr}(input, byte_size)
    finalize_sha256(sha256_ptr_start, sha256_ptr)
    return (hash)
end 

from tests.utils_for_testing import setup_python_defs

func _compute_sha256_fake{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    felt_size, input:felt*, byte_size) -> (hash:felt*):
    alloc_locals
    setup_python_defs()
    let (hash) = alloc()
    %{
        # print('ids.byte_size=', ids.byte_size)
        # print('ids.felt_size=', ids.felt_size)
        # print('ids.input=', memory[ids.input])
        # Compute the sha256 hash with the python hashlib library
        import struct
        import hashlib
        import ctypes

        felt_size = ids.byte_size // 4 
        felt_size = felt_size + 1 if ids.byte_size % 4 else felt_size
        assert felt_size == ids.felt_size

        inputs = memory.get_range(ids.input, ids.felt_size)
        # print('inputs=', inputs)

        data = ctypes.create_string_buffer(ids.felt_size * 4)
        for index in range(ids.felt_size):
            struct.pack_into(">I", data, index * 4, inputs[index]) 
        
        data = data[:ids.byte_size]
        # print('data=', list(data))

        hash_hex = hashlib.sha256(data).hexdigest()
        # print('hash=', hash_hex)

        from_hex(hash_hex, ids.hash)
    %} 
    return (hash)
end

# Convert an array of 8 x Uint32 to an Uint256
func array_to_uint256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(array: felt*) -> (result: Uint256):
    let low  = array[0] * 2**96 + array[1] * 2**64 + array[2] * 2**32 + array[3]
    let high = array[4] * 2**96 + array[5] * 2**64 + array[6] * 2**32 + array[7]
    let result = Uint256(low, high)
    return (result)
end

func _compute_double_sha256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    felt_size : felt, input : felt*, byte_size : felt
) -> (result : felt*):
    alloc_locals
    let (hash_first_round) = _compute_sha256(felt_size, input, byte_size)
    let (hash_second_round) = _compute_sha256(HASH_FELT_SIZE, hash_first_round, HASH_SIZE)
    return (hash_second_round)
end

func sha256d{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    input : felt*, byte_size : felt
) -> (result : felt*):
    alloc_locals
    let (felt_size) = byte_size_to_felt_size(byte_size)
    let (hash) = _compute_double_sha256(felt_size, input, byte_size)
    return (hash)
end


# Hashing 
func sha256d_felt_sized{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    input : felt*, felt_size : felt
) -> (result : felt*):
    alloc_locals
    let byte_size = felt_size * UINT32_SIZE
    let (hash) = _compute_double_sha256(felt_size, input, byte_size)
    return (hash)
end


# Convert a felt into a Uint256
func to_uint256{range_check_ptr}(input: felt) -> (output: Uint256):
    let (high, low) = split_felt(input)
    let result = Uint256(low, high)
    return (result)
end


# Copy a hash represented as 8 x Uint32. 
# Starts reading at `source` and writes to `destination`
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