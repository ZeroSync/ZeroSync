%builtins output range_check bitwise

# Import the serialize_word() function.
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.serialize import serialize_word

from block_header import ChainState
from buffer import init_reader
from block import State, validate_and_apply_block, read_block_validation_context

func main{output_ptr : felt*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}():
    alloc_locals
    # Read a block from the program input
    let (raw_block) = alloc()
    %{
        raw_block = program_input["raw_block"]
        segments.write_arg(ids.raw_block, raw_block)
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
        ids.block_height = program_input["prev_state"]["block_height"]

        ids.total_work = program_input["prev_state"]["total_work"]

        best_hash = program_input["prev_state"]["best_hash"]
        segments.write_arg(ids.best_hash, best_hash)

        ids.difficulty = program_input["prev_state"]["difficulty"]

        ids.epoch_start_time = program_input["prev_state"]["epoch_start_time"]

        prev_timestamps = program_input["prev_state"]["prev_timestamps"]
        segments.write_arg(ids.prev_timestamps, prev_timestamps)

        prev_state_root = program_input["prev_state"]["prev_state_root"]
        segments.write_arg(ids.prev_state_root, prev_state_root)
    %}

    let prev_chain_state = ChainState(
        block_height, total_work, best_hash, 
        difficulty, epoch_start_time, prev_timestamps
    )

    let prev_state = State(prev_chain_state, prev_state_root)


    # Read the UTXO proof data and inclusion proofs
    # from the program input
    # TODO: implement me


    # Prove a state transition
    let (reader) = init_reader(raw_block)
    let (context) = read_block_validation_context{reader=reader}(prev_state)
    let (next_state) = validate_and_apply_block(context)
    serialize_word(next_state.chain_state.block_height)

    return ()
end 


