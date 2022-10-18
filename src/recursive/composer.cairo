from starkware.cairo.common.alloc import alloc

from recursive.air.air_instance import (
    AirInstance,
    DeepCompositionCoefficients,
)
from recursive.air.transitions.frame import EvaluationFrame
from recursive.channel import Table
from recursive.utils import Vec

struct DeepComposer {
}

func deep_composer_new(
    air: AirInstance,
    query_positions: felt*,
    z: felt,
    cc: DeepCompositionCoefficients,
) -> (res: DeepComposer) {
    return (res=DeepComposer());
}

func compose_trace_columns(
    composer: DeepComposer,
    queried_main_trace_states: Table,
    queried_aux_trace_states: Table,
    ood_main_frame: EvaluationFrame,
    ood_aux_frame: EvaluationFrame, 
) -> (res: felt*) {
    // TODO
    let (data: felt*) = alloc();
    return (res=data);
}

func compose_constraint_evaluations(
    composer: DeepComposer,
    queried_evaluations: Table, 
    ood_evaluations: Vec,
) -> (res: felt*) {
    // TODO
    let (data: felt*) = alloc();
    return (res=data);
}

func combine_compositions(
    composer: DeepComposer,
    t_composition: felt*,
    c_composition: felt*,
) -> (res: felt*) {
    // TODO
    let (data: felt*) = alloc();
    return (res=data);
}
