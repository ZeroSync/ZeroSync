%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from tests.utils import fillInputSingleBlock, fillInputMultipleBlocks

from src.validate import (
    assertHashesEqual, 
    isHashLe, 
    assertTargetLe, 
    assertTargetsAlmostEqual, 
    calculateNextTarget,
    getTimeMedian
)


from io import (Block,getBlock)

@external
func test_assertHashesEqual_true():
    let (hash_a) = alloc()
    let (hash_b) = alloc()

    assert hash_a[0] = 0x00
    assert hash_a[1] = 0x01
    assert hash_a[2] = 0x02
    assert hash_a[3] = 0x03
    assert hash_a[4] = 0x04
    assert hash_a[5] = 0x05
    assert hash_a[6] = 0x06
    assert hash_a[7] = 0x07

    assert hash_b[0] = 0x00
    assert hash_b[1] = 0x01
    assert hash_b[2] = 0x02
    assert hash_b[3] = 0x03
    assert hash_b[4] = 0x04
    assert hash_b[5] = 0x05
    assert hash_b[6] = 0x06
    assert hash_b[7] = 0x07
    assertHashesEqual(hash_a, hash_b)
    return ()
end

@external
func test_assertHashesEqual_false():
    let (hash_a) = alloc()
    let (hash_b) = alloc()

    assert hash_a[0] = 0x00
    assert hash_a[1] = 0x01
    assert hash_a[2] = 0x02
    assert hash_a[3] = 0x03
    assert hash_a[4] = 0x04
    assert hash_a[5] = 0x05
    assert hash_a[6] = 0x06
    assert hash_a[7] = 0x07

    assert hash_b[0] = 0x01
    assert hash_b[1] = 0x01
    assert hash_b[2] = 0x02
    assert hash_b[3] = 0x03
    assert hash_b[4] = 0x04
    assert hash_b[5] = 0x05
    assert hash_b[6] = 0x06
    assert hash_b[7] = 0x07
    %{ expect_revert() %}
    assertHashesEqual(hash_a, hash_b)
    return ()
end


@external
func test_isHashLe_true{range_check_ptr}():
    let (hash_a) = alloc()
    let (hash_b) = alloc()

    assert hash_a[0] = 0x00
    assert hash_a[1] = 0x01
    assert hash_a[2] = 0x02
    assert hash_a[3] = 0x03
    assert hash_a[4] = 0x04
    assert hash_a[5] = 0x05
    assert hash_a[6] = 0x06
    assert hash_a[7] = 0x07

    assert hash_b[0] = 0x01
    assert hash_b[1] = 0x01
    assert hash_b[2] = 0x02
    assert hash_b[3] = 0x03
    assert hash_b[4] = 0x04
    assert hash_b[5] = 0x05
    assert hash_b[6] = 0x06
    assert hash_b[7] = 0x07

    let (result) = isHashLe(hash_a, hash_b, 0, 8)
    assert result = 1
    return ()
end

@external
func test_isHashLe_false{range_check_ptr}():
    let (hash_a) = alloc()
    let (hash_b) = alloc()

    assert hash_a[0] = 0x00
    assert hash_a[1] = 0x01
    assert hash_a[2] = 0x02
    assert hash_a[3] = 0x03
    assert hash_a[4] = 0x04
    assert hash_a[5] = 0x05
    assert hash_a[6] = 0x06
    assert hash_a[7] = 0x07

    assert hash_b[0] = 0x01
    assert hash_b[1] = 0x01
    assert hash_b[2] = 0x02
    assert hash_b[3] = 0x03
    assert hash_b[4] = 0x04
    assert hash_b[5] = 0x05
    assert hash_b[6] = 0x06
    assert hash_b[7] = 0x07

    let (result) = isHashLe(hash_b, hash_a, 0, 8)
    assert result = 0
    return ()
end


@external
func test_assertTargetsAlmostEqual{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    let blockTarget = 0xff000000
    let calculatedTarget = 0xffaaaaaa
    let bitsIndex = 6

    assertTargetsAlmostEqual(blockTarget, calculatedTarget, bitsIndex)

    return ()
end 

@external
func test_assertTargetLe{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    let (hash) = alloc()

    assert hash[0] = 0x0000000000000000
    assert hash[1] = 0x0100000000000000
    assert hash[2] = 0x0200000000000000
    assert hash[3] = 0x0300000000000000
    assert hash[4] = 0x0400000000000000
    assert hash[5] = 0x0500000000000000
    assert hash[6] = 0x0600000000000000
    assert hash[7] = 0x0700000000000000

    let (target: felt*) = alloc()
    assert target[0] = 0x07 
    assert target[1] = 0x07 
    assert target[2] = 0x07 
    assert target[3] = 0x07 
    assert target[4] = 0x07 
    assert target[5] = 0x07 
    assert target[6] = 0x07 
    assert target[7] = 0x07 

    assertTargetLe(hash, target, step=0, len=8)

    return ()
end 


@external
func test_calculateNextTarget{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    let target = 0xffffffffff
    let delta_t = 1209600 # 2016 * 60 * 10 
    
    let (result) = calculateNextTarget(target, delta_t)

    assert result = 0xff00000000

    return ()
end



@external
func test_getTimeMedian{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    fillInputMultipleBlocks()
    
    let (blocks : Block*) = alloc()

    let (block0 : Block) = getBlock(0, 0)
    assert blocks[0] = block0
    let (block1 : Block) = getBlock(1, 0)
    assert blocks[1] = block1
    let (block2 : Block) = getBlock(2, 0)
    assert blocks[2] = block2
    let (block3 : Block) = getBlock(3, 0)
    assert blocks[3] = block3
    let (block4 : Block) = getBlock(4, 0)
    assert blocks[4] = block4
    let (block5 : Block) = getBlock(5, 0)
    assert blocks[5] = block5
    let (block6 : Block) = getBlock(6, 0)
    assert blocks[6] = block6
    let (block7 : Block) = getBlock(7, 0)
    assert blocks[7] = block7
    let (block8 : Block) = getBlock(8, 0)
    assert blocks[8] = block8
    let (block9 : Block) = getBlock(9, 0)
    assert blocks[9] = block9
    let (block10 : Block) = getBlock(10, 0)
    assert blocks[10] = block10

    let (result) = getTimeMedian(blocks, 0)

    return ()
end

