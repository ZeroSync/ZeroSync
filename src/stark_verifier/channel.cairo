from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.cairo_blake2s.blake2s import blake2s_as_words

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
from crypto.hash_utils import assert_hashes_equal
from utils.endianness import byteswap32

from stark_verifier.crypto.random import hash_elements


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

struct QueriesProof {
    length : felt,  // TODO: this is unneccessary overhead. All paths of a BatchMerkleProof have the same length
    digests : felt*,
}

struct QueriesProofs {
    proofs : QueriesProof*,
}

func _verify_merkle_proof{
    range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*
    }(depth: felt, path: felt*, position, root: felt*, accu: felt*){
    alloc_locals;
    if(depth == 0){
        assert_hashes_equal(root, accu);
        return ();
    }

    local lowest_bit;
    %{ ids.lowest_bit = ids.position & 1 %}
    // TODO: verify the hint. Otherwise, the position becomes arbitrary

    let (data: felt*) = alloc();
    if(lowest_bit != 0){
        memcpy(data + 8, accu, 8);
        memcpy(data, path, 8);
    } else {
        memcpy(data, accu, 8);
        memcpy(data + 8, path, 8);
    }

    let (digest) = blake2s_as_words(data=data, n_bytes=64);

    let position = (position - lowest_bit) / 2;
    _verify_merkle_proof(depth - 1, path + 8, position, root, digest);

    return ();
}

func verify_merkle_proof{
    range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*
    }(length: felt, path: felt*, position, root: felt*){
    alloc_locals;

    _verify_merkle_proof(length - 1, path + 8, position, root, path);

    return ();
}

func verify_merkle_proofs{
    range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*
}(proofs: QueriesProof*, positions: felt*, trace_roots: felt*, loop_counter, rows: felt*, n_cols: felt){
    if(loop_counter == 0){
        return ();
    }
    // Hash the row of the table at the current index and compare it to the leaf of the path
    let digest = hash_elements(n_elements=n_cols, elements=rows);
    assert_hashes_equal(digest, proofs[0].digests); 

    verify_merkle_proof( proofs[0].length, proofs[0].digests, positions[0], trace_roots );
    verify_merkle_proofs(&proofs[1], positions + 1, trace_roots, loop_counter - 1, rows + n_cols, n_cols);
    return ();
}

// AUX TRACE (Memory)
func verify_aux_merkle_proofs_1{
    range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*
}(proofs: QueriesProof*, positions: felt*, trace_roots: felt*, loop_counter, rows: felt*, n_cols: felt){
    if(loop_counter == 0){
        return ();
    }
    // Hash the row of the table at the current index and compare it to the leaf of the path
    let digest = hash_elements(n_elements=12, elements=rows);
    assert_hashes_equal(digest, proofs[0].digests);

    verify_merkle_proof( proofs[0].length, proofs[0].digests, positions[0], trace_roots );
    verify_aux_merkle_proofs_1(&proofs[1], positions + 1, trace_roots, loop_counter - 1, rows + n_cols, n_cols);
    return ();
}

// AUX TRACE (Range check)
func verify_aux_merkle_proofs_2{
    range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*
}(proofs: QueriesProof*, positions: felt*, trace_roots: felt*, loop_counter, rows: felt*, n_cols: felt){
    if(loop_counter == 0){
        return ();
    }
    // Hash the row of the table at the current index and compare it to the leaf of the path
    let digest = hash_elements(n_elements=6, elements=rows + 12);
    assert_hashes_equal(digest, proofs[0].digests);

    verify_merkle_proof( proofs[0].length, proofs[0].digests, positions[0], trace_roots );
    verify_aux_merkle_proofs_2(&proofs[1], positions + 1, trace_roots, loop_counter - 1, rows + n_cols, n_cols);
    return ();
}

func read_queried_trace_states{
    range_check_ptr, blake2s_ptr: felt*, channel: Channel, bitwise_ptr: BitwiseBuiltin*
    }(positions: felt*) -> (
    main_states: Table, aux_states: Table
) {
    alloc_locals;
    let (local trace_queries_proof_ptr: QueriesProofs*) = alloc();
    %{
        import json
        import subprocess
        from src.stark_verifier.utils import write_into_memory

        positions = []
        for i in range(54):
            positions.append( memory[ids.positions + i] )

        positions = json.dumps( positions )

        completed_process = subprocess.run([
            'bin/stark_parser',
            'tests/integration/stark_proofs/fibonacci.bin', # TODO: this path shouldn't be hardcoded!
            'trace-queries',
            positions
            ],
            capture_output=True)
        
        json_data = completed_process.stdout
        write_into_memory(ids.trace_queries_proof_ptr, json_data, segments)
    %}

    let num_queries = 4; // TODO: this should be 54, but it takes forever...

    let main_states = channel.trace_queries.main_states;
    let aux_states = channel.trace_queries.aux_states;

    // Authenticate proof paths
    verify_merkle_proofs(
        trace_queries_proof_ptr[0].proofs, positions, channel.trace_roots, num_queries, main_states.elements, main_states.n_cols);
    verify_aux_merkle_proofs_1(
        trace_queries_proof_ptr[1].proofs, positions, channel.trace_roots + 8, num_queries, aux_states.elements, aux_states.n_cols);
    verify_aux_merkle_proofs_2(
        trace_queries_proof_ptr[2].proofs, positions, channel.trace_roots + 8 * 2, num_queries, aux_states.elements, aux_states.n_cols);

    return (main_states, aux_states);
}



func read_constraint_evaluations{
    range_check_ptr, blake2s_ptr: felt*, channel: Channel, bitwise_ptr: BitwiseBuiltin*
    }(positions: felt*) -> Table {

    alloc_locals;
    let (local constraint_queries_proof_ptr: QueriesProofs*) = alloc();
    %{
        import json
        import subprocess
        from src.stark_verifier.utils import write_into_memory

        positions = []
        for i in range(54):
            positions.append( memory[ids.positions + i] )

        positions = json.dumps( positions )

        completed_process = subprocess.run([
            'bin/stark_parser',
            'tests/integration/stark_proofs/fibonacci.bin', # TODO: this path shouldn't be hardcoded!
            'constraint-queries',
            positions
            ],
            capture_output=True)
        
        json_data = completed_process.stdout
        write_into_memory(ids.constraint_queries_proof_ptr, json_data, segments)
    %}
    let num_queries = 4; // TODO: this should be 54, but it takes forever...

    // Authenticate proof paths
    let evaluations = channel.constraint_queries.evaluations;
    verify_merkle_proofs(
        constraint_queries_proof_ptr[0].proofs, positions, channel.constraint_root, num_queries, evaluations.elements, evaluations.n_cols);

    return evaluations;
}
