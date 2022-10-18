from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256

from recursive.air.stark_proof import (
    Commitments,
    ConstraintQueries,
    StarkProof,
    TraceQueries,
)
from recursive.air.air_instance import AirInstance
from recursive.air.transitions.frame import EvaluationFrame
from recursive.utils import Vec

struct Channel {
    // Trace queries
    trace_roots: Uint256*,
    trace_queries: TraceQueries,
    // Constraint queries
    constraint_root: Uint256,
    constraint_queries: ConstraintQueries,
    // OOD constraint evaluations 
    ood_constraint_evaluations: Vec,
    // Query PoW nonce
    pow_nonce: felt,
}

struct TraceOodFrame {
    main_frame: EvaluationFrame,
    aux_frame: EvaluationFrame,
}

struct Table {
    data: felt*,
    row_width: felt,
}

func channel_new{
    bitwise_ptr: BitwiseBuiltin*,
}(
    air: AirInstance,
    proof: StarkProof,
) -> (channel: Channel) {
    // Extract queries from proof
    let trace_queries = proof.trace_queries;
    let constraint_queries = proof.constraint_queries;

    tempvar num_trace_segments = air.num_aux_segments + 1;
    tempvar main_trace_width = air.main_segment_width;
    tempvar aux_trace_width = air.aux_trace_width;

    // Parse commitments
    let (trace_roots, constraint_root) = parse_commitments(
        n_segments=num_trace_segments,
        commitments=proof.commitments,
    );

    // TODO: Parse ood_frame from StarkProof
    let (elements: felt*) = alloc();
    tempvar ood_constraint_evaluations = Vec(n_elements=0, elements=elements);

    tempvar channel = Channel(
        trace_roots=trace_roots,
        trace_queries=trace_queries,
        constraint_root=constraint_root,
        constraint_queries=constraint_queries,
        ood_constraint_evaluations=ood_constraint_evaluations,
        pow_nonce=proof.pow_nonce,
    );
    return (channel=channel);
}

func parse_commitments{
    bitwise_ptr: BitwiseBuiltin*,
}(
    n_segments: felt,
    commitments: Commitments,
) -> (
    trace_roots: Uint256*,
    constraint_root: Uint256,
) {
    // TODO: Deserialize commitments
    let (trace_roots: Uint256*) = alloc();
    assert trace_roots[0] = Uint256(0,0);
    let constraint_root = Uint256(0,0);
    return (
        trace_roots=trace_roots,
        constraint_root=constraint_root,
    );
}

func read_trace_commitments{channel: Channel}() -> (res: Uint256*) {
    return (res=channel.trace_roots);
}

func read_constraint_commitment{channel: Channel}() -> (res: Uint256) {
    return (res=channel.constraint_root);
}

func read_ood_trace_frame{
    channel: Channel
}() -> (res1: EvaluationFrame, res2: EvaluationFrame) {
    // TODO
    tempvar ood_main_trace_frame = EvaluationFrame();
    tempvar ood_aux_trace_frame = EvaluationFrame();
    return (
        res1=ood_main_trace_frame,
        res2=ood_aux_trace_frame,
    );
}

func read_ood_constraint_evaluations{channel: Channel}() -> (res: Vec) {
    return (res=channel.ood_constraint_evaluations);
}

func read_pow_nonce{channel: Channel}() -> (res: felt) {
    return (res=channel.pow_nonce);
}

func read_queried_trace_states{
    channel: Channel,
}(
    positions: felt*,
) -> (res1: Table, res2: Table) {
    // TODO
    let (data1: felt*) = alloc();
    let (data2: felt*) = alloc();
    tempvar res1 = Table(data=data1, row_width=0);
    tempvar res2 = Table(data=data2, row_width=0);
    return (res1=res1, res2=res2);
}

func read_constraint_evaluations{
    channel: Channel
}(
    positions: felt*,
) -> (res: Table) {
    // TODO
    let (data: felt*) = alloc();
    tempvar res = Table(data=data, row_width=0);
    return (res=res);
}
