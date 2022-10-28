%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from python_utils import setup_python_defs
from crypto.hash160.hash160 import hash160

@external
func test_hash160{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let felt_size = 1;

    // Set input to "abc"
    let (input) = alloc();
    assert input[0] = 0x61626300;
    let byte_size = 3;

    // result: 0xbb1be98c142444d7a56aa3981c3942a978e4dc33
    let (hash) = hash160(input, byte_size);

    assert hash[0] = 0xbb1be98c;
    assert hash[1] = 0x142444d7;
    assert hash[2] = 0xa56aa398;
    assert hash[3] = 0x1c3942a9;
    assert hash[4] = 0x78e4dc33;

    return ();
}