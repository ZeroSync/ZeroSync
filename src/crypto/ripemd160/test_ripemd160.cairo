//
// To run only this test suite use:
// protostar test --cairo-path=./src target src/**/*_ripemd160*
//
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from utils.python_utils import setup_python_defs
from crypto.ripemd160.ripemd160 import ripemd160, _compute_ripemd160_fake
from crypto.ripemd160.euler_smile.rmd160 import pad_input

// Test RIPEMD160 with "abc" test vector.
// See: https://homes.esat.kuleuven.be/~bosselae/ripemd160.html
@external
func test_ripemd160_abc{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let felt_size = 1;

    // Set input to "abc"
    let (input) = alloc();
    assert input[0] = 0x61626300;
    let byte_size = 3;

    // result: 0x8eb208f7e05d987a9b044a8e98c6b087f15a0bfc
    let (hash) = ripemd160(input, byte_size);

    with_attr error_message("Ripemd160 hash does not match the expected result.") {
      assert 0x8eb208f7 = hash[0];
      assert 0xe05d987a = hash[1];
      assert 0x9b044a8e = hash[2];
      assert 0x98c6b087 = hash[3];
      assert 0xf15a0bfc = hash[4];
    }

    return ();
}

// Test RIPEMD160 with empty test vector.
// See: https://homes.esat.kuleuven.be/~bosselae/ripemd160.html
@external
func test_ripemd160_empty_string{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();

    let felt_size = 0;
    let byte_size = 0;

    // Set input to ""
    let (input) = alloc();

    let (expected_result) = alloc();
    %{ from_hex("9c1185a5c5e9fc54612808977ee8f548b2258d31",ids.expected_result) %}
    let (hash) = ripemd160(input, byte_size);

    // %{
    //    print("hash: ", [hex(memory[ids.hash + i]) for i in range(0,5)])
    //    print("expected hash: ", [hex(memory[ids.expected_result + i]) for i in range(0,5)])
    // %}
    with_attr error_message("Ripemd160 hash does not match the expected result.") {
        assert hash[0] = expected_result[0];
        assert hash[1] = expected_result[1];
        assert hash[2] = expected_result[2];
        assert hash[3] = expected_result[3];
        assert hash[4] = expected_result[4];
    }

    return ();
}

// Test RIPEMD160 with a..z vector.
// See: https://homes.esat.kuleuven.be/~bosselae/ripemd160.html
@external
func test_ripemd160_a_z{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();

    local felt_size;
    local byte_size;

    let (input) = alloc();
    let (expected_result) = alloc();

    %{
        from_hex("f71c27109c692c1b56bbdceb5b9d2865b3708dbc",ids.expected_result)
        ids.byte_size, ids.felt_size = from_string("abcdefghijklmnopqrstuvwxyz", ids.input)
    %}
    let (hash) = ripemd160(input, byte_size);

    // %{
    //    print("hash: ", [hex(memory[ids.hash + i]) for i in range(0,5)])
    //    print("expected hash: ", [hex(memory[ids.expected_result + i]) for i in range(0,5)])
    // %}
    with_attr error_message("Ripemd160 hash does not match the expected result.") {
        assert hash[0] = expected_result[0];
        assert hash[1] = expected_result[1];
        assert hash[2] = expected_result[2];
        assert hash[3] = expected_result[3];
        assert hash[4] = expected_result[4];
    }

    return ();
}

// Test RIPEMD160 with 496 bit vector.
// See: https://homes.esat.kuleuven.be/~bosselae/ripemd160.html
@external
func test_ripemd160_496_bits{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();

    local felt_size;
    local byte_size;

    let (input) = alloc();
    let (expected_result) = alloc();

    %{
        from_hex("b0e20b6e3116640286ed3a87a5713079b21f5189",ids.expected_result)
        ids.byte_size, ids.felt_size = from_string("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789", ids.input)
    %}
    let (hash) = ripemd160(input, byte_size);

    // %{
    //    print("hash: ", [hex(memory[ids.hash + i]) for i in range(0,5)])
    //    print("expected hash: ", [hex(memory[ids.expected_result + i]) for i in range(0,5)])
    // %}
    with_attr error_message("Ripemd160 hash does not match the expected result.") {
        assert hash[0] = expected_result[0];
        assert hash[1] = expected_result[1];
        assert hash[2] = expected_result[2];
        assert hash[3] = expected_result[3];
        assert hash[4] = expected_result[4];
    }

    return ();
}

// TODO: Find or create larger test vectors (to make to sure rmd160 implementation also works for more than 2 chunks)
// Currently this is done by comparing the results to the python implementation.

// Compare the Cairo implementation of RIPEMD160 to out python implementation.
@external
func test_ripemd160_compare_to_python{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();

    local felt_size;
    local byte_size;

    let (input) = alloc();
    %{
        ids.byte_size, ids.felt_size = from_string("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789" * 3, ids.input)
    %}
    let (hash) = ripemd160(input, byte_size);
    // This calls the python implementation (which also includes its own padding implmentation)
    let (expected_result) = _compute_ripemd160_fake(felt_size, input, byte_size);
    // %{
    //    print("hash: ", [hex(memory[ids.hash + i]) for i in range(0,5)])
    //    print("expected hash: ", [hex(memory[ids.expected_result + i]) for i in range(0,5)])
    // %}
    with_attr error_message("Ripemd160 hash does not match the expected result.") {
        assert hash[0] = expected_result[0];
        assert hash[1] = expected_result[1];
        assert hash[2] = expected_result[2];
        assert hash[3] = expected_result[3];
        assert hash[4] = expected_result[4];
    }

    return ();
}

@external
func test_ripemd160_padding_abc{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let n_felts = 1;
    let n_bytes = 3;

    let (input) = alloc();
    assert input[0] = 0x61626300;

    let (word_arr: felt*, n_chunks) = pad_input(input, n_bytes, n_felts);

    assert 0x80636261 = word_arr[0];
    assert 0 = word_arr[1];
    assert 0 = word_arr[2];
    assert 0 = word_arr[3];
    assert 0 = word_arr[4];
    assert 0 = word_arr[5];
    assert 0 = word_arr[6];
    assert 0 = word_arr[7];

    assert 0 = word_arr[8];
    assert 0 = word_arr[9];
    assert 0 = word_arr[10];
    assert 0 = word_arr[11];
    assert 0 = word_arr[12];
    assert 0 = word_arr[13];
    assert 0x18 = word_arr[14];
    assert 0 = word_arr[15];

    assert 1 = n_chunks;

    return ();
}

@external
func test_ripemd160_padding_empty_string{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let n_felts = 0;
    let n_bytes = 0;

    let (input) = alloc();

    let (word_arr: felt*, n_chunks) = pad_input(input, n_bytes, n_felts);

    assert 0x00000080 = word_arr[0];
    assert 0 = word_arr[1];
    assert 0 = word_arr[2];
    assert 0 = word_arr[3];
    assert 0 = word_arr[4];
    assert 0 = word_arr[5];
    assert 0 = word_arr[6];
    assert 0 = word_arr[7];

    assert 0 = word_arr[8];
    assert 0 = word_arr[9];
    assert 0 = word_arr[10];
    assert 0 = word_arr[11];
    assert 0 = word_arr[12];
    assert 0 = word_arr[13];
    assert 0 = word_arr[14];
    assert 0 = word_arr[15];

    assert 1 = n_chunks;

    return ();
}
