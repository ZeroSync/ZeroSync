%builtins output range_check bitwise

# Import the serialize_word() function.
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.serialize import serialize_word

from block_header import ChainState
from crypto.sha256d.sha256d import HASH_FELT_SIZE
from buffer import init_reader
from block import State, validate_and_apply_block, read_block_validation_context

func main{output_ptr : felt*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}():
    alloc_locals

    # Read a block from the program input
    let (raw_block) = alloc()
    %{
        segments.write_arg(ids.raw_block, program_input["raw_block"])
    %}

    
    # Read the previous state from the program input
    local block_height: felt
    local total_work: felt
    let (best_hash) = alloc()
    local difficulty: felt
    local epoch_start_time: felt
    let (prev_timestamps) = alloc()
    let (prev_state_root) = alloc()
    %{
        prev_state = program_input["prev_state"]
        ids.block_height = prev_state["block_height"]
        ids.total_work = prev_state["total_work"]
        segments.write_arg(ids.best_hash, prev_state["best_hash"])
        ids.difficulty = prev_state["difficulty"]
        ids.epoch_start_time = prev_state["epoch_start_time"]
        segments.write_arg(ids.prev_timestamps, prev_state["prev_timestamps"])
        
        segments.write_arg(ids.prev_state_root, prev_state["prev_state_root"])
    %}

    let prev_chain_state = ChainState(
        block_height, total_work, best_hash,
        difficulty, epoch_start_time, prev_timestamps
    )

    let prev_state = State(prev_chain_state, prev_state_root)


    # Read the UTXO data and inclusion proofs from the program input
    # TODO: implement me


    # Perform a state transition
    let (reader) = init_reader(raw_block)
    let (context) = read_block_validation_context{reader=reader}(prev_state)
    let (next_state) = validate_and_apply_block(context)
    
    # Print the next state
    serialize_word(next_state.chain_state.block_height)
    serialize_word(next_state.chain_state.total_work)
    serialize_array(next_state.chain_state.best_hash, HASH_FELT_SIZE)
    serialize_word(next_state.chain_state.difficulty)
    serialize_word(next_state.chain_state.epoch_start_time)
    # serialize_array(next_state.chain_state.prev_timestamps, 11)

    return ()
end

func serialize_array{output_ptr: felt*}(array:felt*, array_len):
    if array_len == 0:
        return ()
    end
    serialize_word([array])
    serialize_array(array + 1, array_len - 1)
    return ()
end
