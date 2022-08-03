# %builtins output pedersen range_check ecdsa bitwise
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

from io import (
    get_blocks,
    output_block,
    output_hash,
    Block,
    FELT_BLOCK_LEN,
    N_BYTES_BLOCK,
    FELT_HASH_LEN,
    N_BYTES_HASH,
    target_to_hash,
    big_endian,
)
from sha256.sha256 import compute_sha256
from merkle import create_merkle_tree, prepare_merkle_tree, calculate_height

const EXPECTED_MINING_TIME = 1209600  # seconds for mining 2016 blocks

# const twoHoursSecs = 60 * 60 * 2 UNUSED (do not know network time -> check eg btc-blocks 14-15)
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
        ids.blocks_len = len(program_input["Blocks"]) 
        ids.index_in_epoch = program_input["blockNrThisEpoch"]
    %}

    let (height) = calculate_height(blocks_len)

    assert_le(index_in_epoch, 2015)
    assert_le(0, blocks_len)  # just in case

    let (blocks : Block*) = alloc()  # first epoch block is at blocks[len]
    get_blocks(blocks, 0, blocks_len)

    serialize_word(blocks_len)
    output_block(blocks[blocks_len])
    output_block(blocks[0])

    validate_blocks(
        blocks,
        0,
        blocks_len,
        blocks_len,
        blocks[0].fe_prev_hash,
        index_in_epoch,
        0x0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
    )  # just a high number, that is not output negative by cairo

    let (fe_blocks : felt**) = alloc()
    blocks_to_fe(fe_blocks, blocks, 0, blocks_len)
    let (leaves_ptr) = alloc()
    prepare_merkle_tree(leaves_ptr, fe_blocks, blocks_len, 0)
    let (merkle_root) = create_merkle_tree(leaves_ptr, 0, blocks_len, height)
    serialize_word(merkle_root)

    return ()
end

func blocks_to_fe(fe_blocks : felt**, blocks : Block*, index, len):
    if index == len:
        return ()
    end
    assert fe_blocks[index] = blocks[index].fe_block
    blocks_to_fe(fe_blocks, blocks, index + 1, len)
    return ()
end

func find_max_below_x{range_check_ptr}(blocks_ptr : Block*, len, index, curr_max_index, curr_x_index) -> (
    maxIndex : felt
):
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
    # let max1time = blocks_ptr[max1].time
    # %{ print("max1: ", ids.max1time) %}
    let (max2) = find_max_below_x(blocks_ptr, index + 11, index, -1, max1)
    let (max3) = find_max_below_x(blocks_ptr, index + 11, index, -1, max2)
    let (max4) = find_max_below_x(blocks_ptr, index + 11, index, -1, max3)
    let (max5) = find_max_below_x(blocks_ptr, index + 11, index, -1, max4)
    let (time_median) = find_max_below_x(blocks_ptr, index + 11, index, index, max5)  # TODO might be bug - why index instead of -1??
    return (blocks_ptr[time_median].time)
end

func assert_hashes_equal(hash1 : felt*, hash2 : felt*):
    assert hash1[0] = hash2[0]
    assert hash1[1] = hash2[1]
    assert hash1[2] = hash2[2]
    assert hash1[3] = hash2[3]
    assert hash1[4] = hash2[4]
    assert hash1[5] = hash2[5]
    assert hash1[6] = hash2[6]
    assert hash1[7] = hash2[7]
    return ()
end

# idea: has to be correct in the bits representation so set everything up to 2 ** (8 * (index - 3)) 0 and then compare
func assert_targets_almost_equal{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    block_target, calculated_target, bits_index
):
    let (and_tmp) = pow(2, (8 * (bits_index - 3)))
    let (trunc_target) = bitwise_and(calculated_target, 0xFFFFFF * and_tmp)
    assert block_target = trunc_target
    return ()
end

func assert_target_le{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    hash : felt*, target : felt*, step, len
):
    if step == len:
        return ()  # the values are equal
    end
    let (curr_hash_fe) = big_endian(hash[len - step - 1])
    if curr_hash_fe != target[step]:
        assert_le(curr_hash_fe, target[step])
        return ()
    end
    return assert_target_le(hash, target, step + 1, len)
end

# return 1 if Hash1 <= Hash2
# return 0 otherwise
func is_hash_le{range_check_ptr}(hash1 : felt*, hash2 : felt*, step, len) -> (result):
    if step == len:
        return (1)
    end
    if hash1[step] != hash2[step]:
        let (result) = is_le(hash1[step], hash2[step])
        return (result)
    end
    return is_hash_le(hash1, hash2, step + 1, len)
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
    # 0x000000000000000000092F9AE4CAA13600000000000000000000000000000000

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
    let (new_target_arr) = target_to_hash(new_target)
    let (max_target_arr) = target_to_hash(MAX_TARGET)
    let (below_max) = is_hash_le(new_target_arr, max_target_arr, 0, 8)
    if below_max == 0:
        # target calculated is bigger than the max target -> overflow should be prevented, as MAX_TARGET * 4 does not create an overflow
        return_target = MAX_TARGET
    else:
        return_target = new_target
    end
    return (return_target)
end

func compute_double_sha256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    input_len : felt, input : felt*, n_bytes : felt
) -> (sha : felt*):
    alloc_locals
    let (output_first) = compute_sha256(input_len, input=input, n_bytes=n_bytes)
    let (output_second) = compute_sha256(
        input_len=FELT_HASH_LEN, input=output_first, n_bytes=N_BYTES_HASH
    )
    return (output_second)
end

func validate_blocks{output_ptr : felt*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    blocks : Block*,
    index,
    len,
    first_epoch_block_index : felt,
    prev_fe_hash : felt*,
    index_in_curr_epoch,
    target_changed,
):
    alloc_locals
    # one recursion step after the last block got validated
    if index == len:
        # return latest block of a batch
        serialize_word(target_changed)
        output_block(blocks[len - 1])
        output_hash(prev_fe_hash)
        serialize_word(blocks[len - 1].target)
        return ()
    end

    let block : Block = blocks[index]
    let first_epoch_block = blocks[first_epoch_block_index]
    # this blocks hash calculation
    if index == 0:
        tempvar prev_block = blocks[0]
    else:
        tempvar prev_block = blocks[index - 1]
    end
    tempvar prev_block = prev_block

    let (fe_block_hash) = compute_double_sha256(
        input_len=FELT_BLOCK_LEN, input=block.fe_block, n_bytes=N_BYTES_BLOCK
    )

    # check that this blocks previous hash equals previous block's calculated hash
    assert_hashes_equal(hash1=prev_fe_hash, hash2=block.fe_prev_hash)
    # this blocks hash has to be below its target
    assert_target_le(hash=fe_block_hash, target=block.fe_target, step=0, len=FELT_HASH_LEN)

    # validate that time is always bigger than previous 11 block average (obviously is not possible if there are no previous eleven blocks :( )
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
        # we need the correct prevBock if we want to recalculate the target, if the first block of the next epoch is the first block in the batch we are missing the correct previous block
        if index == 0:
            with_attr error_message(
                    "Missing previous block: Batches that introduce an epoch change have to include the last block of the current epoch."):
                assert 0 = 1
            end
        end
        # recalculate target and check if it is roughly the same as the blocks saved target
        let (compare_target) = calculate_next_target(
            first_epoch_block.target, prev_block.time - first_epoch_block.time
        )
        let (bits_index_tmp) = bitwise_and(block.bits, 0xFF000000)
        let bits_index = bits_index_tmp / 2 ** 24
        assert_targets_almost_equal(block.target, compare_target, bits_index)
        validate_blocks(blocks, index + 1, len, index, fe_block_hash, index_in_curr_epoch + 1, index)
        return ()
    else:
        # normal target check
        assert block.target = first_epoch_block.target
    end

    # validate next block using this blocks hash, timestamp and target
    if index_in_curr_epoch == 2015:
        # last block of this epoch
        validate_blocks(blocks, index + 1, len, first_epoch_block_index, fe_block_hash, 0, target_changed)
    else:
        validate_blocks(
            blocks,
            index + 1,
            len,
            first_epoch_block_index,
            fe_block_hash,
            index_in_curr_epoch + 1,
            target_changed,
        )
    end
    return ()
end
