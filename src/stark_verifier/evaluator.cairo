from starkware.cairo.common.alloc import alloc
from stark_verifier.air.air_instance import AirInstance, ConstraintCompositionCoefficients
from stark_verifier.air.transitions.frame import (
    EvaluationFrame,
    combine_evaluations,
    evaluate_transition,
    evaluate_aux_transition,
)

func evaluate_constraints(
    air: AirInstance,
    constraint_coeffs: ConstraintCompositionCoefficients,
    ood_main_trace_frame: EvaluationFrame,
    ood_aux_trace_frame: EvaluationFrame,
    aux_trace_rand_elements: felt*,
    z: felt,
) -> felt {
    alloc_locals;

    // Evaluate main trace
    let (t_evaluations1: felt*) = alloc();
    evaluate_transition(
        ood_main_trace_frame, 
        t_evaluations1,
    );

    // Evaluate auxiliary trace
    let (t_evaluations2: felt*) = alloc();
    evaluate_aux_transition(
        ood_main_trace_frame,
        ood_aux_trace_frame, 
        aux_trace_rand_elements,
        t_evaluations2,
    );

    // Combine evaluations
    combine_evaluations(t_evaluations1, t_evaluations2, z);

    // 2 ----- evaluate boundary constraints ------------------------------------------------------
    // TODO

    return 0;
}
