from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.registers import get_fp_and_pc

from stark_verifier.air.stark_proof import (
    ConstraintQueries,
    ParsedOodFrame,
    StarkProof,
    TraceQueries,
)
from stark_verifier.air.air_instance import AirInstance
from stark_verifier.air.table import Table
from stark_verifier.air.transitions.frame import EvaluationFrame
from stark_verifier.utils import Vec

struct TraceOodFrame {
    main_frame: EvaluationFrame,
    aux_frame: EvaluationFrame,
}

struct Channel {
    // Trace queries
    trace_roots: felt*,
    // Constraint queries
    constraint_root: felt*,
    // FRI proof
    fri_roots_len: felt,
    fri_roots: felt*,
    // OOD frame
    ood_trace_frame: TraceOodFrame,
    ood_constraint_evaluations: Vec,
    // Query PoW nonce
    pow_nonce: felt,
    // Queried trace states
    trace_queries: TraceQueries*,
    // Queried constraint evaluations
    constraint_queries: ConstraintQueries*,
}

func channel_new{bitwise_ptr: BitwiseBuiltin*}(air: AirInstance, proof: StarkProof*) -> Channel {
    // Parsed commitments
    tempvar trace_roots = proof.commitments.trace_roots;
    tempvar constraint_root = proof.commitments.constraint_root;
    tempvar fri_roots = proof.commitments.fri_roots;

    // Parsed ood_frame
    tempvar ood_constraint_evaluations = proof.ood_frame.evaluations;
    tempvar ood_trace_frame = TraceOodFrame(
        main_frame=proof.ood_frame.main_frame,
        aux_frame=proof.ood_frame.aux_frame,
    );

    tempvar channel = Channel(
        trace_roots=trace_roots,
        constraint_root=constraint_root,
        fri_roots_len=proof.commitments.fri_roots_len,
        fri_roots=fri_roots,
        ood_trace_frame=ood_trace_frame,
        ood_constraint_evaluations=ood_constraint_evaluations,
        pow_nonce=proof.pow_nonce,
        trace_queries=&proof.trace_queries,
        constraint_queries=&proof.constraint_queries,
    );
    return channel;
}

func read_trace_commitments{channel: Channel}() -> felt* {
    return channel.trace_roots;
}

func read_constraint_commitment{channel: Channel}() -> felt* {
    return channel.constraint_root;
}

func read_ood_trace_frame{channel: Channel}() -> (res1: EvaluationFrame, res2: EvaluationFrame) {
    return (res1=channel.ood_trace_frame.main_frame, res2=channel.ood_trace_frame.aux_frame,);
}

func read_ood_constraint_evaluations{channel: Channel}() -> Vec {
    return channel.ood_constraint_evaluations;
}

func read_pow_nonce{channel: Channel}() -> felt {
    return channel.pow_nonce;
}

func read_queried_trace_states{channel: Channel}(positions: felt*) -> (
    main_states: Table, aux_states: Table
) {
    // TODO: Authenticate proof paths
    return (channel.trace_queries.main_states, channel.trace_queries.aux_states);
}

func read_constraint_evaluations{channel: Channel}(positions: felt*) -> Table {
    // TODO: Authenticate proof paths
    return channel.constraint_queries.evaluations;
}
