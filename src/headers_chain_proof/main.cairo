%builtins output pedersen range_check ecdsa bitwise ec_op

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.serialize import serialize_word

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
from headers_chain_proof.pedersen_merkle_tree import append_merkle_tree_pedersen, verify_merkle_path
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
        import urllib3
        import json
        http = urllib3.PoolManager()

        url = 'https://blockstream.info/api/block-height/' + str(ids.block_height)
        r = http.request('GET', url)
        block_hash = str(r.data, 'utf-8')

        url = f'https://blockstream.info/api/block/{ block_hash }/raw'
        r = http.request('GET', url)

        block_hex = r.data.hex()

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
}(start_chain_state: ChainState, n) -> (
    end_chain_state: ChainState, block_header_pedersen_hashes: felt*
) {
    alloc_locals;
    let (block_header_pedersen_hashes: felt*) = alloc();

    let end_chain_state = _validate_block_headers(
        block_header_pedersen_hashes, start_chain_state, 0, n
    );

    return (end_chain_state, block_header_pedersen_hashes);
}

// TODO move to utils
// Fill array with zeroes
func fill_zeroes(arr, arr_len) {
    if arr_len == 0 {
        return;
    }
    arr[0] = 0;
    fill_zeroes(arr, len - 1);
    return;
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
        http = urllib3.PoolManager()
        url = f'http://localhost:2122/merkle_path/{ids.block_height + 1}'
        r = http.request('GET', url)

        import json
        response = json.loads(r.data)
        segments.write_arg(ids.merkle_path, response['proof'])
        ids.merkle_path_len = len(response['proof'])
    %}

    let start_chain_state = ChainState(
        block_height, total_work, best_block_hash, current_target, epoch_start_time, prev_timestamps
    );

    with sha256_ptr {
        // Validate all blocks in this batch
        let (final_chain_state, block_header_pedersen_hashes) = validate_block_headers{
            hash_ptr=pedersen_ptr
        }(start_chain_state, batch_size);
    }


    //TODO refactor naming 
    local x: felt;
    tempvar new_merkle_root: felt;
    %{ 
        import math
        ids.x = round(math.log(ids.block_height + 1, 2))
    %}
    if pow2(x) == ids.block_height {
        // Skip merkle path verification (we can append to the old merkle root)
        // Create merkle path with only zeroes and then the old merkle root
        fill_zeroes(merkle_path, x);
        assert merkle_path[x] = merkle_root;
    }
    else {
        // TODO need to start verifying the path only after a certain height because the 0 is not appended at leave level
        // TODO need to insert respective amounts of 0's for the merkle path used by the append function -> how?
        // idea: calculate height of prev merkle tree and extend the merkle path (with 0) to it
        verify_merkle_path(0, merkle_path, merkle_path_len, merkle_root);
    }

    // TODO check if block_height is even
    // if so no need to change the block_header_pedersen_hashes
    // otherwise insert the merkle_path[0] at the front of block_header_pedersen_hashes and increase batch_size by 1
    assert new_merkle_root = append_merkle_tree_pedersen(
            block_header_pedersen_hashes, batch_size + 1, merkle_path
            );

    // Print the final state
    serialize_chain_state(final_chain_state);
    serialize_word(new_merkle_root);
    serialize_word(program_hash);

    // finalize sha256_ptr
    finalize_sha256(sha256_ptr_start, sha256_ptr);

    return ();
}

//
// CAUTION!! `main` has to be the last function in this file! Otherwise, `giza prove` breaks.
//
