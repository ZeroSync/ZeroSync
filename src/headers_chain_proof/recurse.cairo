from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.hash import HashBuiltin
from starkware.cairo.common.memcpy import memcpy

from block.compute_median import TIMESTAMP_COUNT
from block.block import ChainState
from crypto.hash_utils import HASH_FELT_SIZE
from crypto.hash_utils import assert_hashes_equal

from stark_verifier.stark_verifier import read_and_verify_stark_proof

func recurse{pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    block_height, expected_program_hash, prev_chain_state: ChainState, merkle_root) {
    alloc_locals;

    // For the genesis block there is no parent proof to verify
    if(block_height == 0){
        return ();
    }

    // 1. Read the public inputs of the parent proof from a hint
    // and compute the program's hash
    %{
        from src.stark_verifier.utils import set_proof_path, debug_print
        set_proof_path(f'tmp/chain_proof-{ids.prev_state.prev_chain_state.block_height}.bin')
    %}
    let (program_hash, mem_values) = read_and_verify_stark_proof();

    // 2. Compare the `program_hash` to the `expected_program_hash` 
    // given to us as a public input to the child proof. This is to resolve the hash cycle,
    // because a program cannot contain its own hash.
    assert expected_program_hash = program_hash;

    // 3. Parse the `next_state` of the parent proof from its public inputs
    // and then verify it is equal to the child proof's `prev_state`
    verify_prev_chain_state(mem_values, prev_chain_state, merkle_root, program_hash);
    return ();
}


// PUBLIC INPUTS LAYOUT
//      [0]         block_height
//      [1..8]      best_block_hash 
//      [9]         total_work
//      [10]        current_target
//      [11..21]    timestamps
//      [22]        epoch_start_time
//      [23]        merkle_root
//      [24]        program_hash
//
//  ---> total: 25 public inputs
//
func verify_prev_chain_state(mem_values: felt*, prev_chain_state: ChainState, merkle_root, program_hash){
    assert prev_chain_state.block_height = mem_values[0];
    let mem_values = mem_values + 1;

    assert_hashes_equal(prev_chain_state.best_block_hash, mem_values);
    let mem_values = mem_values + HASH_FELT_SIZE;


    assert prev_chain_state.total_work = mem_values[0];
    assert prev_chain_state.current_target = mem_values[1];
    let mem_values = mem_values + 2;
    
    memcpy(prev_chain_state.prev_timestamps, mem_values, TIMESTAMP_COUNT);
    let mem_values = mem_values + TIMESTAMP_COUNT;
    
    assert prev_chain_state.epoch_start_time = mem_values[0];
    let mem_values = mem_values + 1;

    assert merkle_root = mem_values[0];
    let mem_values = mem_values + 1;

    assert program_hash = mem_values[0];

    return ();
}

