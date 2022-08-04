%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_eq
from tests.dummy_data import fill_input_multiple_blocks

from src.validate import (
    assert_hashes_equal, 
    assert_targets_almost_equal, 
    calculate_next_target,
    get_time_median
)

from io import (
    Block, 
    get_block, 
    get_blocks
)


@external
func test_assert_hashes_equal_true{range_check_ptr}():
    alloc_locals

    local hash_a :Uint256 = Uint256(low=12, high=13)
    local hash_b :Uint256 = Uint256(low=12, high=13)

    assert_hashes_equal(hash_a, hash_b)
    return ()
end

@external
func test_assert_hashes_equal_false{range_check_ptr}():
    alloc_locals
    local hash_a :Uint256 = Uint256(low=12, high=13)
    local hash_b :Uint256 = Uint256(low=10, high=13)

    %{ expect_revert() %}
    assert_hashes_equal(hash_a, hash_b)
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
