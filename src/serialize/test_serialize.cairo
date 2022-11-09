//
// To run only this test suite use:
// protostar test --cairo-path=./src target **/*_serialize*
//

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from crypto.sha256d.sha256d import assert_hashes_equal
from serialize.serialize import (
    flush_writer,
    init_writer,
    write_uint8,
    write_uint16,
    write_uint32,
    write_uint64,
    write_varint,
    write_uint32_endian,
    write_hash,
    byte_size_to_felt_size,
    init_reader,
    read_uint8,
    read_uint16,
    read_uint32,
    read_uint64,
    read_varint,
    read_bytes_endian,
    read_bytes,
)

@external
func test_read_uint8{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let (array) = alloc();
    assert array[0] = 0x01020304;
    assert array[1] = 0x05000000;

    let (reader) = init_reader(array);

    let (uint8_1) = read_uint8{reader=reader}();
    assert uint8_1 = 0x01;

    let (uint8_2) = read_uint8{reader=reader}();
    assert uint8_2 = 0x02;

    let (uint8_3) = read_uint8{reader=reader}();
    assert uint8_3 = 0x03;

    let (uint8_4) = read_uint8{reader=reader}();
    assert uint8_4 = 0x04;

    let (uint8_5) = read_uint8{reader=reader}();
    assert uint8_5 = 0x05;

    return ();
}

@external
func test_read_uint16{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let (array) = alloc();
    assert array[0] = 0x01020304;

    let (reader) = init_reader(array);

    let (uint16) = read_uint16{reader=reader}();
    assert uint16 = 0x0201;

    return ();
}

@external
func test_read_uint32{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let (array) = alloc();
    assert array[0] = 0x01020304;

    let (reader) = init_reader(array);

    let (uint32) = read_uint32{reader=reader}();
    assert uint32 = 0x04030201;

    return ();
}

@external
func test_read_uint64{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let (array) = alloc();
    assert array[0] = 0x00e40b54;
    assert array[1] = 0x02000000;

    let (reader) = init_reader(array);

    let (uint64) = read_uint64{reader=reader}();
    assert uint64 = 10000000000;

    return ();
}

@external
func test_read_varint{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let (array) = alloc();
    assert array[0] = 0x01fd0102;
    assert array[1] = 0xfe010203;
    assert array[2] = 0x04ff0102;
    assert array[3] = 0x03040506;
    assert array[4] = 0x07080000;

    let (reader) = init_reader(array);

    let (varint8, byte_size) = read_varint{reader=reader}();
    assert varint8 = 0x01;
    assert byte_size = 1;

    let (varint16, byte_size) = read_varint{reader=reader}();
    assert varint16 = 0x0201;
    assert byte_size = 3;

    let (varint32, byte_size) = read_varint{reader=reader}();
    assert varint32 = 0x04030201;
    assert byte_size = 5;

    let (varint64, byte_size) = read_varint{reader=reader}();
    assert varint64 = 0x0807060504030201;
    assert byte_size = 9;

    return ();
}

@external
func test_a_series_of_different_reads{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let (array) = alloc();
    assert array[0] = 0x01020304;
    assert array[1] = 0x05060708;
    assert array[2] = 0x090a0b0c;

    let (reader) = init_reader(array);

    let (unit8_1) = read_uint8{reader=reader}();
    let (unit8_2) = read_uint8{reader=reader}();
    let (uint32_1) = read_uint32{reader=reader}();
    let (uint32_2) = read_uint32{reader=reader}();
    let (uint16) = read_uint16{reader=reader}();  // read the complete buffer until the last byte

    assert unit8_1 = 0x01;
    assert unit8_2 = 0x02;
    assert uint32_1 = 0x06050403;
    assert uint32_2 = 0x0a090807;
    assert uint16 = 0x0c0b;

    return ();
}

@external
func test_read_bytes{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let (array) = alloc();
    assert array[0] = 0x01020304;
    assert array[1] = 0x05060708;
    assert array[2] = 0x090a0b0c;
    assert array[3] = 0x0d0e0f10;
    assert array[4] = 0x11121314;
    assert array[5] = 0x15161718;

    let (reader) = init_reader(array);

    let (bytes3) = read_bytes{reader=reader}(3);
    let (bytes5) = read_bytes{reader=reader}(5);
    let (bytes6) = read_bytes{reader=reader}(6);
    let (bytes7) = read_bytes{reader=reader}(7);

    assert bytes3[0] = 0x00030201;

    assert bytes5[0] = 0x07060504;
    assert bytes5[1] = 0x00000008;

    assert bytes6[0] = 0x0c0b0a09;
    assert bytes6[1] = 0x00000e0d;

    assert bytes7[0] = 0x1211100f;
    assert bytes7[1] = 0x00151413;

    return ();
}

@external
func test_read_bytes_endian{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let (array) = alloc();
    assert array[0] = 0x01020304;
    assert array[1] = 0x05060708;
    assert array[2] = 0x090a0b0c;
    assert array[3] = 0x0d0e0f10;
    assert array[4] = 0x11121314;
    assert array[5] = 0x15161718;

    let (reader) = init_reader(array);

    let (bytes3) = read_bytes_endian{reader=reader}(3);
    let (bytes5) = read_bytes_endian{reader=reader}(5);
    let (bytes6) = read_bytes_endian{reader=reader}(6);
    let (bytes7) = read_bytes_endian{reader=reader}(7);

    // assert bytes3[0] = 0x03020100
    assert bytes3[0] = 0x01020300;

    assert bytes5[0] = 0x04050607;
    assert bytes5[1] = 0x08000000;

    assert bytes6[0] = 0x090a0b0c;
    assert bytes6[1] = 0x0d0e0000;  // 0e0d0000

    assert bytes7[0] = 0x0f101112;
    assert bytes7[1] = 0x13141500;

    return ();
}

@external
func test_read_2_4_8_bytes{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let (array) = alloc();
    assert array[0] = 0x01020304;
    assert array[1] = 0x050600e4;
    assert array[2] = 0x0b540200;
    assert array[3] = 0x00000000;

    let (reader) = init_reader(array);

    let (uint16) = read_uint16{reader=reader}();
    assert uint16 = 0x0201;

    let (uint32) = read_uint32{reader=reader}();
    assert uint32 = 0x06050403;

    let (uint64) = read_uint64{reader=reader}();
    assert uint64 = 10000000000;

    return ();
}

// TODO
@external
func test_read_overflow_uint32{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    assert array[0] = 0x05010203ff;

    let (reader) = init_reader(array);

    // %{ expect_revert() %}
    let (uint32) = read_uint32{reader=reader}();

    return ();
}

@external
func test_writer{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    let (writer) = init_writer(array);
    write_uint8{writer=writer}(0x01);
    write_uint32_endian{writer=writer}(0x02030405);
    write_uint32_endian{writer=writer}(0x06070809);
    flush_writer(writer);

    assert array[0] = 0x01020304;
    assert array[1] = 0x05060708;
    assert array[2] = 0x09000000;
    return ();
}

@external
func test_write_uint8{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    let (writer) = init_writer(array);

    write_uint8{writer=writer}(0x01);

    assert array[0] = 0x01;

    return ();
}

@external
func test_write_uint16{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    let (writer) = init_writer(array);

    write_uint16{writer=writer}(0x0201);

    assert array[0] = 0x0201;

    return ();
}

@external
func test_write_uint32{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    let (writer) = init_writer(array);

    write_uint32{writer=writer}(0x04030201);

    assert array[0] = 0x01020304;

    return ();
}

@external
func test_write_uint64{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    let (writer) = init_writer(array);

    write_uint64{writer=writer}(0x0807060504030201);

    assert array[0] = 0x01020304;
    assert array[1] = 0x05060708;

    return ();
}

@external
func test_write_varint{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    let (writer) = init_writer(array);

    // Write every type of varint.
    write_varint{writer=writer}(0x01);
    write_varint{writer=writer}(0x0102);
    write_varint{writer=writer}(0x01020304);
    write_varint{writer=writer}(0x0102030405060708);

    // Write every full varint.
    write_varint{writer=writer}(0xff);
    write_varint{writer=writer}(0xffff);
    write_varint{writer=writer}(0xffffffff);
    write_varint{writer=writer}(0xffffffffffffffff);

    assert array[0] = 0x01fd0201;
    assert array[1] = 0xfe040302;
    assert array[2] = 0x01ff0807;
    assert array[3] = 0x06050403;
    assert array[4] = 0x0201fffd;

    assert array[5] = 0xfffffeff;
    assert array[6] = 0xffffffff;
    assert array[7] = 0xffffffff;
    assert array[8] = 0xffffffff;

    // Try to write varint bigger than 8 bytes
    %{ expect_revert() %}
    write_varint{writer=writer}(0x010203040506070809);

    return ();
}

@external
func test_write_uint32_endian{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    let (writer) = init_writer(array);

    write_uint32_endian{writer=writer}(0x01020304);

    assert array[0] = 0x01020304;

    return ();
}

@external
func test_write_2_4_8_bytes{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    let (writer) = init_writer(array);

    write_uint16{writer=writer}(0x0102);
    write_uint32{writer=writer}(0x01020304);
    write_uint64{writer=writer}(0x0102030405060708);
    flush_writer(writer);

    assert array[0] = 0x02010403;
    assert array[1] = 0x02010807;
    assert array[2] = 0x06050403;
    assert array[3] = 0x02010000;

    return ();
}

@external
func test_write_hash{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    let (hash) = alloc();
    let (writer) = init_writer(array);

    assert hash[0] = 0x01020304;
    assert hash[1] = 0x05060708;
    assert hash[2] = 0x090a0b0c;
    assert hash[3] = 0x0d0e0f00;
    assert hash[4] = 0x01020304;
    assert hash[5] = 0x05060708;
    assert hash[6] = 0x090a0b0c;
    assert hash[7] = 0x0d0e0f00;

    write_hash{writer=writer}(hash);
    assert_hashes_equal(hash, array);

    return ();
}

@external
func test_byte_size_to_felt_size{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (felt_size_1_byte) = byte_size_to_felt_size(byte_size=1);
    assert felt_size_1_byte = 1;

    let (felt_size_4_byte) = byte_size_to_felt_size(byte_size=4);
    assert felt_size_4_byte = 1;

    let (felt_size_5_byte) = byte_size_to_felt_size(byte_size=5);
    assert felt_size_5_byte = 2;

    let (felt_size_999_byte) = byte_size_to_felt_size(byte_size=999);
    assert felt_size_999_byte = 250;

    let (felt_size_1000_byte) = byte_size_to_felt_size(byte_size=1000);
    assert felt_size_1000_byte = 250;
    
    return ();
}
