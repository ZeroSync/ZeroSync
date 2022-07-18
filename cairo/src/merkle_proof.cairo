%builtins output pedersen range_check ecdsa bitwise

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_le
from starkware.cairo.common.pow import pow

from sha256.sha256 import compute_sha256
from merkle import createMerkleTree, prepareMerkleTree

from io import N_BYTES_BLOCK, N_BYTES_HASH, FELT_HASH_LEN, FELT_BLOCK_LEN, outputHash

func main{
    output_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
    ecdsa_ptr : felt*,
    bitwise_ptr : BitwiseBuiltin*,
}():
    alloc_locals
    local blocksLen : felt
    local intermediaryIndex : felt
    local height : felt
    let (firstPrevHash) = alloc()
    let (blocks : felt**) = alloc()
    %{
        ids.blocksLen = len(program_input["Blocks"])
        ids.intermediaryIndex = program_input["blockToHash"]
        segments.write_arg(ids.blocks, program_input["Blocks"])
        import math
        ids.height = math.ceil(math.log2(ids.blocksLen))
    %}

    if height == 0:
        tempvar range_check_ptr = range_check_ptr
    else:
        let (lenLowerBound) = pow(2, height - 1)
        assert_le(lenLowerBound, blocksLen - 1)  # checks that the calculated height is correct : len > 2**(h-1)
        tempvar range_check_ptr = range_check_ptr
    end
    let (lenUpperBound) = pow(2, height)
    assert_le(blocksLen, lenUpperBound)  # len <= 2 ** h

    let intermediaryHeader = [blocks + intermediaryIndex]
    # output the header -> TODO IMPROVEMENT: This could be compressed to lesser "uint128's" (If you change it here do it in the contract and validate.cairo too <3 )
    serialize_word([intermediaryHeader])
    serialize_word([intermediaryHeader + 1])
    serialize_word([intermediaryHeader + 2])
    serialize_word([intermediaryHeader + 3])
    serialize_word([intermediaryHeader + 4])
    serialize_word([intermediaryHeader + 5])
    serialize_word([intermediaryHeader + 6])
    serialize_word([intermediaryHeader + 7])
    serialize_word([intermediaryHeader + 8])
    serialize_word([intermediaryHeader + 9])
    serialize_word([intermediaryHeader + 10])
    serialize_word([intermediaryHeader + 11])
    serialize_word([intermediaryHeader + 12])
    serialize_word([intermediaryHeader + 13])
    serialize_word([intermediaryHeader + 14])
    serialize_word([intermediaryHeader + 15])
    serialize_word([intermediaryHeader + 16])
    serialize_word([intermediaryHeader + 17])
    serialize_word([intermediaryHeader + 18])
    serialize_word([intermediaryHeader + 19])

    let (hash_first) = compute_sha256(
        input_len=FELT_BLOCK_LEN, input=intermediaryHeader, n_bytes=N_BYTES_BLOCK
    )
    let (hash_second) = compute_sha256(
        input_len=FELT_HASH_LEN, input=hash_first, n_bytes=N_BYTES_HASH
    )
    outputHash(hash_second)

    let (leaves_ptr) = alloc()
    prepareMerkleTree(leaves_ptr, blocks, blocksLen, 0)
    let (merkleRoot) = createMerkleTree(leaves_ptr, 0, blocksLen, height)
    serialize_word(merkleRoot)

    return ()
end
