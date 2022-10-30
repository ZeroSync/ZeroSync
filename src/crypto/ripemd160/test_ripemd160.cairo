//
// To run only this test suite use:
// protostar test --cairo-path=./src target src/**/*_ripemd160*
//
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from utils.python_utils import setup_python_defs
from crypto.ripemd160.ripemd160 import ripemd160, _compute_ripemd160_fake
from crypto.ripemd160.euler_smile.rmd160 import padding

@external
func test_ripemd160{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let felt_size = 1;

    // Set input to "abc"
    let (input) = alloc();
    assert input[0] = 0x61626300;
    let byte_size = 3;

    // result: 0x8eb208f7e05d987a9b044a8e98c6b087f15a0bfc
    let (hash) = ripemd160(input, byte_size);

    let (result_hash) = _compute_ripemd160_fake(felt_size, input, byte_size);
    with_attr error_message("Ripemd160 hash does not match the expected result.") {
        assert hash[0] = 0x8eb208f7;
        assert hash[1] = 0xe05d987a;
        assert hash[2] = 0x9b044a8e;
        assert hash[3] = 0x98c6b087;
        assert hash[4] = 0xf15a0bfc;
    }

    return ();
}


// @external
func test_padding_abc{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let n_felts = 1;
    let n_bytes = 3;

    let (input) = alloc();
    assert input[0] = 0x61626300;

    let (word_arr) = padding(input, n_bytes, n_felts);

    assert word_arr[0] = 0x61626380;
    assert word_arr[1] = 0;
    assert word_arr[2] = 0;
    assert word_arr[3] = 0;
    assert word_arr[4] = 0;
    assert word_arr[5] = 0;
    assert word_arr[6] = 0;
    assert word_arr[7] = 0;

    assert word_arr[8] = 0;
    assert word_arr[9] = 0;
    assert word_arr[10] = 0;
    assert word_arr[11] = 0;
    assert word_arr[12] = 0;
    assert word_arr[13] = 0;
    assert word_arr[14] = 0;
    assert word_arr[15] = n_bytes;

    return ();
}

// @external
// TODO: add more cases for each n_bytes remaining
func test_padding{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let n_felts = 7;
    let n_bytes = 26;

    let (input) = alloc();
    assert input[0] = 0x01020304;
    assert input[1] = 0x05060708;
    assert input[2] = 0x090a0b0c;
    assert input[3] = 0x0d0e0f00;
    assert input[4] = 0x01020304;
    assert input[5] = 0x05060708;
    assert input[6] = 0x090a0000;

    let (word_arr) = padding(input, n_bytes, n_felts);

    // %{ print([memory[ids.word_arr + i] for i in range(0,16)]) %}

    assert word_arr[0] = 0x01020304;
    assert word_arr[1] = 0x05060708;
    assert word_arr[2] = 0x090a0b0c;
    assert word_arr[3] = 0x0d0e0f00;
    assert word_arr[4] = 0x01020304;
    assert word_arr[5] = 0x05060708;
    assert word_arr[6] = 0x090a8000;  // The end has to be padded with "1"
    assert word_arr[7] = 0;

    assert word_arr[8] = 0;
    assert word_arr[9] = 0;
    assert word_arr[10] = 0;
    assert word_arr[11] = 0;
    assert word_arr[12] = 0;
    assert word_arr[13] = 0;
    assert word_arr[14] = 0;
    assert word_arr[15] = n_bytes;

    return ();
}
