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
    getTimeMedian,
    compute_double_sha256
)

from io import (
    Block, 
    getBlock, 
    getBlocks
)

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

    getBlocks(blocks, 0, 11)

    let (median_time) = getTimeMedian(blocks, 0)

    assert median_time = 1231471789

    return ()
end


@external
func test_compute_double_sha256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    let input_len = 3

    # Set input to "Hello World"
    let (input:felt*) = alloc()
    assert input[0] = 1214606444
    assert input[1] = 1864398703
    assert input[2] = 1919706112
    let n_bytes = 12
    
    let (hash) = compute_double_sha256(input_len, input, n_bytes)
    
    # Compare result
    assert hash[0] = 2071273689
    assert hash[1] = 2609998137
    assert hash[2] = 1431478754
    assert hash[3] = 1539016163
    assert hash[4] = 1575216353
    assert hash[5] = 1278868074
    assert hash[6] = 1552882899
    assert hash[7] = 1467368322

    return() 
end