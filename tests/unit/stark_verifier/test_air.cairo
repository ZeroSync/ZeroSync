//
// To run only this test suite use:
// make test TEST_PATH="stark_verifier/test_air.cairo"
// 

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memset import memset
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from stark_verifier.air.air_instance import get_constraint_composition_coefficients, ConstraintCompositionCoefficients
from stark_verifier.crypto.random import PublicCoin
from stark_verifier.air.air_instance import AirInstance, air_instance_new
from utils.endianness import byteswap32

from stark_verifier.air.stark_proof import read_stark_proof, StarkProof
from stark_verifier.air.pub_inputs import read_public_inputs, PublicInputs


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
func test_get_constraint_composition_coefficients{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    let (blake2s_ptr: felt*) = alloc();

    // Initialize arguments
    let (air_ptr: AirInstance*) = alloc();
    let (coin_ptr: PublicCoin*) = alloc();
    let (local coeffs_expected: ConstraintCompositionCoefficients*) = alloc();
    %{
        from zerosync_hints import *
        from src.stark_verifier.utils import write_into_memory
        data = evaluation_data()
        write_into_memory(ids.air_ptr, data['air'], segments)
        write_into_memory(ids.coin_ptr, data['constraint_coeffs_coin'], segments)
        write_into_memory(ids.coeffs_expected, data['constraint_coeffs'], segments)
    %}
    
    let (seed) = alloc();
    assert seed[0] = byteswap32( [coin_ptr].seed[0] );
    assert seed[1] = byteswap32( [coin_ptr].seed[1] );
    assert seed[2] = byteswap32( [coin_ptr].seed[2] );
    assert seed[3] = byteswap32( [coin_ptr].seed[3] );
    assert seed[4] = byteswap32( [coin_ptr].seed[4] );
    assert seed[5] = byteswap32( [coin_ptr].seed[5] );
    assert seed[6] = byteswap32( [coin_ptr].seed[6] );
    assert seed[7] = byteswap32( [coin_ptr].seed[7] );

    local public_coin: PublicCoin = PublicCoin(
        seed = seed,
        counter = [coin_ptr].counter
    );
    local air: AirInstance = [air_ptr];

    with blake2s_ptr, public_coin {
        let coeffs = get_constraint_composition_coefficients(air);
    }

    %{ 
        
        for i in range(ids.air.num_transition_constraints):
            a = memory[ids.coeffs.transition_a + i]
            b = memory[ids.coeffs_expected.transition_a + i]
            assert a == b, f"at index {i}: {hex(a)} != {hex(b)}"

            a = memory[ids.coeffs.transition_b + i]
            b = memory[ids.coeffs_expected.transition_b + i]
            assert a == b, f"at index {i}: {hex(a)} != {hex(b)}"

            i += 1

        for i in range(ids.air.num_assertions):
            a = memory[ids.coeffs.boundary_a + i]
            b = memory[ids.coeffs_expected.boundary_a + i]
            assert a == b, f"at index {i}: {hex(a)} != {hex(b)}"

            a = memory[ids.coeffs.boundary_b + i]
            b = memory[ids.coeffs_expected.boundary_b + i]
            assert a == b, f"at index {i}: {hex(a)} != {hex(b)}"

            i += 1
    %}
    return ();
}



@external
func test_air_instance_new{
    range_check_ptr
}() {
    alloc_locals;

    // Initialize arguments
    let (air_ptr: AirInstance*) = alloc();
    let (coin_ptr: PublicCoin*) = alloc();
    let (local coeffs_expected: ConstraintCompositionCoefficients*) = alloc();
    %{
        from zerosync_hints import *
        from src.stark_verifier.utils import write_into_memory
        data = evaluation_data()
        write_into_memory(ids.air_ptr, data['air'], segments)
    %}

    let proof: StarkProof* = read_stark_proof();

    
    let pub_inputs: PublicInputs* = read_public_inputs();
    
    local air_expected:AirInstance = [air_ptr];
    let air = air_instance_new(proof, pub_inputs);

    %{ 
        assert ids.air_expected.main_segment_width == ids.air.main_segment_width
        assert ids.air_expected.aux_trace_width == ids.air.aux_trace_width
        assert ids.air_expected.num_aux_segments == ids.air.num_aux_segments
        assert ids.air_expected.num_transition_constraints == ids.air.num_transition_constraints
        assert ids.air_expected.num_assertions == ids.air.num_assertions
        assert ids.air_expected.ce_blowup_factor == ids.air.ce_blowup_factor
        assert ids.air_expected.eval_frame_size == ids.air.eval_frame_size
        assert ids.air_expected.trace_domain_generator == ids.air.trace_domain_generator
        assert ids.air_expected.lde_domain_generator == ids.air.lde_domain_generator
    %}
    return ();
}
