%builtins output pedersen range_check ecdsa bitwise ec_op

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.serialize import serialize_word

from crypto.hash_utils import HASH_FELT_SIZE
from block.block_header import (
    ChainState,
    validate_and_apply_block_header,
    read_block_header_validation_context,
)
from utils.python_utils import setup_python_defs
from crypto.sha256 import finalize_sha256
from headers_chain_proof.recurse import recurse
from headers_chain_proof.merkle_mountain_range import (mmr_add_leaves, MMR_ROOTS_LEN)

func serialize_chain_state{output_ptr: felt*}(chain_state: ChainState) {
    serialize_word(chain_state.block_height);
    serialize_array(chain_state.best_block_hash, HASH_FELT_SIZE);
    serialize_word(chain_state.total_work);
    serialize_word(chain_state.current_target);
    serialize_array(chain_state.prev_timestamps, 11);
    serialize_word(chain_state.epoch_start_time);
    return ();
}

func serialize_array{output_ptr: felt*}(array: felt*, array_len) {
    if (array_len == 0) {
        return ();
    }
    serialize_word([array]);
    serialize_array(array + 1, array_len - 1);
    return ();
}

// Validates the next n block headers and returns a tuple of the final state and an array containing all block header pedersen hashes.
// The block header pedersen hashes can be used to create a merkle tree over all block headers of the batch.
func validate_block_headers{
    hash_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*, sha256_ptr: felt*
}(prev_chain_state: ChainState, n, block_hashes: felt*) -> ChainState {
    alloc_locals;
    if (n == 0) {
        return prev_chain_state;
    }

    with sha256_ptr {
        // Get the next block header
        let context = read_block_header_validation_context(prev_chain_state);

        // Validate the block header and get the new state
        let next_chain_state = validate_and_apply_block_header(context);
    }


    /// Convert the block hash into a felt

    // Validate that the hash's most significant uint32 chunk is zero
    // This guarantees that the hash fits into a felt.
    with_attr error_message("Hash's most significant uint32 chunk ({context.block_hash[7]}) is not zero.") {
        assert 0 = context.block_hash[7];
    }
    // Sum up the other 7 uint32 chunks of the hash into 1 felt
    const BASE = 2 ** 32;
    let block_hash = context.block_hash[0] * BASE ** 0 +
                     context.block_hash[1] * BASE ** 1 +
                     context.block_hash[2] * BASE ** 2 +
                     context.block_hash[3] * BASE ** 3 +
                     context.block_hash[4] * BASE ** 4 +
                     context.block_hash[5] * BASE ** 5 +
                     context.block_hash[6] * BASE ** 6;
    // Add that felt to the list of block hashes
    assert [block_hashes] = block_hash;

    return validate_block_headers(next_chain_state, n - 1, block_hashes + 1);
}


func main{
    output_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
    ecdsa_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    ec_op_ptr,
}() {
    alloc_locals;
    setup_python_defs();

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;

    // Read the previous state from the program input
    local block_height: felt;
    local total_work: felt;
    let (best_block_hash) = alloc();
    local current_target: felt;
    local epoch_start_time: felt;
    let (prev_timestamps) = alloc();
    let (mmr_roots) = alloc();
    local program_hash: felt;
    local batch_size: felt;
    
    %{
        ids.block_height = program_input["block_height"] if program_input["block_height"] != -1 else PRIME - 1
        ids.total_work = program_input["total_work"]
        segments.write_arg(ids.best_block_hash, felts_from_hash( program_input["best_block_hash"]) )
        ids.current_target = program_input["current_target"]
        ids.epoch_start_time = program_input["epoch_start_time"]
        segments.write_arg(ids.prev_timestamps, program_input["prev_timestamps"])
        ids.program_hash = int( program_input["program_hash"], 16)
        ids.batch_size = program_input["batch_size"]
        segments.write_arg(ids.mmr_roots, felts_from_hex_strings( program_input["mmr_roots"] ) )
    %}


    // The ChainState of the previous state
    let prev_chain_state = ChainState(
        block_height,
        total_work,
        best_block_hash,
        current_target,
        epoch_start_time,
        prev_timestamps,
    );

    // Verify the previous state proof
    recurse(program_hash, prev_chain_state, mmr_roots);

    // Validate all blocks in this batch and update the state
    let (block_hashes) = alloc();
    with sha256_ptr {
        let next_chain_state = validate_block_headers{hash_ptr=pedersen_ptr}(
            prev_chain_state, batch_size, block_hashes);
    }
    finalize_sha256(sha256_ptr_start, sha256_ptr);
    mmr_add_leaves{hash_ptr=pedersen_ptr, mmr_roots=mmr_roots}(block_hashes, batch_size);

    // Output the next state
    serialize_chain_state(next_chain_state);
    serialize_array(mmr_roots, MMR_ROOTS_LEN);
    serialize_word(program_hash);
    
    return ();
}

//
// CAUTION!! `main` has to be the last function in this file! Otherwise, `giza prove` breaks.
//
