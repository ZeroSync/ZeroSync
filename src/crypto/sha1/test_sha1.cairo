//
// To run only this test suite use:
// protostar test --cairo-path=./src target src/**/*_sha1*
//
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from utils.python_utils import setup_python_defs
from crypto.sha1.sha1 import sha1, BYTE

@external
func test_sha1_empty{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    let (data_ptr) = alloc();
    let hash = sha1(data_ptr, 0);
    with_attr error_message("The sha1 hash does not match the expected result.") {
        assert 0xda39a3ee5e6b4b0d3255bfef95601890afd80709 = hash;
    }
    return ();
}

@external
func test_sha1_00001111{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    // prepare dummy input data
    let (data_ptr) = alloc();
    assert [data_ptr + 0]  = 0x00001111;
    assert [data_ptr + 1]  = 0x22223333;
    assert [data_ptr + 2]  = 0x44445555;
    assert [data_ptr + 3]  = 0x66667777;
    assert [data_ptr + 4]  = 0x88889999;
    assert [data_ptr + 5]  = 0xaaaabbbb;
    assert [data_ptr + 6]  = 0xccccdddd;
    assert [data_ptr + 7]  = 0xeeeeffff;
    let n_bytes = 32;
    let hash = sha1(data_ptr, n_bytes);
    with_attr error_message("The sha1 hash does not match the expected result.") {
        assert 0x460d008db9aa9ffadb2c6f2b1f74201a87f0881a = hash;
    }
    return ();
}

@external
func test_sha1_00000011{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    // prepare dummy input data
    let (data_ptr) = alloc();
    assert [data_ptr + 0]  = 0x00000011;
    assert [data_ptr + 1]  = 0x11112222;
    assert [data_ptr + 2]  = 0x22333333;
    assert [data_ptr + 3]  = 0x44444455;
    assert [data_ptr + 4]  = 0x55556666;
    assert [data_ptr + 5]  = 0x66777777;
    assert [data_ptr + 6]  = 0x88888899;
    assert [data_ptr + 7]  = 0x9999aaaa;
    assert [data_ptr + 8]  = 0xaabbbbbb;
    assert [data_ptr + 9]  = 0xccccccdd;
    assert [data_ptr + 10] = 0xddddeeee;
    assert [data_ptr + 11] = 0xeeffffff;
    let n_bytes = 48;
    let hash = sha1(data_ptr, n_bytes);
    with_attr error_message("The sha1 hash does not match the expected result.") {
        assert 0x6e793c896f19efbd65dd89633ec264a959137a3e = hash;
    }
    return ();
}

@external
func test_sha1_abc{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    let (data_ptr) = alloc();
    assert [data_ptr] = 'abc' * BYTE;
    let hash = sha1(data_ptr, 3);
    with_attr error_message("The sha1 hash does not match the expected result.") {
        assert 0xa9993e364706816aba3e25717850c26c9cd0d89d = hash;
    }
    return ();
}

@external
func test_sha1{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    // Test vectors: https://www.di-mgt.com.au/sha_testvectors.html
    // Test vectors: https://github.com/bitcoin/bitcoin/blob/master/src/test/crypto_tests.cpp

    // Set input to "abc"
    let (input) = alloc();
    assert input[0] = 0x61626300;
    let byte_size = 3;

    // a9993e364706816aba3e25717850c26c9cd0d89d
    let hash = sha1(input, byte_size);
    with_attr error_message("The sha1 hash does not match the expected result.") {
        assert 0xa9993e364706816aba3e25717850c26c9cd0d89d = hash;
    }

    return ();
}
