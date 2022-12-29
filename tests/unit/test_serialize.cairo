//
// To run only this test suite use:
// protostar test --cairo-path=./src target tests/unit/*_serialize*
//

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from crypto.hash_utils import assert_hashes_equal
from utils.serialize import (
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

    let reader = init_reader( new (0x01020304, 0x05000000) );

    with reader {
        let uint8_1 = read_uint8();
        let uint8_2 = read_uint8();
        let uint8_3 = read_uint8();
        let uint8_4 = read_uint8();
        let uint8_5 = read_uint8();
    }
    assert uint8_1 = 0x01;
    assert uint8_2 = 0x02;
    assert uint8_3 = 0x03;
    assert uint8_4 = 0x04;
    assert uint8_5 = 0x05;

    return ();
}

@external
func test_read_uint16{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let reader = init_reader( new (0x01020304) );

    with reader {
        let uint16 = read_uint16();
    }
    assert uint16 = 0x0201;

    return ();
}

@external
func test_read_uint32{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let reader = init_reader( new (0x01020304) );

    with reader {
        let uint32 = read_uint32();
    }
    assert uint32 = 0x04030201;

    return ();
}

@external
func test_read_uint64{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let reader = init_reader( new (0x00e40b54, 0x02000000) );

    with reader {
        let uint64 = read_uint64();
    }
    assert uint64 = 10000000000;

    return ();
}

@external
func test_read_varint{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let reader = init_reader( new (0x01fd0102, 0xfe010203, 0x04ff0102, 0x03040506, 0x07080000) );
    with reader {
        let (varint8, byte_size_1) = read_varint();
        let (varint16, byte_size_2) = read_varint();
        let (varint32, byte_size_3) = read_varint();
        let (varint64, byte_size_4) = read_varint();
    }
    assert varint8 = 0x01;
    assert varint16 = 0x0201;
    assert varint32 = 0x04030201;
    assert varint64 = 0x0807060504030201;
    assert byte_size_1 = 1;
    assert byte_size_2 = 3;
    assert byte_size_3 = 5;
    assert byte_size_4 = 9;

    return ();
}

@external
func test_a_series_of_different_reads{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let reader = init_reader( new (0x01020304, 0x05060708, 0x090a0b0c) );

    with reader {
        let unit8_1 = read_uint8();
        let unit8_2 = read_uint8();
        let uint32_1 = read_uint32();
        let uint32_2 = read_uint32();
        let uint16 = read_uint16();  // read the complete buffer until the last byte
    }

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

    let reader = init_reader( new (0x01020304, 0x05060708, 0x090a0b0c,
                                   0x0d0e0f10, 0x11121314, 0x15161718) );

    with reader {
        let bytes3 = read_bytes(3);
        let bytes5 = read_bytes(5);
        let bytes6 = read_bytes(6);
        let bytes7 = read_bytes(7);
    }

    assert 0x00030201 = bytes3[0];

    assert 0x07060504 = bytes5[0];
    assert 0x00000008 = bytes5[1];

    assert 0x0c0b0a09 = bytes6[0];
    assert 0x00000e0d = bytes6[1];

    assert 0x1211100f = bytes7[0];
    assert 0x00151413 = bytes7[1];

    return ();
}

@external
func test_read_bytes_endian{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let reader = init_reader( new (0x01020304, 0x05060708, 0x090a0b0c,
                                   0x0d0e0f10, 0x11121314, 0x15161718) );

    with reader {
        let bytes3 = read_bytes_endian(3);
        let bytes5 = read_bytes_endian(5);
        let bytes6 = read_bytes_endian(6);
        let bytes7 = read_bytes_endian(7);
    }

    assert 0x01020300 = bytes3[0];

    assert 0x04050607 = bytes5[0];
    assert 0x08000000 = bytes5[1];

    assert 0x090a0b0c = bytes6[0];
    assert 0x0d0e0000 = bytes6[1];

    assert 0x0f101112 = bytes7[0];
    assert 0x13141500 = bytes7[1];

    return ();
}

@external
func test_read_2_4_8_bytes{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let reader = init_reader( new (0x01020304, 0x050600e4, 0x0b540200, 0x00000000) );

    with reader {
        let uint16 = read_uint16();
        let uint32 = read_uint32();
        let uint64 = read_uint64();
    }
    assert uint16 = 0x0201;
    assert uint32 = 0x06050403;
    assert uint64 = 10000000000;

    return ();
}

@external
func test_read_uint32_overflow{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    
    let reader = init_reader( new (0x05010203ff) );

    with reader {
        let uint32 = read_uint32();
    }

    assert 0xff030201 = uint32;

    return ();
}

@external
func test_writer{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    let writer = init_writer(array);
    with writer {
        write_uint8(0x01);
        write_uint32_endian(0x02030405);
        write_uint32_endian(0x06070809);
    }
    flush_writer(writer);

    assert 0x01020304 = array[0];
    assert 0x05060708 = array[1];
    assert 0x09000000 = array[2];
    return ();
}

@external
func test_write_uint8{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    let writer = init_writer(array);
    
    with writer {
        write_uint8(0x01);
    }
    flush_writer(writer);

    assert 0x01000000 = [array];

    return ();
}

@external
func test_write_uint16{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    let writer = init_writer(array);

    with writer {
        write_uint16(0x0201);
    }
    flush_writer(writer);
    assert 0x01020000 = [array];

    return ();
}

@external
func test_write_uint32{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    let writer = init_writer(array);

    with writer {
        write_uint32(0x04030201);
    }
    // NOTE: this is a special case working without calling `flush_writer`

    assert 0x01020304 = [array];

    return ();
}

@external
func test_write_uint64{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    let writer = init_writer(array);

    with writer {
        write_uint64(0x0807060504030201);
    }
    // NOTE: this is a special case working without calling `flush_writer`

    assert 0x01020304 = array[0];
    assert 0x05060708 = array[1];

    return ();
}

@external
func test_write_varint{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    let writer = init_writer(array);

    with writer {
        // Write every type of varint.
        write_varint(0x01);
        write_varint(0x0102);
        write_varint(0x01020304);
        write_varint(0x0102030405060708);
        
        // Write every full varint.
        write_varint(0xff);
        write_varint(0xffff);
        write_varint(0xffffffff);
        write_varint(0xffffffffffffffff);
    }
    flush_writer(writer);

    assert 0x01fd0201 = array[0];
    assert 0xfe040302 = array[1];
    assert 0x01ff0807 = array[2];
    assert 0x06050403 = array[3];
    assert 0x0201fffd = array[4];

    assert 0xfffffeff = array[5];
    assert 0xffffffff = array[6];
    assert 0xffffffff = array[7];
    assert 0xffffffff = array[8];

    // Try to write varint bigger than 8 bytes
    %{ expect_revert() %}
    with writer {
        write_varint(0x010203040506070809);
    }

    return ();
}

@external
func test_write_uint32_endian{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    let writer = init_writer(array);

    with writer {
        write_uint32_endian(0x01020304);
    }
    flush_writer(writer);

    assert 0x01020304 = [array];

    return ();
}

@external
func test_write_2_4_8_bytes{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    let writer = init_writer(array);

    with writer {
        write_uint16(0x0102);
        write_uint32(0x01020304);
        write_uint64(0x0102030405060708);
    }
    flush_writer(writer);

    assert 0x02010403 = array[0];
    assert 0x02010807 = array[1];
    assert 0x06050403 = array[2];
    assert 0x02010000 = array[3];

    return ();
}

@external
func test_write_hash{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (array) = alloc();
    local hash: felt* = new (0x01020304, 0x05060708, 0x090a0b0c, 0x0d0e0f00,
                             0x01020304, 0x05060708, 0x090a0b0c, 0x0d0e0f00);
    let writer = init_writer(array);

    with writer {
        write_hash( hash );
    }
    assert_hashes_equal(hash, array);

    return ();
}

@external
func test_byte_size_to_felt_size{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let felt_size_1_byte = byte_size_to_felt_size(byte_size=1);
    assert felt_size_1_byte = 1;

    let felt_size_4_byte = byte_size_to_felt_size(byte_size=4);
    assert felt_size_4_byte = 1;

    let felt_size_5_byte = byte_size_to_felt_size(byte_size=5);
    assert felt_size_5_byte = 2;

    let felt_size_999_byte = byte_size_to_felt_size(byte_size=999);
    assert felt_size_999_byte = 250;

    let felt_size_1000_byte = byte_size_to_felt_size(byte_size=1000);
    assert felt_size_1000_byte = 250;

    return ();
}