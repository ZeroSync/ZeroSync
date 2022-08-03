from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.pow import pow
from starkware.cairo.common.math import assert_le

const FELT_BLOCK_LEN = 20
const N_BYTES_BLOCK = 80
const FELT_HASH_LEN = 8
const N_BYTES_HASH = 32

struct Block:
    member time : felt
    member bits : felt
    member target : felt  # assumption: smaller than 2**246 might overflow otherwise, but wrong targets will be detected in the relay contract
    member fe_target : felt*  # the hex representation of the target to compare it to the block hash -> can be changed to uint256/removed
    member fe_prev_hash : felt*
    member fe_block : felt*  # list of field elements representing the block hex
end

# Returns the block hash-like representation of a target value (stored as felt) in a felt* of len 8
# TODO: This could allow 256 bit targets by seperating the target value into 2 felts and changing the target calculation - aka use Uint256 library, as for everything
func target_to_hash{bitwise_ptr : BitwiseBuiltin*}(target) -> (targetHash : felt*):
    let (target_hash) = alloc()
    # bitwise_and only allows up to 251-bit unsigned integers
    # valid target always smaller than 2**246
    let (fe_target0) = bitwise_and(
        0x0000FFFF00000000000000000000000000000000000000000000000000000000, target)
    assert target_hash[0] = fe_target0 / (2 ** 224)
    let (fe_target1) = bitwise_and(
        target, 0x00000000FFFFFFFF000000000000000000000000000000000000000000000000)
    assert target_hash[1] = fe_target1 / (2 ** 192)
    let (fe_target2) = bitwise_and(
        target, 0x0000000000000000FFFFFFFF0000000000000000000000000000000000000000)
    assert target_hash[2] = fe_target2 / (2 ** 160)
    let (fe_target3) = bitwise_and(
        target, 0x000000000000000000000000FFFFFFFF00000000000000000000000000000000)
    assert target_hash[3] = fe_target3 / (2 ** 128)
    let (fe_target4) = bitwise_and(
        target, 0x00000000000000000000000000000000FFFFFFFF000000000000000000000000)
    assert target_hash[4] = fe_target4 / (2 ** 96)
    let (fe_target5) = bitwise_and(
        target, 0x0000000000000000000000000000000000000000FFFFFFFF0000000000000000)
    assert target_hash[5] = fe_target5 / (2 ** 64)
    let (fe_target6) = bitwise_and(
        target, 0x000000000000000000000000000000000000000000000000FFFFFFFF00000000)
    assert target_hash[6] = fe_target6 / (2 ** 32)
    let (fe_target7) = bitwise_and(
        target, 0x00000000000000000000000000000000000000000000000000000000FFFFFFFF)
    assert target_hash[7] = fe_target7
    return (target_hash)
end

# get block at position index from the program input
# if first_epoch_block is 1 will instead return the first block of the batch's epoch
#
# time and bits are stored in big_endian
func get_block{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        index : felt, first_epoch_block : felt) -> (block : Block):
    alloc_locals
    local block : Block
    let (fe_block_in) = alloc()
    let (tmpfe_prev_hash) = alloc()
    %{
        block = None
        if ids.first_epoch_block == 1:
            block = program_input['firstEpochBlock']
        else:
            block = program_input['Blocks'][ids.index]
        segments.write_arg(ids.fe_block_in, block)
    %}
    assert block.fe_block = fe_block_in
    assert tmpfe_prev_hash[0] = block.fe_block[1]
    assert tmpfe_prev_hash[1] = block.fe_block[2]
    assert tmpfe_prev_hash[2] = block.fe_block[3]
    assert tmpfe_prev_hash[3] = block.fe_block[4]
    assert tmpfe_prev_hash[4] = block.fe_block[5]
    assert tmpfe_prev_hash[5] = block.fe_block[6]
    assert tmpfe_prev_hash[6] = block.fe_block[7]
    assert tmpfe_prev_hash[7] = block.fe_block[8]

    assert block.fe_prev_hash = tmpfe_prev_hash

    let (time_big_endian) = big_endian(block.fe_block[17])
    assert block.time = time_big_endian
    let (bits_big_endian) = big_endian(block.fe_block[18])
    assert block.bits = bits_big_endian

    # calculate target from bits: bits[1..3] * 2 ^ (8 * (bits[0] - 3))
    let (coefficient) = bitwise_and(block.bits, 0x00FFFFFF)
    let (bits_index_tmp) = bitwise_and(block.bits, 0xFF000000)
    let bits_index = bits_index_tmp / 2 ** 24

    # check so inputs can't go over the max target (0x1d00FFFF)
    assert_le(bits_index, 0x1d)
    if bits_index == 0x1d:
        assert_le(coefficient, 0x00FFFF)
        tempvar range_check_ptr = range_check_ptr
    else:
        tempvar range_check_ptr = range_check_ptr
    end
    let (tmp) = pow(2, 8 * (bits_index - 3))
    let target = coefficient * tmp

    let (tmpfe_target) = target_to_hash(target)
    block.fe_target = tmpfe_target
    block.target = target
    return (block)
end

# fills the blocks_ptr with blocks from the program_input and the first block of the epoch for this batch
# blocks_ptr[0..len-1]: corresponding block of the batch
# blocks_ptr[len]: firstEpochBlock
func get_blocks{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(blocks_ptr : Block*, index, len):
    if index == len:
        let (tmp_block : Block) = get_block(0, 1)  # first epoch block saved at blocks[len]
        assert blocks_ptr[len] = tmp_block
        return ()
    end
    let (tmp : Block) = get_block(index, 0)
    assert blocks_ptr[index] = tmp
    get_blocks(blocks_ptr, index + 1, len)
    return ()
end

# Only for 4 Bytes
func big_endian{bitwise_ptr : BitwiseBuiltin*}(a : felt) -> (result : felt):
    let (byte1) = bitwise_and(a, 0x000000FF)
    let (byte2) = bitwise_and(a, 0x0000FF00)
    let (byte3) = bitwise_and(a, 0x00FF0000)
    let (byte4) = bitwise_and(a, 0xFF000000)
    let b = byte1 * 0x1000000 + byte2 * 0x100 + byte3 / 0x100 + byte4 / 0x1000000
    return (result=b)
end

# adds the block to output pointer
func output_block{output_ptr : felt*}(block : Block):
    serialize_word([block.fe_block])
    serialize_word([block.fe_block + 1])
    serialize_word([block.fe_block + 2])
    serialize_word([block.fe_block + 3])
    serialize_word([block.fe_block + 4])
    serialize_word([block.fe_block + 5])
    serialize_word([block.fe_block + 6])
    serialize_word([block.fe_block + 7])
    serialize_word([block.fe_block + 8])
    serialize_word([block.fe_block + 9])
    serialize_word([block.fe_block + 10])
    serialize_word([block.fe_block + 11])
    serialize_word([block.fe_block + 12])
    serialize_word([block.fe_block + 13])
    serialize_word([block.fe_block + 14])
    serialize_word([block.fe_block + 15])
    serialize_word([block.fe_block + 16])
    serialize_word([block.fe_block + 17])
    serialize_word([block.fe_block + 18])
    serialize_word([block.fe_block + 19])
    return ()
end

func output_hash{output_ptr : felt*}(hash : felt*):
    serialize_word(hash[3] + 2 ** 32 * hash[2] + 2 ** 64 * hash[1] + 2 ** 96 * hash[0])
    serialize_word(hash[7] + 2 ** 32 * hash[6] + 2 ** 64 * hash[5] + 2 ** 96 * hash[4])
    return ()
end
