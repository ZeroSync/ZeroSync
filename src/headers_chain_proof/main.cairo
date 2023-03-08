%builtins output pedersen range_check ecdsa bitwise ec_op

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.serialize import serialize_word

from serialize.serialize import init_reader
from crypto.sha256d.sha256d import HASH_FELT_SIZE
from block.block_header import ChainState, validate_and_apply_block_header, read_block_header_validation_context, pedersen_hash_block_header
from utils.python_utils import setup_python_defs
from merkle.merkle import create_merkle_tree, calculate_height
from headers_chain_proof.recurse import recurse

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

func fetch_block(block_height) -> (block_data: felt*) {
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
    
    return (block_data,);
}

func _validate_block_headers{hash_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(block_header_pedersen_hashes : felt*, prev_chain_state: ChainState, i, n) -> (next_chain_state: ChainState) {
    alloc_locals;
    if (i == n) {
        return (next_chain_state=prev_chain_state);
    }
    // Get the next block header
    let (context) = read_block_header_validation_context(prev_chain_state);

    // Validate the block header and get the new state
    let (next_chain_state) = validate_and_apply_block_header(context);

    // Hash the block header with pedersen and store it for the merkelization later.
    let (tmp) = pedersen_hash_block_header{hash_ptr=hash_ptr}(context.block_header);
    assert block_header_pedersen_hashes[i] = tmp;

    return _validate_block_headers(block_header_pedersen_hashes, next_chain_state, i+1, n);
}

// Validates the next n block headers and returns a tuple of the final state and an array containing all raw block headers.
// The raw block header can be used to create a merkle tree over all block headers of the batch.
func validate_block_headers{hash_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(start_chain_state: ChainState, n) -> (end_chain_state: ChainState, block_header_pedersen_hashes: felt*) {
    alloc_locals;
    let (block_header_pedersen_hashes: felt*) = alloc();

    let (end_chain_state) = _validate_block_headers(block_header_pedersen_hashes, start_chain_state, 0, n);
    
    return (end_chain_state, block_header_pedersen_hashes);
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

    // Read the batch size from the program input
    local batch_size: felt;
    %{
        ids.batch_size = program_input["batch_size"]
    %}

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
        ids.program_hash = int( program_input["program_hash"], 16)
        //TODO: previous merkle root
    %}

    let start_chain_state = ChainState(
        block_height, total_work, best_block_hash, current_target, epoch_start_time, prev_timestamps
    );

    //Validate all blocks in this batch
    let (final_chain_state, block_header_pedersen_hashes) = validate_block_headers{hash_ptr = pedersen_ptr}(start_chain_state, batch_size);


    // Print the starting state -  TOOD: do we need this if we recurse? No
    serialize_chain_state(start_chain_state);
    // Print the final state
    serialize_chain_state(final_chain_state);
    serialize_word(program_hash);
    
    //TODO: recurse - verifier then checks if the the starting state = end state of previous batch
    // Print the batch size
    serialize_word(batch_size);

    // Calculate and print the Merkle root over all block headers of the batch
    // TODO think about how to accumulate and generate a (merkle) proof such that block X is in merkle_root without knowing the batch size in each step
   // let height = calculate_height(batch_size);
   // let (merkle_root) = create_merkle_tree(block_header_pedersen_hashes, 0, batch_size, height);
   // serialize_word(merkle_root);

    return ();
}


//
// CAUTION!! `main` has to be the last function in this file! Otherwise, `giza prove` breaks.
//
