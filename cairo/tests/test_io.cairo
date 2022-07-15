%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin


from tests.utils import (
    fillInputSingleBlock
)
from src.io import (
    Block,
    targetToHash,
    getBlock,
    bigEndian
)

#TODO obsolete once I change the target and sha hash from felt* to uint256
@external
func test_targetToHash{bitwise_ptr : BitwiseBuiltin*}():
    let target = 2 ** 224 + 2** 192 + 2 ** 160 + 2 ** 128 + 2 ** 96 + 2 ** 64 + 2 ** 32 + 1
    let (hash) = targetToHash(target)
    assert hash[0] = 0x01
    assert hash[1] = 0x01
    assert hash[2] = 0x01
    assert hash[3] = 0x01
    assert hash[4] = 0x01
    assert hash[5] = 0x01
    assert hash[6] = 0x01
    assert hash[7] = 0x01
    return ()
end

@external
func test_getBlock{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}():
    fillInputSingleBlock()
    let (block : Block) = getBlock(0,0)
    assert block.time = 1296688928
    assert block.bits = 0x1D00FFFF
    assert block.target = 0xffff * 2 ** 208
    #TODO check prevHash and when included in the Block struct the merkle Root
    return()
end

@external
func test_getFirstEpochBlock():
    return()
end
