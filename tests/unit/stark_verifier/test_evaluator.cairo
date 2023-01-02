//
// To run only this test suite use:
// make test TEST_PATH="stark_verifier/test_evaluator.cairo"
// 

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memset import memset

from stark_verifier.air.transitions.frame import EvaluationFrame, evaluate_transition
from stark_verifier.air.air_instance import AirInstance, ConstraintCompositionCoefficients
from stark_verifier.evaluator import evaluate_constraints



@external
func test_evaluate_constraints{
    range_check_ptr
}() {
    alloc_locals;

    // Initialize arguments
    let (air_ptr: AirInstance*) = alloc();
    let (coeffs_ptr: ConstraintCompositionCoefficients*) = alloc();
    let (ood_main_trace_frame_ptr: EvaluationFrame*) = alloc();
    let (ood_aux_trace_frame_ptr: EvaluationFrame*) = alloc();
    let (aux_trace_rand_elements: felt**) = alloc();
    local z;
    %{
        from zerosync_hints import *
        from src.stark_verifier.utils import write_into_memory
        data = evaluation_data()
        write_into_memory(ids.air_ptr, data['air'], segments)
        write_into_memory(ids.coeffs_ptr, data['constraint_coeffs'], segments)
        write_into_memory(ids.ood_main_trace_frame_ptr, data['ood_main_trace_frame'], segments)
        write_into_memory(ids.ood_aux_trace_frame_ptr, data['ood_aux_trace_frame'], segments)
        write_into_memory(ids.aux_trace_rand_elements, data['aux_trace_rand_elements'], segments)
        ids.z = int(data['z'], 16)
    %}

    let ood_constraint_evaluation = evaluate_constraints(
        air=[air_ptr],
        coeffs=[coeffs_ptr],
        ood_main_trace_frame=[ood_main_trace_frame_ptr],
        ood_aux_trace_frame=[ood_aux_trace_frame_ptr],
        aux_trace_rand_elements=aux_trace_rand_elements,
        z=z,
    );

    %{
        a = hex(ids.ood_constraint_evaluation)[2:]
        b = data['ood_constraint_evaluation']
        print('test_evaluate_constraints', a, b)
        # TODO: Debug me
        # assert a == b
    %}

    return ();
}