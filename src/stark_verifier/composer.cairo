from starkware.cairo.common.alloc import alloc

from stark_verifier.air.air_instance import AirInstance, DeepCompositionCoefficients
from stark_verifier.air.transitions.frame import EvaluationFrame
from stark_verifier.channel import Table
from stark_verifier.utils import Vec

struct DeepComposer {
}

func deep_composer_new(
    air: AirInstance, query_positions: felt*, z: felt, cc: DeepCompositionCoefficients
) -> DeepComposer {
    let res = DeepComposer();
    return res;
}

func compose_trace_columns(
    composer: DeepComposer,
    queried_main_trace_states: Table,
    queried_aux_trace_states: Table,
    ood_main_frame: EvaluationFrame,
    ood_aux_frame: EvaluationFrame,
) -> felt* {
    // TODO
    let (data: felt*) = alloc();
    return data;
}

func compose_constraint_evaluations(
    composer: DeepComposer, queried_evaluations: Table, ood_evaluations: Vec
) -> felt* {
    // TODO
    let (data: felt*) = alloc();
    return data;
}

func combine_compositions(
    composer: DeepComposer, t_composition: felt*, c_composition: felt*
) -> felt* {
    // TODO
    let (data: felt*) = alloc();
    return data;
}
