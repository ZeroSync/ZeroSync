%lang starknet

from starkware.cairo.common.cairo_builtins import (BitwiseBuiltin, HashBuiltin)
from starkware.cairo.common.alloc import alloc
from src.merkle import createMerkleTree

@external
func test_createMerkleTree{pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (leaves_ptr : felt*) = alloc()
    assert leaves_ptr[0] = 0x00112233445566778899aabbccddee00112233445566778899aabbccddee00
    assert leaves_ptr[1] = 0x01112233445566778899aabbccddee00112233445566778899aabbccddee00
    assert leaves_ptr[2] = 0x02112233445566778899aabbccddee00112233445566778899aabbccddee00
    assert leaves_ptr[3] = 0x03112233445566778899aabbccddee00112233445566778899aabbccddee00
    assert leaves_ptr[4] = 0x04112233445566778899aabbccddee00112233445566778899aabbccddee00
    assert leaves_ptr[5] = 0x05112233445566778899aabbccddee00112233445566778899aabbccddee00
    assert leaves_ptr[6] = 0x06112233445566778899aabbccddee00112233445566778899aabbccddee00
    assert leaves_ptr[7] = 0x07112233445566778899aabbccddee00112233445566778899aabbccddee00

    let left_index = 0
    let leaves_ptr_len = 8
    let height = 3

    let (merkle_root) = createMerkleTree(leaves_ptr, left_index, leaves_ptr_len, height)
    
    assert merkle_root = 0x15968b1d75b3e322a059fd23bc859c97ec647dc00f858eaf13ea2199abb77aa

    return ()
end