%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256

from src.utils import compute_double_sha256, to_uint256

@external
func test_compute_double_sha256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    let input_len = 3

    # Set input to "Hello World"
    let (input:felt*) = alloc()
    assert input[0] = 1214606444
    assert input[1] = 1864398703
    assert input[2] = 1919706112
    let n_bytes = 12
    
    let (hash) = compute_double_sha256(input_len, input, n_bytes)
    assert hash.low = 0x5bbb85e35552a1e29b9169397b7520d9
    assert hash.high = 0x577643825c8f1cd34c39fa6a5de3e4e1
    return () 
end

@external
func test_compute_double_sha256_2{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    let input_len = 1

    # Set input to three zero bytes
    let (input:felt*) = alloc()
    assert input[0] = 0x00000000
    let n_bytes = 4
    
    let (hash) = compute_double_sha256(input_len, input, n_bytes)
    # 8cb9012517c817fead650287d61bdd9c68803b6bf9c64133dcab3e65b5a50cb9
    assert hash.low =  0x68803b6bf9c64133dcab3e65b5a50cb9
    assert hash.high = 0x8cb9012517c817fead650287d61bdd9c
    return () 
end

@external
func test_to_uint256{range_check_ptr}():
    let input = 2 ** 251 - 1
    let (output) = to_uint256(input)
    assert output.low = 0xffffffffffffffffffffffffffffffff
    assert output.high = 0x7ffffffffffffffffffffffffffffff
    return ()
end