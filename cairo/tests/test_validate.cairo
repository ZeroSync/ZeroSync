%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from tests.utils import fill_input_single_block, fill_input_multiple_blocks
from starkware.cairo.common.uint256 import Uint256, uint256_eq

from src.validate import (
    assert_hashes_equal, 
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
    let hash_expected = Uint256(0x5bbb85e35552a1e29b9169397b7520d9, 0x577643825c8f1cd34c39fa6a5de3e4e1)
    let (is_correct) = uint256_eq(hash, hash_expected)
    assert is_correct = 1
    return() 
end