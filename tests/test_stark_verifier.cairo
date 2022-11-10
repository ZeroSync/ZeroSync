// To run all tests in this suite use the following:
// protostar test --cairo-path=./src tests
//
%lang starknet

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.hash import HashBuiltin

from stark_verifier.air.stark_proof import read_stark_proof, StarkProof
from stark_verifier.air.pub_inputs import read_public_inputs, PublicInputs
from stark_verifier.stark_verifier import verify

@external
func __setup__() {
    %{ 
        # Compile, run, and generate proof of a fibonnaci program
        # TODO: Use cached compiler and prover artifacts if source code is unchanged
        from tests.utils import setup
        path = ("tests/cairo_programs/", "fibonacci")
        setup(path)
    %}
    return ();
}

/// Test deserialization of StarkProof from file
@external
func test_read_stark_proof{}() {
    %{ 
        from tests.utils import parse_proof
        json_data = parse_proof('fibonacci')
    %}
    let (proof: StarkProof*) = read_stark_proof();

    %{ 
        # TODO: Assert that all proof fields were deserialized correctly using utils.py
        print('main_segment_width:', ids.proof.context.trace_layout.main_segment_width)
        print('num_queries:', ids.proof.context.options.num_queries)
        print('blowup_factor:', ids.proof.context.options.blowup_factor)
        print('pow_nonce:', ids.proof.pow_nonce)
    %}
    return ();
}

/// Test deserialization of PublicInputs from file
@external
func test_read_pub_inputs{}() {
    %{ 
        from tests.utils import parse_public_inputs
        json_data = parse_public_inputs('fibonacci')
    %}
    let (pub_inputs: PublicInputs*) = read_public_inputs();

    %{
        # TODO: Assert that all proof fields were deserialized correctly using utils.py
        print('init.pc:', ids.pub_inputs.init._pc)
        print('rc_min:', ids.pub_inputs.rc_min)
    %}
    return ();
}

/// Test proof verification
@external
func test_verify{
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
}() {
    %{ 
        from tests.utils import parse_proof
        json_data = parse_proof('fibonacci')
    %}
    let (proof: StarkProof*) = read_stark_proof();

    %{ 
        from tests.utils import parse_public_inputs
        json_data = parse_public_inputs('fibonacci')
    %}
    let (pub_inputs: PublicInputs*) = read_public_inputs();
 
    verify(proof, pub_inputs);
    return ();
}
