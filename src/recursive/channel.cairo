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

struct Channel {
    // Trace queries
    trace_roots: Uint256*,
    trace_queries: TraceQueries,
    // Constraint queries
    constraint_root: Uint256,
    constraint_queries: ConstraintQueries,
}

struct TraceOodFrame {
    main_frame: EvaluationFrame,
    aux_frame: EvaluationFrame,
}

func channel_new{
    bitwise_ptr: BitwiseBuiltin*,
}(air: AirInstance, proof: StarkProof) -> (channel: Channel) {
    // Extract queries from proof
    let trace_queries = proof.trace_queries;
    let constraint_queries = proof.constraint_queries;

    tempvar num_trace_segments = air.num_segments;
    tempvar main_trace_width = air.main_trace_width;
    tempvar aux_trace_width = air.aux_trace_width;

    // Parse commitments
    let (trace_roots, constraint_root) = parse_commitments(
        n_segments=num_trace_segments,
        commitments=proof.commitments,
    );

    tempvar channel = Channel(
        trace_roots=trace_roots,
        trace_queries=trace_queries,
        constraint_root=constraint_root,
        constraint_queries=constraint_queries,
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

func read_ood_trace_frame() -> () {
    // TODO
    return ();
}

func read_ood_constraint_evaluations() -> () {
    // TODO
    return ();
}

