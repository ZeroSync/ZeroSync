# Wrapper library for a sha256 implementation to be used
#
# Allows to switch between different implementations and dummies
#
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc

from buffer import byte_size_to_felt_size, UINT32_SIZE
from crypto.ripemd160.ripemd160_python import setup_python_ripemd160

func ripemd160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(input : felt*, byte_size) -> (
    hash : felt*
):
    let (felt_size) = byte_size_to_felt_size(byte_size)
    return _ripemd160(felt_size, input, byte_size)
end

func _ripemd160{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    felt_size, input : felt*, byte_size
) -> (hash : felt*):
    # return _compute_ripemd160_real(felt_size, input, byte_size)
    return _compute_ripemd160_fake(felt_size, input, byte_size)
end

# Compute a ripemd160 hash using a Python implementation
#
# WARNING: This fakes the entire Bitcoin proof!
# It is intended to be used only for testing purposes!
#
# TODO: Delete this function before deploying any release!
from utils_for_testing import setup_python_defs
func _compute_ripemd160_fake{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    felt_size, input : felt*, byte_size
) -> (hash : felt*):
    alloc_locals
    setup_python_defs()
    setup_python_ripemd160()
    let (hash) = alloc()
    %{
        import struct
        import ctypes



        felt_size = ids.byte_size // 4 
        felt_size = felt_size + 1 if ids.byte_size % 4 else felt_size
        assert felt_size == ids.felt_size

        inputs = memory.get_range(ids.input, ids.felt_size)

        data = ctypes.create_string_buffer(ids.felt_size * 4)
        for index in range(ids.felt_size):
            struct.pack_into(">I", data, index * 4, inputs[index]) 

        data = data[:ids.byte_size]

        rmd160 = RIPEMD160.new()
        rmd160.update(data)
        hash_hex = rmd160.hexdigest()

        from_hex(hash_hex, ids.hash)
    %}
    return (hash)
end
