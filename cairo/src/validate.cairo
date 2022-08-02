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
    getBlocks, outputBlock, outputHash, Block, FELT_BLOCK_LEN, N_BYTES_BLOCK, FELT_HASH_LEN,
    N_BYTES_HASH, targetToHash, bigEndian)
from sha256.sha256 import compute_sha256
from merkle import createMerkleTree, prepareMerkleTree, calculateHeight

const EXPECTED_MINING_TIME = 1209600  # seconds for mining 2016 blocks

# const twoHoursSecs = 60 * 60 * 2 UNUSED (do not know network time -> check eg btc-blocks 14-15)
const MAX_TARGET = 0x00000000FFFF0000000000000000000000000000000000000000000000000000

func main{
        output_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, ecdsa_ptr : felt*,
        bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    local blocksLen : felt
    local numberInEpoch : felt
    %{
        ids.blocksLen = len(program_input["Blocks"]) 
        ids.numberInEpoch = program_input["blockNrThisEpoch"]
    %}

    let (height) = calculateHeight(blocksLen)

    assert_le(numberInEpoch, 2015)
    assert_le(0, blocksLen)  # just in case

    let (blocks : Block*) = alloc()  # first epoch block is at blocks[len]
    getBlocks(blocks, 0, blocksLen)

    serialize_word(blocksLen)
    outputBlock(blocks[blocksLen])
    outputBlock(blocks[0])

    validateBlocks(
        blocks,
        0,
        blocksLen,
        blocksLen,
        blocks[0].fePrevHash,
        numberInEpoch,
        0x0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)  # just a high number, that is not output negative by cairo

    let (feBlocks : felt**) = alloc()
    blocksToFe(feBlocks, blocks, 0, blocksLen)
    let (leaves_ptr) = alloc()
    prepareMerkleTree(leaves_ptr, feBlocks, blocksLen, 0)
    let (merkleRoot) = createMerkleTree(leaves_ptr, 0, blocksLen, height)
    serialize_word(merkleRoot)

    return ()
end

func blocksToFe(feBlocks : felt**, blocks : Block*, index, len):
    if index == len:
        return ()
    end
    assert feBlocks[index] = blocks[index].feBlock
    blocksToFe(feBlocks, blocks, index + 1, len)
    return ()
end

func findMaxBelowX{range_check_ptr}(blocks_ptr : Block*, len, index, currMaxIndex, currXIndex) -> (
        maxIndex : felt):
    alloc_locals
    if len == index:
        return (currMaxIndex)
    end
    # don't select same index again
    if index == currXIndex:
        return findMaxBelowX(blocks_ptr, len, index + 1, currMaxIndex, currXIndex)
    end
    if currXIndex == -1:
        # search for normal maximum
        if currMaxIndex == -1:
            return findMaxBelowX(blocks_ptr, len, index + 1, index, currXIndex)
        end
        let (newMax) = is_le(blocks_ptr[currMaxIndex].time, blocks_ptr[index].time)
        if newMax == 1:
            return findMaxBelowX(blocks_ptr, len, index + 1, index, currXIndex)
        end
        return findMaxBelowX(blocks_ptr, len, index + 1, currMaxIndex, currXIndex)
    end

    let (belowX) = is_le(blocks_ptr[index].time, blocks_ptr[currXIndex].time)
    if belowX == 1:
        # this could be the next maximum below or equal to X
        if currMaxIndex == -1:
            return findMaxBelowX(blocks_ptr, len, index + 1, index, currXIndex)
        end
        let (newMax) = is_le(blocks_ptr[currMaxIndex].time, blocks_ptr[index].time)
        if newMax == 1:
            return findMaxBelowX(blocks_ptr, len, index + 1, index, currXIndex)
        end
    end
    return findMaxBelowX(blocks_ptr, len, index + 1, currMaxIndex, currXIndex)
end

func getTimeMedian{range_check_ptr}(blocks_ptr : Block*, index) -> (timeMedian : felt):
    let (max1) = findMaxBelowX(blocks_ptr, index + 11, index, -1, -1)
    # let max1time = blocks_ptr[max1].time
    # %{ print("max1: ", ids.max1time) %}
    let (max2) = findMaxBelowX(blocks_ptr, index + 11, index, -1, max1)
    let (max3) = findMaxBelowX(blocks_ptr, index + 11, index, -1, max2)
    let (max4) = findMaxBelowX(blocks_ptr, index + 11, index, -1, max3)
    let (max5) = findMaxBelowX(blocks_ptr, index + 11, index, -1, max4)
    let (timeMedian) = findMaxBelowX(blocks_ptr, index + 11, index, index, max5)  # TODO might be bug - why index instead of -1??
    return (blocks_ptr[timeMedian].time)
end

func assertHashesEqual(hash1 : felt*, hash2 : felt*):
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
func assertTargetsAlmostEqual{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        blockTarget, calculatedTarget, bitsIndex):
    let (andTmp) = pow(2, (8 * (bitsIndex - 3)))
    let (truncTarget) = bitwise_and(calculatedTarget, 0xFFFFFF * andTmp)
    assert blockTarget = truncTarget
    return ()
end

func assertTargetLe{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        hash : felt*, target : felt*, step, len):
    if step == len:
        return ()  # the values are equal
    end
    let (currHashFe) = bigEndian(hash[len - step - 1])
    if currHashFe != target[step]:
        assert_le(currHashFe, target[step])
        return ()
    end
    return assertTargetLe(hash, target, step + 1, len)
end

# return 1 if Hash1 <= Hash2
# return 0 otherwise
func isHashLe{range_check_ptr}(hash1 : felt*, hash2 : felt*, step, len) -> (isLe):
    if step == len:
        return (1)
    end
    if hash1[step] != hash2[step]:
        let (isLe) = is_le(hash1[step], hash2[step])
        return (isLe)
    end
    return isHashLe(hash1, hash2, step + 1, len)
end

func calculateNextTarget{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        currTarget : felt, delta_t) -> (newTarget : felt):
    # calculate delta_t/(theta * L)
    alloc_locals
    local returnTarget
    local ratio

    let (q, _) = unsigned_div_rem(delta_t * 2 ** 32, EXPECTED_MINING_TIME)

    let (nulledTarget) = bitwise_and(
        currTarget, 0x0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000)
    # 0x000000000000000000092F9AE4CAA13600000000000000000000000000000000

    let reducedTarget = nulledTarget / 2 ** 32
    let (belowMaxRatio) = is_le_felt(q, 4 * 2 ** 32)
    let (aboveMinRatio) = is_le_felt(2 ** 30, q)  # 2 ** 30 = 0.25 * 2** 32

    if belowMaxRatio == 0:
        # q > 4
        ratio = 4 * 2 ** 32
    else:
        if aboveMinRatio == 0:
            ratio = 2 ** 30
        else:
            ratio = q
        end
    end
    let newTarget = reducedTarget * ratio
    let (newTargetArr) = targetToHash(newTarget)
    let (maxTargetArr) = targetToHash(MAX_TARGET)
    let (belowMax) = isHashLe(newTargetArr, maxTargetArr, 0, 8)
    if belowMax == 0:
        # target calculated is bigger than the max target -> overflow should be prevented, as MAX_TARGET * 4 does not create an overflow
        returnTarget = MAX_TARGET
    else:
        returnTarget = newTarget
    end
    return (returnTarget)
end

func compute_double_sha256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        input_len : felt, input : felt*, n_bytes : felt) -> (sha : felt*):
    alloc_locals
    let (output_first) = compute_sha256(
        input_len, input=input, n_bytes=n_bytes)
    let (output_second) = compute_sha256(
        input_len=FELT_HASH_LEN, input=output_first, n_bytes=N_BYTES_HASH)
    return (output_second)
end    

func validateBlocks{output_ptr : felt*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
        blocks : Block*, index, len, firstEpochBlockIndex : felt, prevFeHash : felt*,
        numberInCurrEpoch, targetChanged):
    alloc_locals
    # one recursion step after the last block got validated
    if index == len:
        # return latest block of a batch
        serialize_word(targetChanged)
        outputBlock(blocks[len - 1])
        outputHash(prevFeHash)
        serialize_word(blocks[len - 1].target)
        return ()
    end

    let block : Block = blocks[index]
    let firstEpochBlock = blocks[firstEpochBlockIndex]
    # this blocks hash calculation
    if index == 0:
        tempvar prevBlock = blocks[0]
    else:
        tempvar prevBlock = blocks[index - 1]
    end
    tempvar prevBlock = prevBlock

    let (feBlockHash) = compute_double_sha256(
        input_len=FELT_BLOCK_LEN, input=block.feBlock, n_bytes=N_BYTES_BLOCK)

    # check that this blocks previous hash equals previous block's calculated hash
    assertHashesEqual(hash1=prevFeHash, hash2=block.fePrevHash)
    # this blocks hash has to be below its target
    assertTargetLe(hash=feBlockHash, target=block.feTarget, step=0, len=FELT_HASH_LEN)

    # validate that time is always bigger than previous 11 block average (obviously is not possible if there are no previous eleven blocks :( )
    let (leEleven) = is_le(11, index)
    if leEleven == 1:
        let (prevElevenTime) = getTimeMedian(blocks, index - 11)
        assert_le(prevElevenTime, block.time)
        tempvar range_check_ptr = range_check_ptr
    else:
        tempvar range_check_ptr = range_check_ptr
    end
    tempvar range_check_ptr = range_check_ptr

    # assert_le(block.time, prevBlock.time + twoHoursSecs)  # removed this check, because we cant know the network time

    if numberInCurrEpoch == 0:
        # we need the correct prevBock if we want to recalculate the target, if the first block of the next epoch is the first block in the batch we are missing the correct previous block
        if index == 0:
            assert 0 = 1
        end
        # recalculate target and check if it is roughly the same as the blocks saved target
        let (compareTarget) = calculateNextTarget(
            firstEpochBlock.target, prevBlock.time - firstEpochBlock.time)
        let (bitsIndexTmp) = bitwise_and(block.bits, 0xFF000000)
        let bitsIndex = bitsIndexTmp / 2 ** 24
        assertTargetsAlmostEqual(block.target, compareTarget, bitsIndex)
        validateBlocks(blocks, index + 1, len, index, feBlockHash, numberInCurrEpoch + 1, index)
        tempvar output_ptr = output_ptr
        tempvar bitwise_ptr = bitwise_ptr
        return ()
    else:
        # normal target check
        assert block.target = firstEpochBlock.target
        tempvar output_ptr = output_ptr
        tempvar bitwise_ptr = bitwise_ptr
    end

    # validate next block using this blocks hash, timestamp and target
    if numberInCurrEpoch == 2015:
        # last block of this epoch
        validateBlocks(blocks, index + 1, len, firstEpochBlockIndex, feBlockHash, 0, targetChanged)
    else:
        validateBlocks(
            blocks,
            index + 1,
            len,
            firstEpochBlockIndex,
            feBlockHash,
            numberInCurrEpoch + 1,
            targetChanged)
    end
    return ()
end
