%builtins output pedersen range_check ecdsa bitwise ec_op

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.serialize import serialize_word

from utils.serialize import init_reader
from crypto.hash_utils import HASH_FELT_SIZE
from block.block_header import ChainState
from block.block import State, validate_and_apply_block, read_block_validation_context
from utxo_set.utreexo import UTREEXO_ROOTS_LEN
from utils.python_utils import setup_python_defs
from crypto.sha256 import finalize_sha256
from chain_proof.recurse import recurse

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
    %{
        ids.block_height = program_input["block_height"] if program_input["block_height"] != -1 else PRIME - 1
        ids.total_work = program_input["total_work"]
        segments.write_arg(ids.best_block_hash, felts_from_hash( program_input["best_block_hash"]) )
        ids.current_target = program_input["current_target"]
        ids.epoch_start_time = program_input["epoch_start_time"]
        segments.write_arg(ids.prev_timestamps, program_input["prev_timestamps"])
        segments.write_arg(ids.prev_utreexo_roots, felts_from_hex_strings( program_input["utreexo_roots"] ) )
        ids.program_hash = int( program_input["program_hash"], 16)
        ids.program_length = program_input["program_length"]
    %}

    let prev_chain_state = ChainState(
        block_height, total_work, best_block_hash, current_target, epoch_start_time, prev_timestamps
    );
    let prev_state = State(prev_chain_state, prev_utreexo_roots);

    // Perform a state transition
    with sha256_ptr {
        let context = read_block_validation_context(prev_state);
        let next_state = validate_and_apply_block{hash_ptr=pedersen_ptr}(context);
    }

    // Validate the previous chain proof
    recurse(next_state.chain_state.block_height, program_hash, program_length, prev_state);

    // Print the next state
    serialize_chain_state(next_state.chain_state);
    serialize_array(next_state.utreexo_roots, UTREEXO_ROOTS_LEN);
    serialize_word(program_hash);
    serialize_word(program_length);

    // finalize sha256_ptr
    finalize_sha256(sha256_ptr_start, sha256_ptr);

    return ();
}

//
// CAUTION!! `main` has to be the last function in this file! Otherwise, `giza prove` breaks.
//
