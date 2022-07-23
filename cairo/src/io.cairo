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
    member feTarget : felt*  # the hex representation of the target to compare it to the block hash -> can be changed to uint256/removed
    member fePrevHash : felt*
    member feBlock : felt*  # list of field elements representing the block hex
end

# Returns the block hash-like representation of a target value (stored as felt) in a felt* of len 8
# TODO: This could allow 256 bit targets by seperating the target value into 2 felts and changing the target calculation - aka use Uint256 library, as for everything
func targetToHash{bitwise_ptr : BitwiseBuiltin*}(target) -> (targetHash : felt*):
    let (targetHash) = alloc()
    # bitwise_and only allows up to 251-bit unsigned integers
    # valid target always smaller than 2**246
    let (feTarget0) = bitwise_and(
        0x0000FFFF00000000000000000000000000000000000000000000000000000000, target)
    assert targetHash[0] = feTarget0 / (2 ** 224)
    let (feTarget1) = bitwise_and(
        target, 0x00000000FFFFFFFF000000000000000000000000000000000000000000000000)
    assert targetHash[1] = feTarget1 / (2 ** 192)
    let (feTarget2) = bitwise_and(
        target, 0x0000000000000000FFFFFFFF0000000000000000000000000000000000000000)
    assert targetHash[2] = feTarget2 / (2 ** 160)
    let (feTarget3) = bitwise_and(
        target, 0x000000000000000000000000FFFFFFFF00000000000000000000000000000000)
    assert targetHash[3] = feTarget3 / (2 ** 128)
    let (feTarget4) = bitwise_and(
        target, 0x00000000000000000000000000000000FFFFFFFF000000000000000000000000)
    assert targetHash[4] = feTarget4 / (2 ** 96)
    let (feTarget5) = bitwise_and(
        target, 0x0000000000000000000000000000000000000000FFFFFFFF0000000000000000)
    assert targetHash[5] = feTarget5 / (2 ** 64)
    let (feTarget6) = bitwise_and(
        target, 0x000000000000000000000000000000000000000000000000FFFFFFFF00000000)
    assert targetHash[6] = feTarget6 / (2 ** 32)
    let (feTarget7) = bitwise_and(
        target, 0x00000000000000000000000000000000000000000000000000000000FFFFFFFF)
    assert targetHash[7] = feTarget7
    return (targetHash)
end

# get block at position index from the program input
# if firstEpochBlock is 1 will instead return the first block of the batch's epoch
#
# time and bits are stored in bigEndian
func getBlock{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        index : felt, firstEpochBlock : felt) -> (block : Block):
    alloc_locals
    local block : Block
    let (feBlockIn) = alloc()
    let (tmpFePrevHash) = alloc()
    %{
        block = None
        if ids.firstEpochBlock == 1:
            block = program_input['firstEpochBlock']
        else:
            block = program_input['Blocks'][ids.index]
        segments.write_arg(ids.feBlockIn, block)
    %}
    assert block.feBlock = feBlockIn
    assert tmpFePrevHash[0] = block.feBlock[1]
    assert tmpFePrevHash[1] = block.feBlock[2]
    assert tmpFePrevHash[2] = block.feBlock[3]
    assert tmpFePrevHash[3] = block.feBlock[4]
    assert tmpFePrevHash[4] = block.feBlock[5]
    assert tmpFePrevHash[5] = block.feBlock[6]
    assert tmpFePrevHash[6] = block.feBlock[7]
    assert tmpFePrevHash[7] = block.feBlock[8]

    assert block.fePrevHash = tmpFePrevHash

    let (timeBigEndian) = bigEndian(block.feBlock[17])
    assert block.time = timeBigEndian
    let (bitsBigEndian) = bigEndian(block.feBlock[18])
    assert block.bits = bitsBigEndian

    # calculate target from bits: bits[1..3] * 2 ^ (8 * (bits[0] - 3))
    let (coefficient) = bitwise_and(block.bits, 0x00FFFFFF)
    let (BitsIndexTmp) = bitwise_and(block.bits, 0xFF000000)
    let BitsIndex = BitsIndexTmp / 2 ** 24

    # check so inputs can't go over the max target (0x1d00FFFF)
    assert_le(BitsIndex, 0x1d)
    if BitsIndex == 0x1d:
        assert_le(coefficient, 0x00FFFF)
        tempvar range_check_ptr = range_check_ptr
    else:
        tempvar range_check_ptr = range_check_ptr
    end
    let (tmp) = pow(2, 8 * (BitsIndex - 3))
    let target = coefficient * tmp

    let (tmpFeTarget) = targetToHash(target)
    block.feTarget = tmpFeTarget
    block.target = target
    return (block)
end

# fills the blocks_ptr with blocks from the program_input and the first block of the epoch for this batch
# blocks_ptr[0..len-1]: corresponding block of the batch
# blocks_ptr[len]: firstEpochBlock
func getBlocks{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(blocks_ptr : Block*, index, len):
    if index == len:
        let (tmpBlock : Block) = getBlock(0, 1)  # first epoch block saved at blocks[len]
        assert blocks_ptr[len] = tmpBlock
        return ()
    end
    let (tmp : Block) = getBlock(index, 0)
    assert blocks_ptr[index] = tmp
    getBlocks(blocks_ptr, index + 1, len)
    return ()
end

# Only for 4 Bytes
func bigEndian{bitwise_ptr : BitwiseBuiltin*}(a : felt) -> (result : felt):
    let (byteOne) = bitwise_and(a, 0x000000FF)
    let (byteTwo) = bitwise_and(a, 0x0000FF00)
    let (byteThree) = bitwise_and(a, 0x00FF0000)
    let (byteFour) = bitwise_and(a, 0xFF000000)
    let b = byteOne * 0x1000000 + byteTwo * 0x100 + byteThree / 0x100 + byteFour / 0x1000000
    return (result=b)
end

# adds the block to output pointer
func outputBlock{output_ptr : felt*}(block : Block):
    serialize_word([block.feBlock])
    serialize_word([block.feBlock + 1])
    serialize_word([block.feBlock + 2])
    serialize_word([block.feBlock + 3])
    serialize_word([block.feBlock + 4])
    serialize_word([block.feBlock + 5])
    serialize_word([block.feBlock + 6])
    serialize_word([block.feBlock + 7])
    serialize_word([block.feBlock + 8])
    serialize_word([block.feBlock + 9])
    serialize_word([block.feBlock + 10])
    serialize_word([block.feBlock + 11])
    serialize_word([block.feBlock + 12])
    serialize_word([block.feBlock + 13])
    serialize_word([block.feBlock + 14])
    serialize_word([block.feBlock + 15])
    serialize_word([block.feBlock + 16])
    serialize_word([block.feBlock + 17])
    serialize_word([block.feBlock + 18])
    serialize_word([block.feBlock + 19])
    return ()
end

func outputHash{output_ptr : felt*}(hash : felt*):
    serialize_word(hash[3] + 2 ** 32 * hash[2] + 2 ** 64 * hash[1] + 2 ** 96 * hash[0])
    serialize_word(hash[7] + 2 ** 32 * hash[6] + 2 ** 64 * hash[5] + 2 ** 96 * hash[4])
    return ()
end
