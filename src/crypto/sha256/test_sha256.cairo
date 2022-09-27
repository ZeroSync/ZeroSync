//
// To run only this test suite use:
// protostar test --cairo-path=./src target src/**/*_sha256*
//
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256

from python_utils import setup_python_defs
from crypto.sha256.sha256 import sha256, _sha256
from crypto.sha256d.sha256d import assert_hashes_equal

@external
func test_sha256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    // Test vectors: https://www.di-mgt.com.au/sha_testvectors.html
    // Test vectors: https://github.com/bitcoin/bitcoin/blob/master/src/test/crypto_tests.cpp

    let felt_size = 1;

    // Set input to "abc"
    let (input) = alloc();
    assert input[0] = 0x61626300;
    let byte_size = 3;

    // ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad
    let (hash) = _sha256(felt_size, input, byte_size);
    assert hash[0] = 0xba7816bf;
    assert hash[1] = 0x8f01cfea;
    assert hash[2] = 0x414140de;
    assert hash[3] = 0x5dae2223;
    assert hash[4] = 0xb00361a3;
    assert hash[5] = 0x96177a9c;
    assert hash[6] = 0xb410ff61;
    assert hash[7] = 0xf20015ad;

    return ();
}

// Test a sha256 input with a long byte string
// We use a 112 byte test vector here
//
@external
func test_sha256_long_input{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    // Use Python to convert hex string into uint32 array
    let (input) = alloc();
    local byte_size;
    let (hash_expected) = alloc();

    setup_python_defs();
    %{
        (ids.byte_size, _) = from_string(
            "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu",
            ids.input)

        from_hex(
            "cf5b16a778af8380036ce59e7b0492370b249b11e8f07a51afac45037afee9d1",
            ids.hash_expected)
    %}

    let (hash) = sha256(input, byte_size);

    assert_hashes_equal(hash_expected, hash);
    return ();
}

// Test a sha256 input with 1'000'000 repetitions of the character "a"
// This results in a 2'000'000 byte test vector
//
// See also:
//    https://www.di-mgt.com.au/sha_testvectors.html
// @external
func test_sha256_super_long_input{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
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
    assert_hashes_equal(output, expected_output);
    return ();
}

@external
func test_sha256_dummy{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();
    let (input) = alloc();
    let (expected_output) = alloc();
    local input_byte_size: felt;
    local input_felt_size: felt;

    %{
        test_string = "Hello world"
        import hashlib
        ids.input_byte_size, ids.input_felt_size = from_string(test_string, ids.input)
        # Compute expected hash from the python hashlib library.
        expected_hash = hashlib.sha256(test_string.encode("ascii")).hexdigest()
        from_hex(expected_hash, ids.expected_output)
    %}

    let (output) = sha256(input, input_byte_size);
    assert_hashes_equal(output, expected_output);
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
    assert_hashes_equal(output, expected_output);
    return ();
}

// TODO: Test that sha256 validates that every element of the input array is an uint32
// and throws and error otherwise
