//
// To run only this test suite use:
// protostar test --cairo-path=./src target src/stark_verifier/test_stark_verifier.cairo
//

%lang starknet

from stark_verifier.air.stark_proof import read_stark_proof

// @external
func test_stark_verifier{}() {
    let proof = read_stark_proof();
    %{ print('pow_nonce:', hex(ids.proof.pow_nonce) ) %}
    %{ print('trace_length:', hex(ids.proof.context.trace_length )) %}
    // let meta = proof.context.trace_meta[0];
    // %{ print('trace_meta:', ids.meta ) %}
    return ();
}
