from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.pow import pow
from starkware.cairo.common.math import assert_le
from starkware.cairo.common.uint256 import Uint256, uint256_mul, uint256_pow2

from utils import bytes_to_uint256

const FELT_BLOCK_LEN = 20
const N_BYTES_BLOCK = 80

struct Block:
    member time : felt
    member bits : felt
    member target : felt  # assumption: smaller than 2**246 might overflow otherwise, but wrong targets will be detected in the relay contract
    member prev_hash : Uint256
    member fe_block : felt*  # list of field elements representing the block hex
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
    let (prev_hash_tmp) = alloc()
    %{
        block = None
        if ids.first_epoch_block == 1:
            block = program_input["firstEpochBlock"]
        else:
            block = program_input["Blocks"][ids.index]
        segments.write_arg(ids.fe_block_in, block)
    %}
    assert block.fe_block = fe_block_in
    assert prev_hash_tmp[0] = block.fe_block[1]
    assert prev_hash_tmp[1] = block.fe_block[2]
    assert prev_hash_tmp[2] = block.fe_block[3]
    assert prev_hash_tmp[3] = block.fe_block[4]
    assert prev_hash_tmp[4] = block.fe_block[5]
    assert prev_hash_tmp[5] = block.fe_block[6]
    assert prev_hash_tmp[6] = block.fe_block[7]
    assert prev_hash_tmp[7] = block.fe_block[8]

    let (prev_hash) = bytes_to_uint256(prev_hash_tmp)
    assert block.prev_hash = prev_hash

    let (time) = big_endian(block.fe_block[17])
    assert block.time = time
    
    let (bits) = big_endian(block.fe_block[18])
    assert block.bits = bits

    let (target) = bits_to_target(bits)
    assert block.target = target

    return (block)
end

# Calculate target from bits
# See https://developer.bitcoin.org/reference/block_chain.html#target-nbits
func bits_to_target{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(bits) -> (target: felt):
    alloc_locals
    let (significand) = bitwise_and(bits, 0x00FFFFFF)
    let (exponent_tmp) = bitwise_and(bits, 0xFF000000) 
    let exponent = exponent_tmp / 2 ** (3 * 8)
    
    # Ensure that input does not exceed the max target (0x1d00FFFF)
    assert_le(exponent, 0x1d)
    if exponent == 0x1d:
        assert_le(significand, 0x00FFFF)
        tempvar range_check_ptr = range_check_ptr
    else:
        tempvar range_check_ptr = range_check_ptr
    end
        
    let (tmp) = pow(256 , exponent - 3)
    let target = significand * tmp
    return (target)
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
