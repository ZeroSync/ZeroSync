from starkware.cairo.common.hash_state import hash_finalize, hash_init, hash_update
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy
from stark_verifier.air.pub_inputs import PublicInputs, read_public_inputs
from stark_verifier.air.pub_inputs import read_mem_values
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.hash import HashBuiltin
from stark_verifier.air.stark_proof import StarkProof, read_stark_proof
from stark_verifier.stark_verifier import verify
from crypto.hash_utils import HASH_FELT_SIZE
from utils.compute_median import TIMESTAMP_COUNT
from utreexo.utreexo import UTREEXO_ROOTS_LEN
from block.block import State, ChainState


func recurse{pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    block_height, expected_program_hash, program_length, prev_state: State) {
    alloc_locals;

    // For the genesis block there is no parent proof to verify
    if(block_height == 0){
        return ();
    }

    // 1. Read the public inputs of the parent proof from a hint
    let pub_inputs_ptr = parse_public_inputs();
    let pub_inputs = [pub_inputs_ptr];
    let (mem_values: felt*) = alloc();
    let mem_length = pub_inputs.fin._pc;
    read_mem_values(
        mem=&pub_inputs.mem, address=pub_inputs.init._pc, length=mem_length, output=mem_values
    );

    // 2. Compute the program's hash and compare it to the `expected_program_hash` given to us 
    // as a public input to the child proof
    let program_hash = compute_program_hash(mem_values, program_length);
    assert expected_program_hash = program_hash;

    // 2. Read the parent proof from the location it was written to by main.py
    let proof = parse_proof();

    // 3. Verify the proof with its public inputs using the verifier
    verify(proof, pub_inputs_ptr);

    // 4. Parse the `next_state` of the parent proof from its public inputs into a bitcoin `State` 
    // and then verify it is equal to the child proof's `prev_state`
    verify_prev_state(mem_values + program_length, prev_state, program_hash, program_length);

    return ();
}

func verify_prev_state(mem_values: felt*, prev_state: State, program_hash, program_length){
    let chain_state = prev_state.chain_state;
    
    assert chain_state.block_height = mem_values[0];
    assert chain_state.total_work = mem_values[1];
    let mem_values = mem_values + 2;

    assert chain_state.best_block_hash = mem_values;
    let mem_values = mem_values + HASH_FELT_SIZE;

    assert chain_state.current_target = mem_values[0];
    assert chain_state.epoch_start_time = mem_values[1];
    let mem_values = mem_values + 2;

    memcpy(chain_state.prev_timestamps, mem_values, TIMESTAMP_COUNT);
    let mem_values = mem_values + TIMESTAMP_COUNT;

    memcpy(prev_state.utreexo_roots, mem_values, UTREEXO_ROOTS_LEN);
    let mem_values = mem_values + UTREEXO_ROOTS_LEN;

    assert program_hash = mem_values[0];
    assert program_length = mem_values[1];

    return ();
}

func compute_program_hash{pedersen_ptr: HashBuiltin*}(
    mem_values:felt*, program_length) -> felt {
    alloc_locals;

    let (hash_state_ptr) = hash_init();
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(
        hash_state_ptr=hash_state_ptr, data_ptr=mem_values, data_length=program_length
    );
    let (pub_mem_hash) = hash_finalize{hash_ptr=pedersen_ptr}(hash_state_ptr=hash_state_ptr);

    return pub_mem_hash;
}


func parse_public_inputs() -> PublicInputs* {
    %{
        import json
        import subprocess

        def parse_public_inputs():
            completed_process = subprocess.run([
                'src/stark_verifier/parser/target/debug/parser',
                'tmp/proof.bin',
                'public-inputs'],
                capture_output=True)
            return json.loads(completed_process.stdout)
        json_data = parse_public_inputs()
    %}
    return read_public_inputs();
}


func parse_proof() -> StarkProof* {
    %{
        import json
        import subprocess

        def parse_proof():
            completed_process = subprocess.run([
                'src/stark_verifier/parser/target/debug/parser',
                'tmp/proof.bin',
                'proof'],
                capture_output=True)
            return json.loads(completed_process.stdout)
        json_data = parse_proof()
    %}
    return read_stark_proof();
}

