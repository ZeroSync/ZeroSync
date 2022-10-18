from recursive.air.trace_info import TraceInfo

struct ProofOptions {
    grinding_factor: felt,
    num_queries: felt,
    blowup_factor: felt,
}

struct Context {
    options: ProofOptions,
    trace_info: TraceInfo,
}

struct Commitments {
}

struct TraceQueries {
}

struct ConstraintQueries {
}

struct OodFrame {
}

struct FriProof {
}


struct StarkProof {
    /// Basic metadata about the execution of the computation described by this proof.
    context: Context,
    /// Commitments made by the prover during the commit phase of the protocol.
    commitments: Commitments,
    /// Decommitments of extended execution trace values (for all trace segments) at position
    /// queried by the verifier.
    trace_queries: TraceQueries,
    /// Decommitments of constraint composition polynomial evaluations at positions queried by
    /// the verifier.
    constraint_queries: ConstraintQueries,
    /// Trace and constraint polynomial evaluations at an out-of-domain point.
    ood_frame: OodFrame,
    /// Low-degree proof for a DEEP composition polynomial.
    fri_proof: FriProof,
    /// Proof-of-work nonce for query seed grinding.
    pow_nonce: felt,
}
