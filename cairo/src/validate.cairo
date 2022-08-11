%builtins pedersen range_check ecdsa bitwise

# some builtins may not be used but are required for the cairo-run layout
# for a full node implementation we will need them all anyways

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_le
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.math_cmp import is_le, is_le_felt
from starkware.cairo.common.pow import pow
from io import FELT_BLOCK_LEN, N_BYTES_BLOCK, Block, get_blocks, output_block, output_hash

from utils import compute_double_sha256, to_uint256

from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_le

const EXPECTED_MINING_TIME = 1209600  # seconds for mining 2016 blocks

# const TWO_HOURS_SECS = 60 * 60 * 2 UNUSED (do not know network time -> check eg btc-blocks 14-15)
const MAX_TARGET = 0x00000000FFFF0000000000000000000000000000000000000000000000000000

func main{
    output_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
    ecdsa_ptr : felt*,
    bitwise_ptr : BitwiseBuiltin*,
}():
    alloc_locals
    local blocks_len : felt
    local index_in_epoch : felt
    %{
        ids.blocks_len = len(program_input["blocks"]) 
        ids.index_in_epoch = program_input["blockIndexInEpoch"]
    %}

    assert_le(index_in_epoch, 2015)
    assert_le(0, blocks_len)  # Do not allow 0 blocks as input.

    let (blocks : Block*) = alloc()  # First epoch block is at blocks[len].
    get_blocks(blocks, 0, blocks_len)

    serialize_word(blocks_len)
    output_block(blocks[blocks_len])
    output_block(blocks[0])

    validate_blocks(
        blocks,
        0,
        blocks_len,
        blocks_len,
        blocks[0].prev_hash,
        index_in_epoch,
        0x0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
    )  # just a high number, that is not output negative by cairo TODO change to -1 when we start verifying proofs

    return ()
end

func blocks_to_fe(raw_datas : felt**, blocks : Block*, index, len):
    if index == len:
        return ()
    end
    assert raw_datas[index] = blocks[index].raw_data
    blocks_to_fe(raw_datas, blocks, index + 1, len)
    return ()
end

func find_max_below_x{range_check_ptr}(
    blocks_ptr : Block*, len, index, curr_max_index, curr_x_index
) -> (maxIndex : felt):
    alloc_locals
    if len == index:
        return (curr_max_index)
    end
    # don't select same index again
    if index == curr_x_index:
        return find_max_below_x(blocks_ptr, len, index + 1, curr_max_index, curr_x_index)
    end
    if curr_x_index == -1:
        # search for normal maximum
        if curr_max_index == -1:
            return find_max_below_x(blocks_ptr, len, index + 1, index, curr_x_index)
        end
        let (new_max) = is_le(blocks_ptr[curr_max_index].time, blocks_ptr[index].time)
        if new_max == 1:
            return find_max_below_x(blocks_ptr, len, index + 1, index, curr_x_index)
        end
        return find_max_below_x(blocks_ptr, len, index + 1, curr_max_index, curr_x_index)
    end

    let (below_x) = is_le(blocks_ptr[index].time, blocks_ptr[curr_x_index].time)
    if below_x == 1:
        # this could be the next maximum below or equal to X
        if curr_max_index == -1:
            return find_max_below_x(blocks_ptr, len, index + 1, index, curr_x_index)
        end
        let (new_max) = is_le(blocks_ptr[curr_max_index].time, blocks_ptr[index].time)
        if new_max == 1:
            return find_max_below_x(blocks_ptr, len, index + 1, index, curr_x_index)
        end
    end
    return find_max_below_x(blocks_ptr, len, index + 1, curr_max_index, curr_x_index)
end

func get_time_median{range_check_ptr}(blocks_ptr : Block*, index) -> (time_median : felt):
    let (max1) = find_max_below_x(blocks_ptr, index + 11, index, -1, -1)
    let (max2) = find_max_below_x(blocks_ptr, index + 11, index, -1, max1)
    let (max3) = find_max_below_x(blocks_ptr, index + 11, index, -1, max2)
    let (max4) = find_max_below_x(blocks_ptr, index + 11, index, -1, max3)
    let (max5) = find_max_below_x(blocks_ptr, index + 11, index, -1, max4)
    let (time_median) = find_max_below_x(blocks_ptr, index + 11, index, -1, max5)
    return (blocks_ptr[time_median].time)
end

func assert_hashes_equal{range_check_ptr}(hash1 : Uint256, hash2 : Uint256):
    let (result) = uint256_eq(hash1, hash2)
    assert result = 1
    return ()
end

# idea: has to be correct in the bits representation
# so set everything up to 2 ** (8 * (index - 3)) 0 and then compare
func assert_targets_almost_equal{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    block_target, calculated_target, exponent
):
    let (and_tmp) = pow(256, exponent - 3)
    let (truncated_target) = bitwise_and(calculated_target, 0xFFFFFF * and_tmp)
    assert block_target = truncated_target
    return ()
end

func calculate_next_target{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    curr_target : felt, delta_t
) -> (new_target : felt):
    # calculate delta_t/(theta * L)
    alloc_locals
    local return_target
    local ratio

    let (q, _) = unsigned_div_rem(delta_t * 2 ** 32, EXPECTED_MINING_TIME)

    let (nulled_target) = bitwise_and(
        curr_target, 0x0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000
    )

    let reduced_target = nulled_target / 2 ** 32
    let (below_max_ratio) = is_le_felt(q, 4 * 2 ** 32)
    let (above_min_ratio) = is_le_felt(2 ** 30, q)  # 2 ** 30 = 0.25 * 2** 32

    if below_max_ratio == 0:
        # q > 4
        ratio = 4 * 2 ** 32
    else:
        if above_min_ratio == 0:
            ratio = 2 ** 30
        else:
            ratio = q
        end
    end
    let new_target = reduced_target * ratio
    let (below_max) = is_le_felt(new_target, MAX_TARGET)
    if below_max == 0:
        # The new_target is bigger than MAX_TARGET.
        # Because MAX_TARGET * 4 still fits in a felt, overflows are prevented.
        return_target = MAX_TARGET
    else:
        return_target = new_target
    end
    return (return_target)
end

func validate_blocks{output_ptr : felt*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    blocks : Block*,
    index,
    len,
    first_block_in_epoch_index : felt,
    prev_hash : Uint256,
    index_in_curr_epoch,
    target_changed,
):
    alloc_locals
    # One recursion step after the last block got validated
    if index == len:
        # Return latest block of a batch
        serialize_word(target_changed)
        output_block(blocks[len - 1])
        output_hash(prev_hash)
        serialize_word(blocks[len - 1].target)
        return ()
    end

    let block : Block = blocks[index]
    let first_block_in_epoch = blocks[first_block_in_epoch_index]
    # This blocks hash calculation
    if index == 0:
        tempvar prev_block = blocks[0]
    else:
        tempvar prev_block = blocks[index - 1]
    end
    tempvar prev_block = prev_block

    let (block_hash) = compute_double_sha256(FELT_BLOCK_LEN, block.raw_data, N_BYTES_BLOCK)

    # Check that this block's previous hash equals previous block's calculated hash
    assert_hashes_equal(prev_hash, block.prev_hash)

    # Ensure this block's proof-of-work is valid
    let (target) = to_uint256(block.target)
    let (is_block_hash_le) = uint256_le(block_hash, target)
    assert is_block_hash_le = 1

    # Validate that this block's time is bigger than the median of the previous 11 blocks.
    # (Obviously, this is not possible if there are no previous eleven blocks.)
    let (le_eleven) = is_le(11, index)
    if le_eleven == 1:
        let (prev_eleven_time) = get_time_median(blocks, index - 11)
        assert_le(prev_eleven_time, block.time)
        tempvar range_check_ptr = range_check_ptr
    else:
        tempvar range_check_ptr = range_check_ptr
    end
    tempvar range_check_ptr = range_check_ptr

    # assert_le(block.time, prev_block.time + twoHoursSecs)  # removed this check, because we cant know the network time

    if index_in_curr_epoch == 0:
        # We need the correct prev_block if we want to recalculate the target.
        # If the first block of the next epoch is the first block in the batch
        # we are missing the correct previous block.
        if index == 0:
            with_attr error_message(
                    "Missing previous block: Batches that introduce an epoch change have to include the last block of the current epoch."):
                assert 0 = 1
            end
        end
        # Recalculate the target and check if it is roughly the same as the block's saved target
        let (compare_target) = calculate_next_target(
            first_block_in_epoch.target, prev_block.time - first_block_in_epoch.time
        )
        let (exponent_tmp) = bitwise_and(block.bits, 0xFF000000)
        let exponent = exponent_tmp / 2 ** 24
        assert_targets_almost_equal(block.target, compare_target, exponent)
        validate_blocks(blocks, index + 1, len, index, block_hash, index_in_curr_epoch + 1, index)
        return ()
    else:
        # Normal target check
        assert block.target = first_block_in_epoch.target
    end

    # Validate next block using this block's hash, timestamp and target
    if index_in_curr_epoch == 2015:
        # This is the last block of the current epoch
        validate_blocks(
            blocks, index + 1, len, first_block_in_epoch_index, block_hash, 0, target_changed
        )
    else:
        validate_blocks(
            blocks,
            index + 1,
            len,
            first_block_in_epoch_index,
            block_hash,
            index_in_curr_epoch + 1,
            target_changed,
        )
    end
    return ()
end
