//
// To run only this test suite use:
// make test TEST_PATH="stark_verifier/test_stark_verifier.cairo"
// 

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memset import memset
from starkware.cairo.common.hash import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from stark_verifier.stark_verifier import read_and_verify_stark_proof


@external
func __setup__() {
    %{ 
        # Compile, run, and generate proof of a fibonnaci program
        import os
        os.system('make INTEGRATION_PROGRAM_NAME=fibonacci integration_proof')
    %}
    return ();
}

@external
func test_read_and_verify_stark_proof{
    pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;

    let (program_hash, outputs) = read_and_verify_stark_proof();

    return ();
}
