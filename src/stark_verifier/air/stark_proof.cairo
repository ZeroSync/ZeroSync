


// https://github.com/novifinancial/winterfell/blob/f14a9ab9ce36589daf74c9c9dde344995390efcd/air/src/air/trace_info.rs#L158
struct TraceLayout {
    main_segment_width: felt,
    aux_segment_widths: felt,
    aux_segment_rands: felt,
    num_aux_segments: felt,
}

// https://github.com/novifinancial/winterfell/blob/0b7cc3dc28c6b1ad43eb3f2850f644bff1423cf9/air/src/options.rs#L82
struct ProofOptions {
    num_queries: felt,
    blowup_factor: felt,
    grinding_factor: felt,
    hash_fn: felt, // https://github.com/novifinancial/winterfell/blob/0b7cc3dc28c6b1ad43eb3f2850f644bff1423cf9/air/src/options.rs#L20
    field_extension: felt, // https://github.com/novifinancial/winterfell/blob/0b7cc3dc28c6b1ad43eb3f2850f644bff1423cf9/air/src/options.rs#L52
    fri_folding_factor: felt,
    fri_max_remainder_size: felt, // stored as power of 2
}


struct Context {
    trace_layout: TraceLayout,
    trace_length: felt,
    trace_meta: felt*,
    field_modulus_bytes: felt*,
    options: ProofOptions,
}


// https://github.com/novifinancial/winterfell/blob/ecea359802538692c4e967b083107c6b08f3302e/air/src/proof/commitments.rs#L25
struct Commitments {
    trace_commitments : felt*, 
    constraint_commitment : felt*, 
    fri_commitments : felt*,
}


struct Queries {
    paths: felt*,
    values: felt*,
}

struct OodFrame {
    trace_states: felt*,
    evaluations: felt*,
}

// https://github.com/novifinancial/winterfell/blob/446d8a67bcfa819d50d0adbbf191611dc7b3622c/fri/src/proof.rs#L32
struct FriProof {
    layers: FriProofLayer*,
    remainder: felt*,
    num_partitions: felt, // stored as power of 2
}

// https://github.com/novifinancial/winterfell/blob/446d8a67bcfa819d50d0adbbf191611dc7b3622c/fri/src/proof.rs#L246
struct FriProofLayer {
    values: felt*,
    paths: felt*, // array of array of hashes. Each hash is represented as 8 x uint32 ? 
}

// Defintion of a STARK proof
//
// See also:
// https://github.com/novifinancial/winterfell/blob/ecea359802538692c4e967b083107c6b08f3302e/air/src/proof/mod.rs#L51
// 
struct StarkProof {
    /// Basic metadata about the execution of the computation described by this proof.
    context: Context,
    /// Commitments made by the prover during the commit phase of the protocol.
    commitments: Commitments,
    /// Decommitments of extended execution trace values (for all trace segments) at position
    /// queried by the verifier.
    trace_queries: Queries*,
    /// Decommitments of constraint composition polynomial evaluations at positions queried by
    /// the verifier.
    constraint_queries: Queries,
    /// Trace and constraint polynomial evaluations at an out-of-domain point.
    ood_frame: OodFrame,
    /// Low-degree proof for a DEEP composition polynomial.
    fri_proof: FriProof,
    /// Proof-of-work nonce for query seed grinding.
    pow_nonce: felt,
}