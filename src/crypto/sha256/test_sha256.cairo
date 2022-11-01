//
// To run only this test suite use:
// protostar test --cairo-path=./src target src/**/*_sha256*
//
// Test vectors: https://www.di-mgt.com.au/sha_testvectors.html
//               https://github.com/bitcoin/bitcoin/blob/master/src/test/crypto_tests.cpp
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256

from utils.python_utils import setup_python_defs
from crypto.sha256.sha256 import sha256, _sha256
from crypto.sha256d.sha256d import assert_hashes_equal

@external
func test_sha256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    

    let felt_size = 1;

    // Set input to "abc"
    let (input) = alloc();
    assert input[0] = 0x61626300;
    let byte_size = 3;

    // ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad
    let (hash) = _sha256(felt_size, input, byte_size);
    with_attr error_message("The sha256 hash does not match the expected result.") {
        assert 0xba7816bf = hash[0];
        assert 0x8f01cfea = hash[1];
        assert 0x414140de = hash[2];
        assert 0x5dae2223 = hash[3];
        assert 0xb00361a3 = hash[4];
        assert 0x96177a9c = hash[5];
        assert 0xb410ff61 = hash[6];
        assert 0xf20015ad = hash[7];
    }

    return ();
}


// Test a sha256 input with 1'000'000 repetitions of the character "a".
// This results in a 2'000'000 byte test vector.
// Note: This test does only work with increased protostar step limit (our patched version).
// See also:
//    https://www.di-mgt.com.au/sha_testvectors.html
// @external
func test_sha256_16M_bits{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();
    let (input) = alloc();
    let (expected_output) = alloc();
    local input_byte_size: felt;
    local input_felt_size: felt;

    %{
        test_string = "a" * 1000000
        import hashlib
        ids.input_byte_size, ids.input_felt_size = from_string(test_string, ids.input)
        # Compute expected hash from the python hashlib library.
        expected_hash = "cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0"
        from_hex(expected_hash, ids.expected_output)
    %}

    let (output) = sha256(input, input_byte_size);
    with_attr error_message("The hash does not match the expected output.") {
        assert_hashes_equal(output, expected_output);
    }
    return ();
}


// Test a sha256 input with 10'000 repetitions of the character "a".
// This results in a 20'000 byte test vector.
//
@external
func test_sha256_160K_bits{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();
    let (input) = alloc();
    let (expected_output) = alloc();
    local input_byte_size: felt;
    local input_felt_size: felt;

    %{
        test_string = "a" * 10000
        import hashlib
        ids.input_byte_size, ids.input_felt_size = from_string(test_string, ids.input)
        # Compute expected hash from the python hashlib library.
        expected_hash = hashlib.sha256(test_string.encode("ascii")).hexdigest()
        from_hex(expected_hash, ids.expected_output)
    %}

    let (output) = sha256(input, input_byte_size);
    with_attr error_message("The hash does not match the expected output.") {
        assert_hashes_equal(output, expected_output);
    }
    return ();
}

// Test sha256 with a 896 bit long test vector as input.
//
// See also:
//    https://www.di-mgt.com.au/sha_testvectors.html
@external
func test_sha256_896_bits{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();
    let (input) = alloc();
    let (expected_output) = alloc();
    local input_byte_size: felt;
    local input_felt_size: felt;

    %{
        test_string = "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
        import hashlib
        ids.input_byte_size, ids.input_felt_size = from_string(test_string, ids.input)
        # Compute expected hash from the python hashlib library.
        expected_hash = hashlib.sha256(test_string.encode("ascii")).hexdigest()
        from_hex(expected_hash, ids.expected_output)
    %}

    let (output) = sha256(input, input_byte_size);
    with_attr error_message("The hash does not match the expected output.") {
        assert_hashes_equal(output, expected_output);
    }
    return ();
}

// Test for the bug in the cartridge_gg implementation
@external
func test_sha256_64_bytes{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();
    let (input) = alloc();
    let (expected_output) = alloc();
    local input_byte_size: felt;
    local input_felt_size: felt;

    %{
        test_string = "0000111122223333444455556666777788889999aaaabbbbccccddddeeeeffff"
        import hashlib
        ids.input_byte_size, ids.input_felt_size = from_string(test_string, ids.input)
        # Compute expected hash from the python hashlib library.
        expected_hash = hashlib.sha256(test_string.encode("ascii")).hexdigest()
        from_hex(expected_hash, ids.expected_output)
    %}

    let (output) = sha256(input, input_byte_size);
    with_attr error_message("The hash does not match the expected output.") {
        assert_hashes_equal(output, expected_output);
    }
    return ();
}

// TODO: Test that sha256 validates that every element of the input array is an uint32
// and throws and error otherwise
