//
// To run only this test suite use:
// protostar test --cairo-path=./src target src/**/*_ripemd160*
//
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from utils.python_utils import setup_python_defs
from crypto.ripemd160.ripemd160 import ripemd160

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

    with_attr error_message("Ripemd160 hash does not match the expected result.") {
        assert hash[0] = 0x8eb208f7;
        assert hash[1] = 0xe05d987a;
        assert hash[2] = 0x9b044a8e;
        assert hash[3] = 0x98c6b087;
        assert hash[4] = 0xf15a0bfc;
    }

    return ();
}
