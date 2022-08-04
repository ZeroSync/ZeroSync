%builtins output pedersen range_check ecdsa bitwise

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin

from sha256.sha256 import compute_sha256
from merkle import create_merkle_tree, prepare_merkle_tree, calculate_height

from io import N_BYTES_BLOCK, N_BYTES_HASH, FELT_HASH_LEN, FELT_BLOCK_LEN, output_hash

from utils import compute_double_sha256

###
#       This Program proofs the inclusion of an intermediary header
#       at position [X] in the given batch. To do so, we calculate the
#       Merkle root over all block headers again. The resulting root
#       will be compared to the original root that was calculated
#       while validating the blocks and is now stored in the contract.
###

func main{
        output_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, ecdsa_ptr : felt*,
        bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    local blocks_len : felt
    local intermediary_index : felt
    let (blocks : felt**) = alloc()
    %{
        ids.blocks_len = len(program_input["blocks"])
        ids.intermediary_index = program_input["blockToHash"]
        segments.write_arg(ids.blocks, program_input["blocks"])
    %}
    let (height) = calculate_height(blocks_len)
    let intermediary_header = [blocks + intermediary_index]

    # output the specified header
    # TODO IMPROVEMENT: This could be compressed to lesser uint128's 
    # (If you change it here do it in the contract and validate.cairo too <3 )
    serialize_word([intermediary_header])
    serialize_word([intermediary_header + 1])
    serialize_word([intermediary_header + 2])
    serialize_word([intermediary_header + 3])
    serialize_word([intermediary_header + 4])
    serialize_word([intermediary_header + 5])
    serialize_word([intermediary_header + 6])
    serialize_word([intermediary_header + 7])
    serialize_word([intermediary_header + 8])
    serialize_word([intermediary_header + 9])
    serialize_word([intermediary_header + 10])
    serialize_word([intermediary_header + 11])
    serialize_word([intermediary_header + 12])
    serialize_word([intermediary_header + 13])
    serialize_word([intermediary_header + 14])
    serialize_word([intermediary_header + 15])
    serialize_word([intermediary_header + 16])
    serialize_word([intermediary_header + 17])
    serialize_word([intermediary_header + 18])
    serialize_word([intermediary_header + 19])

    # calculate the block hash and output it
    let (hash) = compute_double_sha256(FELT_BLOCK_LEN, intermediary_header, N_BYTES_BLOCK)
    
    output_hash(hash)
    # calculate and output the merkle root of the batch
    let (leaves_ptr) = alloc()
    prepare_merkle_tree(leaves_ptr, blocks, blocks_len, 0)
    let (merkle_root) = create_merkle_tree(leaves_ptr, 0, blocks_len, height)
    serialize_word(merkle_root)

    return ()
end
