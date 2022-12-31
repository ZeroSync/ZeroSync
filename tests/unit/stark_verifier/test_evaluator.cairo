%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memset import memset

from stark_verifier.air.transitions.frame import EvaluationFrame, evaluate_transition

struct ConstraintEvaluationArguments {
    air: AirInstance,
    coeffs: ConstraintCompositionCoefficients,
    ood_main_trace_frame: EvaluationFrame,
    ood_aux_trace_frame: EvaluationFrame,
    aux_trace_rand_elements: felt**,
    z: felt,
}

@external
func test_evaluate_constraints() {
    alloc_locals;

    // Initialize arguments
    local args: ConstraintEvaluationArguments;
    %{
        from zerosync_hints import *
        # TODO: Implement 'load_constraint_evaluation_args' in zerosync_hints crate
        segments.write_arg(ids.arguments.address_, load_constraint_evaluation_args);
    %}

    let ood_constraint_evaluation = evaluate_constraints(
        air=args.air,
        coeffs=args.constraint_coeffs,
        ood_main_trace_frame=args.ood_main_trace_frame,
        ood_aux_trace_frame=args.ood_aux_trace_frame,
        aux_trace_rand_elements=args.aux_trace_rand_elements,
        z=z,
    );

    %{
        from src.utils.hex_utils import get_hex
        a = get_hex(memory, ids.ood_constraint_evaluation)
        b = constraint_evaluation()
        print("test_evaluate_constraints", a, b)
        assert a == b
    %}

    return ();
}
