from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.pow import pow
from starkware.cairo.common.math import assert_le
from starkware.cairo.common.uint256 import Uint256

from utils import array_to_uint256, to_big_endian, copy_hash

const FELT_BLOCK_LEN = 20
const N_BYTES_BLOCK = 80

struct Block:
    member time : felt
    member bits : felt
    member target : felt  # assumption: smaller than 2**246 might overflow otherwise, but wrong targets will be detected in the relay contract
    member prev_hash : Uint256
    member raw_data : felt*  # list of field elements representing the block's bytes
end


# get block at position index from the program input
# if first_block_in_epoch is 1 will instead return the first block of the batch's epoch
#
# time and bits are stored in big endian
func get_block{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        index : felt, first_block_in_epoch : felt) -> (block : Block):
    alloc_locals
    # Read data from program_input
    local block : Block
    let (raw_block_data) = alloc()
    %{
        raw_block = None
        if ids.first_block_in_epoch == 1:
            raw_block = program_input["firstBlockInEpoch"]
        else:
            raw_block = program_input["blocks"][ids.index]
        segments.write_arg(ids.raw_block_data, raw_block)
    %}
    assert block.raw_data = raw_block_data
    
    # Parse previous hash
    let (prev_hash_tmp) = alloc()
    copy_hash(block.raw_data + 1, prev_hash_tmp)

    let (prev_hash) = array_to_uint256(prev_hash_tmp)
    assert block.prev_hash = prev_hash

    # Parse time
    let (time) = to_big_endian(block.raw_data[17])
    assert block.time = time
    
    # Parse bits
    let (bits) = to_big_endian(block.raw_data[18])
    assert block.bits = bits

    # Compute target
    let (target) = bits_to_target(bits)
    assert block.target = target

    return (block)
end

# Calculate target from bits
# See https://developer.bitcoin.org/reference/block_chain.html#target-nbits
func bits_to_target{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(bits) -> (target: felt):
    alloc_locals
    # Ensure that the max target is not exceeded (0x1d00FFFF)
    assert_le(bits, 0x1d00FFFF)

    # Parse the significand and the exponent
    let (significand) = bitwise_and(bits, 0x00FFFFFF)
    let (exponent_tmp) = bitwise_and(bits, 0xFF000000) 
    let exponent = exponent_tmp / 2 ** 24 # Shift three bytes to the right
    
    # Compute the target
    let (tmp) = pow(256 , exponent - 3)
    let target = significand * tmp
    return (target)
end

# fills the blocks_ptr with blocks from the program_input and the first block of the epoch for this batch
# blocks_ptr[0..len-1]: corresponding block of the batch
# blocks_ptr[len]: firstBlockInEpoch
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


# adds the block to output pointer
func output_block{output_ptr : felt*}(block : Block):
    serialize_word([block.raw_data])
    serialize_word([block.raw_data + 1])
    serialize_word([block.raw_data + 2])
    serialize_word([block.raw_data + 3])
    serialize_word([block.raw_data + 4])
    serialize_word([block.raw_data + 5])
    serialize_word([block.raw_data + 6])
    serialize_word([block.raw_data + 7])
    serialize_word([block.raw_data + 8])
    serialize_word([block.raw_data + 9])
    serialize_word([block.raw_data + 10])
    serialize_word([block.raw_data + 11])
    serialize_word([block.raw_data + 12])
    serialize_word([block.raw_data + 13])
    serialize_word([block.raw_data + 14])
    serialize_word([block.raw_data + 15])
    serialize_word([block.raw_data + 16])
    serialize_word([block.raw_data + 17])
    serialize_word([block.raw_data + 18])
    serialize_word([block.raw_data + 19])
    return ()
end

func output_hash{output_ptr : felt*}(hash : Uint256):
    serialize_word(hash.low)
    serialize_word(hash.high)
    return ()
end
