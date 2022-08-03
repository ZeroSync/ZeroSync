%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from tests.utils import fill_input_single_block, fill_input_multiple_blocks

from src.validate import (
    assert_hashes_equal, 
    is_hash_le, 
    assert_target_le, 
    assert_targets_almost_equal, 
    calculate_next_target,
    get_time_median,
    compute_double_sha256
)

from io import (
    Block, 
    get_block, 
    get_blocks
)

@external
func test_assert_hashes_equal_true():
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
    assert_hashes_equal(hash_a, hash_b)
    return ()
end

@external
func test_assert_hashes_equal_false():
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
    assert_hashes_equal(hash_a, hash_b)
    return ()
end


@external
func test_is_hash_le_true{range_check_ptr}():
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

    let (result) = is_hash_le(hash_a, hash_b, 0, 8)
    assert result = 1
    return ()
end

@external
func test_is_hash_le_false{range_check_ptr}():
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

    let (result) = is_hash_le(hash_b, hash_a, 0, 8)
    assert result = 0
    return ()
end


@external
func test_assert_targets_almost_equal{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    let block_target = 0xff000000
    let calculated_target = 0xffaaaaaa
    let bits_index = 6

    assert_targets_almost_equal(block_target, calculated_target, bits_index)

    return ()
end 

@external
func test_assert_target_le{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
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

    assert_target_le(hash, target, step=0, len=8)

    return ()
end 


@external
func test_calculate_next_target{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    let target = 0xffffffffff
    let delta_t = 1209600 # 2016 * 60 * 10 
    
    let (result) = calculate_next_target(target, delta_t)

    assert result = 0xff00000000

    return ()
end


@external
func test_get_time_median{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    
    fill_input_multiple_blocks()
    
    let (blocks : Block*) = alloc()

    get_blocks(blocks, 0, 11)

    let (median_time) = get_time_median(blocks, 0)

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