from stark_verifier.air.pub_inputs import PublicInputs, read_public_inputs

func recurse(program_hash: felt*){

    // 1. The program is written into memory by a hint
    // Compute the program's hash and compare it to the `program_hash` given to us as a public input
    // to the child proof

    let pub_inputs = parse_public_inputs();

    // 2. Read the parent proof from wherever it was written to by main.py
    
    // 3. Read the public inputs of the parent proof from a hint

    // 4. Verify the triple (proof, public inputs, program) using the verifier
    
    // 5. Parse the `next_state` from the public inputs into a bitcoin `State` 
    // and then return it
    return ();
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


// let (proof, pub_inputs) = read_stark_proof();

// verify(proof = proof, pub_inputs = pub_inputs);



// %{ 
//     from tests.utils import parse_proof
//     json_data = parse_proof('fibonacci')
// %}
// let (proof: StarkProof*) = read_stark_proof();

// %{ 
//     from tests.utils import parse_public_inputs
//     json_data = parse_public_inputs('fibonacci')
// %}
// let (pub_inputs: PublicInputs*) = read_public_inputs();

// verify(proof, pub_inputs);


//  def parse_proof(program_name):
//         completed_process = subprocess.run([
//             'src/stark_verifier/parser/target/debug/parser',
//             f'tests/stark_proofs/{program_name}.bin',
//             'proof'],
//             capture_output=True)
//         return json.loads(completed_process.stdout)