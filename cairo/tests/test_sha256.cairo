%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from tests.utils_for_testing import setup_python_defs
from hash.sha256.sha256 import _sha256
from hash.sha256d.sha256d import assert_hashes_equal

@external
func test_sha256_dummy{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    setup_python_defs()
    let (input) = alloc()
    let (expected_output) = alloc()
    local n_bytes : felt
    local input_len : felt

    %{
        test_string = "Hello world"
        import hashlib
        ids.n_bytes, ids.input_len = from_string(test_string, ids.input)
        # Compute expected hash from the python hashlib library.
        expected_hash = hashlib.sha256(test_string.encode("ascii")).hexdigest()
        from_hex(expected_hash, ids.expected_output)
    %}

    let (output) = _sha256(input_len, input, n_bytes)
    assert_hashes_equal(output, expected_output)
    return ()
end

@external
func test_sha256_64_bytes{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    setup_python_defs()
    let (input) = alloc()
    let (expected_output) = alloc()
    local n_bytes : felt
    local input_len : felt

    %{
        test_string = "0000111122223333444455556666777788889999aaaabbbbccccddddeeeeffff"
        import hashlib
        ids.n_bytes, ids.input_len = from_string(test_string, ids.input)
        # Compute expected hash from the python hashlib library.
        expected_hash = hashlib.sha256(test_string.encode("ascii")).hexdigest()
        from_hex(expected_hash, ids.expected_output)
    %}

    let (output) = _sha256(input_len, input, n_bytes)
    assert_hashes_equal(output, expected_output)
    return ()
end
