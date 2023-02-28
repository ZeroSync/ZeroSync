from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.uint256 import Uint256

from stark_verifier.air.pub_inputs import PublicInputs
from stark_verifier.air.table import Table
from stark_verifier.air.transitions.frame import EvaluationFrame
from stark_verifier.utils import Vec, Digest

struct TraceLayout {
    main_segment_width: felt,
    num_aux_segments: felt,
    aux_segment_widths: felt*,
    aux_segment_rands: felt*,
}

struct ProofOptions {
    num_queries: felt,
    blowup_factor: felt,
    log_blowup_factor: felt,
    grinding_factor: felt,
    hash_fn: felt,
    field_extension: felt,
    fri_folding_factor: felt,
    fri_max_remainder_size: felt,  // stored as power of 2
}

struct ProofContext {
    trace_layout: TraceLayout,
    trace_length: felt,
    log_trace_length: felt,
    trace_meta_len: felt,
    trace_meta: felt*,
    field_modulus_bytes_len: felt,
    field_modulus_bytes: felt*,
    options: ProofOptions,
    lde_domain_size: felt,
}

struct ParsedCommitments {
    trace_roots: felt*,
    constraint_root: felt*,
    fri_roots_len: felt,
    fri_roots: felt*,
}

struct ParsedOodFrame {
    main_frame: EvaluationFrame,
    aux_frame: EvaluationFrame,
    evaluations: Vec,
}

struct TraceQueries {
    main_states: Table,
    aux_states: Table,
}

struct ConstraintQueries {
    evaluations: Table,
}

// Definition of a STARK proof
//
// See also:
// https://github.com/novifinancial/winterfell/blob/ecea359802538692c4e967b083107c6b08f3302e/air/src/proof/mod.rs#L51
//
struct StarkProof {
    // Basic metadata about the execution of the computation described by this proof.
    context: ProofContext,
    // Commitments made by the prover during the commit phase of the protocol.
    commitments: ParsedCommitments,
    // Trace evaluation frames and out-of-domain constraint evaluations
    ood_frame: ParsedOodFrame,
    // Proof-of-work nonce for query seed grinding.
    pow_nonce: felt,
    // Queried states for all trace segments (no authentication paths)
    trace_queries: TraceQueries,
    // Queried constraint evaluations (no authentication paths)
    constraint_queries: ConstraintQueries,
    // A proof consists of zero or more layers and a remainder, which is an array of Felts
    remainder: Vec,
}

func read_stark_proof() -> StarkProof* {
    let (proof_ptr: StarkProof*) = alloc();
    %{
        from src.stark_verifier.utils import write_into_memory
        write_into_memory(ids.proof_ptr, json_data, segments)
    %}
    return proof_ptr;
}
