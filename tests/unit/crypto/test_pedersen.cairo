//
// To run only this test suite use:
// protostar test --cairo-path=./src target tests/unit/crypto/*_pedersen*
//
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.hash import HashBuiltin
from starkware.cairo.common.hash_state import hash_finalize, hash_init, hash_update

from utils.python_utils import setup_python_defs
from crypto.hash_utils import assert_hashes_equal

@external
func test_hash_pedersen{range_check_ptr, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    // Set input to "abc"
    let (input) = alloc();
    assert input[0] = 0x61626300;

    // initialize sha256_ptr
    let (hash_state_ptr) = hash_init();
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(
        hash_state_ptr=hash_state_ptr,
        data_ptr=input,
        data_length=1
    );

    // finalize sha256_ptr
    let (out) = hash_finalize{hash_ptr=pedersen_ptr}(hash_state_ptr=hash_state_ptr);

    // Winterfell is testing against the same hash to ensure a ground truth
    assert 0x1719860ce693e55fc2d36b3f089be577689c6a0c23a728a87448843639429b1 = out;

    return ();
}