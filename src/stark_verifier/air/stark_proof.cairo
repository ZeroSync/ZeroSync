from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.uint256 import Uint256

from stark_verifier.air.pub_inputs import PublicInputs
from stark_verifier.air.transitions.frame import EvaluationFrame
from stark_verifier.utils import Vec

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

// https://github.com/novifinancial/winterfell/blob/f14a9ab9ce36589daf74c9c9dde344995390efcd/air/src/air/trace_info.rs#L158
struct TraceLayout {
    main_segment_width: felt,
    aux_segment_widths: felt*,
    aux_segment_rands: felt*,
    num_aux_segments: felt,
}

struct Context {
    trace_layout: TraceLayout,
    trace_length: felt,
    trace_meta_len: felt,
    trace_meta: felt*,
    field_modulus_bytes_len: felt,
    field_modulus_bytes: felt*,
    options: ProofOptions,
}

struct ParsedCommitments {
    trace_roots: Uint256*,
    constraint_root: Uint256,
    fri_roots: Uint256*,
}

struct Queries {
    paths_len : felt,
    paths: felt*,
    values_len : felt,
    values: felt*,
}

struct ParsedOodFrame {
    main_frame: EvaluationFrame,
    aux_frame: EvaluationFrame,
    evaluations: Vec,
}

// https://github.com/novifinancial/winterfell/blob/446d8a67bcfa819d50d0adbbf191611dc7b3622c/fri/src/proof.rs#L32
struct FriProof {
    layers_len : felt,
    layers: FriProofLayer*,
    remainder_len : felt,
    remainder: felt*,
    num_partitions: felt, // stored as power of 2
}

// https://github.com/novifinancial/winterfell/blob/446d8a67bcfa819d50d0adbbf191611dc7b3622c/fri/src/proof.rs#L246
struct FriProofLayer {
    values_len : felt,
    values: felt*,
    paths_len : felt,
    paths: felt*, // array of array of hashes. Each hash is represented as 8 x uint32 ? 
}

// Definition of a STARK proof
//
// See also:
// https://github.com/novifinancial/winterfell/blob/ecea359802538692c4e967b083107c6b08f3302e/air/src/proof/mod.rs#L51
// 
struct StarkProof {
    // Basic metadata about the execution of the computation described by this proof.
    context: Context,
    // Commitments made by the prover during the commit phase of the protocol.
    commitments: ParsedCommitments,
    // Trace evaluation frames and out-of-domain constraint evaluations
    ood_frame: ParsedOodFrame,
    // Low-degree proof for a DEEP composition polynomial.
    fri_proof: FriProof,
    // Proof-of-work nonce for query seed grinding.
    pow_nonce: felt,
}

func read_stark_proof() -> (proof: StarkProof, pub_inputs: PublicInputs) {
    alloc_locals;
    local pub_inputs : PublicInputs;
    let (proof_ptr: StarkProof*) = alloc();
    %{
        import os
        import json

        # Addresses are stored as `Relocatable` values in the Cairo VM.
        # The "+" operator is overloaded to perform pointer arithmetics.
        # https://github.com/starkware-libs/cairo-lang/blob/167b28bcd940fd25ea3816204fa882a0b0a49603/src/starkware/cairo/lang/vm/relocatable.py#L9
        #
        addr = ids.proof_ptr.address_
        
        proof_path = 'src/stark_verifier/parser/src/proof_9.bin'
        cmd = f'src/stark_verifier/parser/target/debug/parser {proof_path}'
        program_output_string = os.popen(cmd).read()
        
        print(program_output_string)
        json_arr = json.loads(program_output_string)

        # Felts are hex encoded starting with "0x". The virtual addresses are encoded as decimals.
        my_memory = [( int(x, 16) if x.startswith('0x') else addr + int(x) ) for x in json_arr ]
        segments.write_arg(addr, my_memory)
        
    %}

    let proof = [proof_ptr];
    
    return (proof, pub_inputs);
}
