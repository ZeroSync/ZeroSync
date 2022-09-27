// Wrapper library for a sha256 implementation to be used
//
// Allows to switch between different implementations and dummies
//
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc

from serialize.serialize import byte_size_to_felt_size, UINT32_SIZE

func sha256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(input: felt*, byte_size) -> (
    hash: felt*
) {
    let (felt_size) = byte_size_to_felt_size(byte_size);
    return _sha256(felt_size, input, byte_size);
}

func _sha256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(felt_size, input: felt*, byte_size) -> (
    hash: felt*
) {
    // return _compute_sha256_real(felt_size, input, byte_size)
    return _compute_sha256_fake(felt_size, input, byte_size);
}

from crypto.sha256.cartridge_gg.sha256 import compute_sha256, finalize_sha256
func _compute_sha256_real{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    felt_size, input: felt*, byte_size
) -> (hash: felt*) {
    alloc_locals;
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;
    let hash: felt* = compute_sha256{sha256_ptr=sha256_ptr}(input, byte_size);
    finalize_sha256(sha256_ptr_start, sha256_ptr);
    return (hash,);
}

// Compute a sha256 hash using Python's hashlib library
//
// WARNING: This fakes the entire Bitcoin proof!
// It is intended to be used only for testing purposes!
//
// TODO: Delete this function before deploying any release!
from python_utils import setup_python_defs
func _compute_sha256_fake{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    felt_size, input: felt*, byte_size
) -> (hash: felt*) {
    alloc_locals;
    setup_python_defs();
    let (hash) = alloc();
    %{
        import struct
        import ctypes
        import hashlib

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
    return (hash,);
}
