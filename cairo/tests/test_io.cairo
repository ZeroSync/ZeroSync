%lang starknet

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from tests.dummy_data import fill_input_single_block
from src.io import Block, get_block, bits_to_target
from starkware.cairo.common.uint256 import Uint256, uint256_eq


@external
func test_get_block{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}():
    alloc_locals
    fill_input_single_block()
    let (block : Block) = get_block(0, 0)
    assert block.time = 1296688928
    assert block.bits = 0x1D00FFFF

    assert block.target = 0xffff0000000000000000000000000000000000000000000000000000
    
    # TODO check prevHash and when included in the Block struct the merkle Root
    return ()
end

@external
func test_bits_to_target{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}():
    alloc_locals
    let bits = 0x181bc330
    let (target) = bits_to_target(bits)
    assert target = 0x1bc330000000000000000000000000000000000000000000
    return ()
end
