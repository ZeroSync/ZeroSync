//
// To run only this test suite use:
// protostar test --cairo-path=./src target src/**/*_sha256.cairo
//
// Test vectors: https://www.di-mgt.com.au/sha_testvectors.html
//               https://github.com/bitcoin/bitcoin/blob/master/src/test/crypto_tests.cpp
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256

from utils.python_utils import setup_python_defs
from crypto.sha256.sha256 import compute_sha256
from crypto.sha256d.sha256d import assert_hashes_equal
from crypto.sha256.sha256 import finalize_sha256

@external
func test_sha256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    
    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;

    // Set input to "abc"
    let (input) = alloc();
    assert input[0] = 0x61626300;
    let byte_size = 3;

    // ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad
    with sha256_ptr {
        let (hash) = compute_sha256(input, byte_size);
    }

    assert 0xba7816bf = hash[0];
    assert 0x414140de = hash[2];
    assert 0x5dae2223 = hash[3];
    assert 0xb00361a3 = hash[4];
    assert 0x96177a9c = hash[5];
    assert 0xb410ff61 = hash[6];
    assert 0xf20015ad = hash[7];

    // finalize sha256_ptr
    finalize_sha256(sha256_ptr_start, sha256_ptr);

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
    %{
        test_string = "a" * 1000000
        import hashlib
        ids.input_byte_size, _ = from_string(test_string, ids.input)
        # Compute expected hash from the python hashlib library.
        expected_hash = "cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0"
        from_hex(expected_hash, ids.expected_output)
    %}

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;
    with sha256_ptr {
        let (output) = compute_sha256(input, input_byte_size);
    }
    assert_hashes_equal(output, expected_output);
    // finalize sha256_ptr
    finalize_sha256(sha256_ptr_start, sha256_ptr);
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
    %{
        test_string = "a" * 10000
        import hashlib
        ids.input_byte_size, _ = from_string(test_string, ids.input)
        # Compute expected hash from the python hashlib library.
        expected_hash = hashlib.sha256(test_string.encode("ascii")).hexdigest()
        from_hex(expected_hash, ids.expected_output)
    %}

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;
    with sha256_ptr {
        let (output) = compute_sha256(input, input_byte_size);
    }
    assert_hashes_equal(output, expected_output);
    // finalize sha256_ptr
    finalize_sha256(sha256_ptr_start, sha256_ptr);
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
    %{
        test_string = "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
        import hashlib
        ids.input_byte_size, _ = from_string(test_string, ids.input)
        # Compute expected hash from the python hashlib library.
        expected_hash = hashlib.sha256(test_string.encode("ascii")).hexdigest()
        from_hex(expected_hash, ids.expected_output)
    %}

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;
    with sha256_ptr {
        let (output) = compute_sha256(input, input_byte_size);
    }
    assert_hashes_equal(output, expected_output);
    // finalize sha256_ptr
    finalize_sha256(sha256_ptr_start, sha256_ptr);
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
    %{
        test_string = "0000111122223333444455556666777788889999aaaabbbbccccddddeeeeffff"
        import hashlib
        ids.input_byte_size, _ = from_string(test_string, ids.input)
        # Compute expected hash from the python hashlib library.
        expected_hash = hashlib.sha256(test_string.encode("ascii")).hexdigest()
        from_hex(expected_hash, ids.expected_output)
    %}

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;
    with sha256_ptr {
        let (output) = compute_sha256(input, input_byte_size);
    }
    assert_hashes_equal(output, expected_output);
    // finalize sha256_ptr
    finalize_sha256(sha256_ptr_start, sha256_ptr);
    return ();
}

// Test that sha256 validates that every element of the input array is an uint32
// and throws and error otherwise
//
@external
func test_sha256_uint32_overflow{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let n_bytes = 16;
    let (input) = alloc();
    assert [input + 0] = 0x0FFFFFFFF;
    assert [input + 1] = 0x100000000;
    assert [input + 2] = 0x00000FFFF;
    assert [input + 3] = 0x000010000;

    %{ expect_revert() %}
    
    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;
    with sha256_ptr {
        let (output) = compute_sha256(input, n_bytes);
    }
    
    // finalize sha256_ptr
    finalize_sha256(sha256_ptr_start, sha256_ptr);
    return ();
}

// @external
// NOTE: padding bytes should be zero or ignored from sha256
//
func test_sha256_uint32_padding{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    
    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;
    
    let n_bytes = 14;
    let (input) = alloc();
    assert [input + 0] = 0xFFFFFFFF;
    assert [input + 1] = 0xFFFFFFFF;
    assert [input + 2] = 0xFFFFFFFF;
    assert [input + 3] = 0xFFFFFFFF;
    with sha256_ptr {
        let (output_0) = compute_sha256(input, n_bytes);
    }

    let n_bytes = 14;
    let (input) = alloc();
    assert [input + 0] = 0xFFFFFFFF;
    assert [input + 1] = 0xFFFFFFFF;
    assert [input + 2] = 0xFFFFFFFF;
    assert [input + 3] = 0xFFFF0000;
    with sha256_ptr {
        let (output_1) = compute_sha256(input, n_bytes);
    }

    assert_hashes_equal(output_0, output_1);
    
    // finalize sha256_ptr
    finalize_sha256(sha256_ptr_start, sha256_ptr);
    return ();
}
