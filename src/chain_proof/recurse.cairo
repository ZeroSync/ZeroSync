from starkware.cairo.common.hash_state import hash_finalize, hash_init, hash_update
from starkware.cairo.common.alloc import alloc
from stark_verifier.air.pub_inputs import PublicInputs, read_public_inputs
from stark_verifier.air.pub_inputs import read_mem_values
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.hash import HashBuiltin
from stark_verifier.air.stark_proof import StarkProof, read_stark_proof
from stark_verifier.stark_verifier import verify
from crypto.sha256d.sha256d import assert_hashes_equal


func recurse{pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(block_height, expected_program_hash){
    alloc_locals;

    // For the genesis block there is no parent proof to verify
    if(block_height == 0){
        return ();
    }

    // 1. Read the public inputs of the parent proof from a hint
    let pub_inputs = parse_public_inputs();

    // 2. Compute the program's hash and compare it to the `expected_program_hash` given to us as a public input
    // to the child proof
    let program_hash = compute_program_hash(pub_inputs);
    assert expected_program_hash = program_hash;

    // 2. Read the parent proof from wherever it was written to by main.py
    let proof = parse_proof();

    // 3. Verify the pair (proof, public inputs) using the verifier
    verify(proof, pub_inputs);

    // 4. Parse the `next_state` from the public inputs into a bitcoin `State` 
    // and then return it
    // TODO:

    return ();
}


func compute_program_hash{pedersen_ptr: HashBuiltin*}(pub_inputs_ptr: PublicInputs*) -> felt {
    alloc_locals;
    // TODO: move this function to random.cairo and remove duplicated code from `seed_with_pub_inputs`

    let pub_inputs = [pub_inputs_ptr];
    let (mem_values: felt*) = alloc();
    let mem_length = pub_inputs.fin._pc;
    read_mem_values(
        mem=&pub_inputs.mem, address=pub_inputs.init._pc, length=mem_length, output=mem_values
    );

    let (hash_state_ptr) = hash_init();
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(
        hash_state_ptr=hash_state_ptr, data_ptr=mem_values, data_length=mem_length
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
    let (pub_inputs: PublicInputs*) = read_public_inputs();
    return pub_inputs;
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
    let (proof: StarkProof*) = read_stark_proof();
    return proof;
}

