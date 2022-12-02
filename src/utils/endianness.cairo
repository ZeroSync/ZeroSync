from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

// Swap the endianness of an uint32
func byteswap32{bitwise_ptr: BitwiseBuiltin*}(uint32) -> felt {
    alloc_locals;
    assert bitwise_ptr[0].x = uint32;
    assert bitwise_ptr[0].y = 0xFF00FF00;
    assert bitwise_ptr[1].x = bitwise_ptr[0].x_and_y  / 2 ** 8 + (uint32 - bitwise_ptr[0].x_and_y) * 2 ** 8;
    assert bitwise_ptr[1].y = 0xFFFF0000;
    let uint32_endian = bitwise_ptr[1].x_and_y  / 2 ** 16 + (bitwise_ptr[1].x - bitwise_ptr[1].x_and_y) * 2 ** 16;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE * 2;
    return uint32_endian;
}

// Swap the endianness of an uint16
func byteswap16{bitwise_ptr: BitwiseBuiltin*}(uint16) -> felt {
    alloc_locals;
    assert [bitwise_ptr].x = uint16;
    assert [bitwise_ptr].y = 0xFF00;
    let uint16_endian = [bitwise_ptr].x_and_y  / 2 ** 8 + (uint16 - [bitwise_ptr].x_and_y) * 2 ** 8;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
    return uint16_endian;
}