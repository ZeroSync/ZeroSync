from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

// Swap the endianness of an uint32
func byteswap32{bitwise_ptr: BitwiseBuiltin*}(value) -> felt{
    assert bitwise_ptr[0].x = value;
    assert bitwise_ptr[0].y = 0xff;
    let byte1 = bitwise_ptr[0].x_and_y;

    assert bitwise_ptr[1].x = value;
    assert bitwise_ptr[1].y = 0xff00;
    let byte2 = bitwise_ptr[1].x_and_y;

    assert bitwise_ptr[2].x = value;
    assert bitwise_ptr[2].y = 0xff0000;
    let byte3 = bitwise_ptr[2].x_and_y;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE * 3;

    let byte4 = value - byte3 - byte2 - byte1;

    return byte1 * 2**24 + byte2 * 2**8 + byte3 / 2**8 + byte4 / 2**24;
}