%builtins output pedersen range_check ecdsa bitwise ec_op

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.math import unsigned_div_rem

from crypto.hash_utils import HASH_FELT_SIZE
from block.block_header import (
    ChainState,
    validate_and_apply_block_header,
    read_block_header_validation_context,
    pedersen_hash_block_header,
)
from utils.python_utils import setup_python_defs
from crypto.sha256 import finalize_sha256
from headers_chain_proof.recurse import recurse
from headers_chain_proof.pedersen_merkle_tree import (
    append_merkle_tree_pedersen,
    verify_merkle_path_zero,
    calculate_height,
    calculate_merkle_path_len,
)
from utils.pow2 import pow2

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

func fetch_block(block_height) -> felt* {
    let (block_data) = alloc();

    %{
        block_hex = BTC_API.get_block_header_raw(ids.block_height)
        from_hex(block_hex, ids.block_data)
    %}

    return block_data;
}

func _validate_block_headers{
    hash_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*, sha256_ptr: felt*
}(block_header_pedersen_hashes: felt*, prev_chain_state: ChainState, i, n) -> ChainState {
    alloc_locals;
    if (i == n) {
        return prev_chain_state;
    }

    with sha256_ptr {
        // Get the next block header
        let context = read_block_header_validation_context(prev_chain_state);

        // Validate the block header and get the new state
        let next_chain_state = validate_and_apply_block_header(context);
    }

    // Hash the block header with pedersen and store it for the merkelization later.
    let tmp = pedersen_hash_block_header{hash_ptr=hash_ptr}(context.block_header);
    assert block_header_pedersen_hashes[i] = tmp;

    return _validate_block_headers(block_header_pedersen_hashes, next_chain_state, i + 1, n);
}

// Validates the next n block headers and returns a tuple of the final state and an array containing all block header pedersen hashes.
// The block header pedersen hashes can be used to create a merkle tree over all block headers of the batch.
func validate_block_headers{
    hash_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*, sha256_ptr: felt*
}(start_chain_state: ChainState, n, block_header_pedersen_hashes: felt*) -> ChainState {
    let end_chain_state = _validate_block_headers(
        block_header_pedersen_hashes, start_chain_state, 0, n
    );

    return end_chain_state;
}

// TODO move to utils
// Fill array with zeroes
func fill_zeroes(arr: felt*, arr_len) {
    if (arr_len == 0) {
        return ();
    }
    assert arr[0] = 0;
    fill_zeroes(arr + 1, arr_len - 1);
    return ();
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
    let (prev_utreexo_roots) = alloc();
    local program_hash: felt;
    local program_length: felt;
    local batch_size: felt;
    local merkle_root: felt;
    let (merkle_path) = alloc();
    local merkle_path_len: felt;
    %{
        ids.block_height = program_input["block_height"] if program_input["block_height"] != -1 else PRIME - 1
        ids.total_work = program_input["total_work"]
        segments.write_arg(ids.best_block_hash, felts_from_hash( program_input["best_block_hash"]) )
        ids.current_target = program_input["current_target"]
        ids.epoch_start_time = program_input["epoch_start_time"]
        segments.write_arg(ids.prev_timestamps, program_input["prev_timestamps"])
        ids.program_hash = int( program_input["program_hash"], 16)
        ids.batch_size = program_input["batch_size"]
        ids.merkle_root = int(program_input["merkle_root"], 16)

        # Fetch the merkle path from the bridge node
        if ids.block_height != PRIME - 1:
            import urllib3
            http = urllib3.PoolManager()
            url = f'http://localhost:2122/merkle_path/{ids.block_height + 1}'
            r = http.request('GET', url)
            import json
            response = json.loads(r.data)
            segments.write_arg(ids.merkle_path, response['proof'])
            ids.merkle_path_len = len(response['proof'])
        else:
            ids.merkle_path_len = 0
    %}

    // TODO refactor the general flow of exeuction and spread over different functions
    //      look into revoked reference and how to avoid using so many tempvars
    if (block_height == -1) {
        // Block Header Validation
        let start_chain_state = ChainState(
            block_height,
            total_work,
            best_block_hash,
            current_target,
            epoch_start_time,
            prev_timestamps,
        );

        let (local block_header_pedersen_hashes: felt*) = alloc();
        with sha256_ptr {
            // Validate all blocks in this batch
            let final_chain_state = validate_block_headers{hash_ptr=pedersen_ptr}(
                start_chain_state, batch_size, block_header_pedersen_hashes
            );
        }
        let (useless_pointer) = alloc();
        let new_merkle_root = append_merkle_tree_pedersen{hash_ptr=pedersen_ptr}(
            block_header_pedersen_hashes, batch_size, useless_pointer, 0
        );

        // Print the final state
        serialize_chain_state(final_chain_state);
        serialize_word(new_merkle_root);
        serialize_word(program_hash);

        // finalize sha256_ptr
        finalize_sha256(sha256_ptr_start, sha256_ptr);
        tempvar output_ptr = output_ptr;
        tempvar pedersen_ptr = pedersen_ptr;
        tempvar range_check_ptr = range_check_ptr;
    } else {
        // Merkle Path verification
        let (local extended_merkle_path: felt*) = alloc();
        tempvar extended_merkle_path_len = 0;
        let old_height = calculate_height(block_height + 1);
        if (pow2(old_height) == block_height + 1) {
            // The old Merkle tree was complete
            // Skip merkle path verification (we can append to the old merkle root)
            // Create merkle path with only zeroes and the old Merkle root
            fill_zeroes(extended_merkle_path, old_height);
            assert extended_merkle_path[old_height] = merkle_root;
            tempvar extended_merkle_path_len = old_height + 1;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        } else {
            // Old Merkle tree was not complete and hashed together with 0 elements
            verify_merkle_path_zero{hash_ptr=pedersen_ptr}(
                merkle_path, merkle_path_len, merkle_root, block_height + 1
            );
            fill_zeroes(extended_merkle_path, old_height - merkle_path_len);
            memcpy(
                extended_merkle_path + old_height - merkle_path_len, merkle_path, merkle_path_len
            );
            tempvar extended_merkle_path_len = old_height;
            tempvar pedersen_ptr = pedersen_ptr;
            tempvar range_check_ptr = range_check_ptr;
        }
        tempvar extended_merkle_path = extended_merkle_path;
        tempvar extended_merkle_path_len = extended_merkle_path_len;
        tempvar pedersen_ptr = pedersen_ptr;
        // Check if block_height is even
        // if so no need to change the block_header_pedersen_hashes, but skip first entry in extended_merkle_path
        // otherwise insert merkle_path[0] at the front of block_header_pedersen_hashes and increase batch_size by 1
        let (local block_header_pedersen_hashes: felt*) = alloc();
        let (_, is_odd) = unsigned_div_rem(block_height + 1, 2);
        if (is_odd == 1) {
            assert block_header_pedersen_hashes[0] = extended_merkle_path[0];
        }
        // Block Header Validation
        let start_chain_state = ChainState(
            block_height,
            total_work,
            best_block_hash,
            current_target,
            epoch_start_time,
            prev_timestamps,
        );

        with sha256_ptr {
            // Validate all blocks in this batch
            let final_chain_state = validate_block_headers{hash_ptr=pedersen_ptr}(
                start_chain_state, batch_size, block_header_pedersen_hashes + is_odd
            );
        }

        let new_merkle_root = append_merkle_tree_pedersen{hash_ptr=pedersen_ptr}(
            block_header_pedersen_hashes,
            batch_size + is_odd,
            extended_merkle_path + 1,
            extended_merkle_path_len - 1,
        );
        // Print the final state
        serialize_chain_state(final_chain_state);
        serialize_word(new_merkle_root);
        serialize_word(program_hash);

        // finalize sha256_ptr
        finalize_sha256(sha256_ptr_start, sha256_ptr);

        recurse(block_height, program_hash, start_chain_state, merkle_root);
        tempvar output_ptr = output_ptr;
        tempvar pedersen_ptr = pedersen_ptr;
        tempvar range_check_ptr = range_check_ptr;
    }

    return ();
}

//
// CAUTION!! `main` has to be the last function in this file! Otherwise, `giza prove` breaks.
//
