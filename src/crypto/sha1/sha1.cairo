// Wrapper library for a sha1 implementation to be used
//
// Allows to switch between different implementations and dummies
//
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc

from serialize.serialize import byte_size_to_felt_size, UINT32_SIZE

func sha1{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(input: felt*, byte_size) -> (hash: felt*) {
    let (felt_size) = byte_size_to_felt_size(byte_size);
    return _sha1(felt_size, input, byte_size);
}

func _sha1{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(felt_size, input: felt*, byte_size) -> (
    hash: felt*
) {
    // return _compute_sha1_real(felt_size, input, byte_size)
    return _compute_sha1_fake(felt_size, input, byte_size);
}

// Compute a sha1 hash using Python's hashlib library
//
// WARNING: This fakes the entire Bitcoin proof!
// It is intended to be used only for testing purposes!
//
// TODO: Delete this function before deploying any release!
from utils.python_utils import setup_python_defs
func _compute_sha1_fake{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
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

        data = ctypes.create_string_buffer(ids.felt_size * 4)
        for index in range(ids.felt_size):
            struct.pack_into(">I", data, index * 4, inputs[index]) 

        data = data[:ids.byte_size]

        hash_hex = hashlib.sha1(data).hexdigest()

        from_hex(hash_hex, ids.hash)
    %}
    return (hash,);
}
