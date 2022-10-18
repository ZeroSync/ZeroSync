from recursive.air.air_instance import (
    AirInstance,
    ConstraintCompositionCoefficients,
)
from recursive.air.transitions.frame import EvaluationFrame

func evaluate_constraints(
    air: AirInstance,
    constraint_coeffs: ConstraintCompositionCoefficients,
    ood_main_trace_frame: EvaluationFrame,
    ood_aux_trace_frame: EvaluationFrame,
    aux_trace_rand_elements: felt*,
    z: felt,
) -> (res: felt) {
    // TODO
    return (res=0);
}
