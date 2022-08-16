%lang starknet

from starkware.cairo.common.alloc import alloc

from utils import _compute_sha256

from tests.utils_for_testing import setup_python_defs
from src.utils import assert_hashes_equal
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

@external
func test_sha256_dummy{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    setup_python_defs()
    let (input) = alloc()
    let (expected_output) = alloc()
    local n_bytes : felt
    local input_len : felt

    %{
        # NOTE: For now strings with more than 119 chars will not work.
        # This will change when we switch to another sha256 implementation which allows arbitrary input lengths.
        test_string = "Hello world"
        import hashlib
        ids.n_bytes, ids.input_len = from_string(test_string, ids.input)
        # Compute expected hash from the python hashlib library.
        expected_hash = hashlib.sha256(test_string.encode("ascii")).hexdigest()
        from_hex(expected_hash, ids.expected_output)
    %}

    # TODO: n_bytes or input_len seems to be wrong
    # let (output) = _compute_sha256(input_len, input, n_bytes)
    # assert_hashes_equal(output, expected_output)
    return ()
end
