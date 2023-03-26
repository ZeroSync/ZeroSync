from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.cairo_blake2s.blake2s import blake2s_as_words
from starkware.cairo.common.math import unsigned_div_rem
from crypto.hash_utils import copy_hash, assert_hashes_not_equal, HASH_FELT_SIZE
from utils.serialize import UINT32_SIZE

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

from stark_verifier.parameters import FOLDING_FACTOR, NUM_QUERIES

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
    // Remainder
    remainder: Vec,
}

func channel_new{bitwise_ptr: BitwiseBuiltin*}(air: AirInstance, proof: StarkProof*) -> Channel {
    // Parsed commitments
    let trace_roots = proof.commitments.trace_roots;
    let constraint_root = proof.commitments.constraint_root;
    let fri_roots = proof.commitments.fri_roots;

    // Parsed ood_frame
    let ood_constraint_evaluations = proof.ood_frame.evaluations;
    let ood_trace_frame = TraceOodFrame(
        main_frame=proof.ood_frame.main_frame,
        aux_frame=proof.ood_frame.aux_frame,
    );

    let channel = Channel(
        trace_roots=trace_roots,
        constraint_root=constraint_root,
        fri_roots_len=proof.commitments.fri_roots_len,
        fri_roots=fri_roots,
        ood_trace_frame=ood_trace_frame,
        ood_constraint_evaluations=ood_constraint_evaluations,
        pow_nonce=proof.pow_nonce,
        trace_queries=&proof.trace_queries,
        constraint_queries=&proof.constraint_queries,
        remainder=proof.remainder
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
    }(depth: felt, path: felt*, position, accu: felt*) -> felt* {
    if(depth == 0){
        return accu;
    }
    alloc_locals;
    // Check if position is even or odd
    assert [bitwise_ptr].x = position;
    assert [bitwise_ptr].y = 1;
    let lowest_bit = [bitwise_ptr].x_and_y;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;

    let (data: felt*) = alloc();
    // Hash next two nodes depending on position is even or odd
    memcpy(data + HASH_FELT_SIZE * lowest_bit, accu, HASH_FELT_SIZE);
    memcpy(data + HASH_FELT_SIZE * (1 - lowest_bit), path, HASH_FELT_SIZE);

    let (digest) = blake2s_as_words(data=data, n_bytes=64);

    return _verify_merkle_proof(
        depth = depth - 1,
        path = path + HASH_FELT_SIZE,
        position = (position - lowest_bit) / 2,
        accu = digest
    );
}

func verify_merkle_proof{
    range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*
    }(length: felt, path: felt*, position, root: felt*){
    alloc_locals;

    let digest = _verify_merkle_proof(length - 1, path + HASH_FELT_SIZE, position, path);
    
    with_attr error_message("Merkle path authentication failed"){
        assert_hashes_equal(root, digest);
    }

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
        from src.stark_verifier.utils import read_queried_trace_states
        read_queried_trace_states(ids.positions, ids.trace_queries_proof_ptr, ids.NUM_QUERIES, memory, segments)
    %}

    let num_queries = NUM_QUERIES;
    let num_queries = 4; // TODO: this should be NUM_QUERIES, but it takes forever...

    let main_states = channel.trace_queries.main_states;
    let aux_states = channel.trace_queries.aux_states;

    // Authenticate proof paths
    verify_merkle_proofs(
        trace_queries_proof_ptr[0].proofs,
        positions,
        channel.trace_roots,
        num_queries,
        main_states.elements,
        main_states.n_cols
    );
    verify_aux_merkle_proofs_1(
        trace_queries_proof_ptr[1].proofs,
        positions,
        channel.trace_roots + HASH_FELT_SIZE,
        num_queries,
        aux_states.elements,
        aux_states.n_cols
    );
    verify_aux_merkle_proofs_2(
        trace_queries_proof_ptr[2].proofs,
        positions,
        channel.trace_roots + HASH_FELT_SIZE * 2,
        num_queries,
        aux_states.elements,
        aux_states.n_cols
    );

    return (main_states, aux_states);
}



func read_constraint_evaluations{
    range_check_ptr, blake2s_ptr: felt*, channel: Channel, bitwise_ptr: BitwiseBuiltin*
    }(positions: felt*) -> Table {

    alloc_locals;
    let (local constraint_queries_proof_ptr: QueriesProofs*) = alloc();
    %{
        from src.stark_verifier.utils import read_constraint_evaluations
        read_constraint_evaluations(ids.positions, ids.constraint_queries_proof_ptr, ids.NUM_QUERIES, memory, segments)
    %}
    let num_queries = NUM_QUERIES;
    let num_queries = 4; // TODO: this should be NUM_QUERIES, but it takes forever...

    // Authenticate proof paths
    let evaluations = channel.constraint_queries.evaluations;
    verify_merkle_proofs(
        constraint_queries_proof_ptr[0].proofs, 
        positions, 
        channel.constraint_root, 
        num_queries, 
        evaluations.elements, 
        evaluations.n_cols
    );

    return evaluations;
}



func read_remainder{
    range_check_ptr, channel: Channel, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*
    }() -> Vec {
    alloc_locals;
    let remainder = channel.remainder.elements;
    let loop_counter = channel.remainder.n_elements / FOLDING_FACTOR;
    let (remainder_values: felt**) = alloc();
    transpose_slice(remainder, remainder_values, loop_counter, loop_counter);

    // build remainder Merkle tree
    let (hashed_values: felt*) = alloc();
    hash_values(remainder_values, hashed_values, loop_counter);
    let root = compute_merkle_root(hashed_values, loop_counter);

    // Compare the root to the last fri_root
    let expected_root = channel.fri_roots + (channel.fri_roots_len-1) * HASH_FELT_SIZE;
    assert_hashes_equal(root, expected_root);

    return channel.remainder;
}

func transpose_slice(source: felt*, destination: felt**, loop_counter, destination_len){
    if(loop_counter == 0){
        return ();
    }
    let (row) = alloc();
    assert [destination] = row;

    tempvar row_ptr = row;
    tempvar src_ptr = source;
    tempvar n = FOLDING_FACTOR;
    transpose_loop:
        assert [row_ptr] = [src_ptr];
        tempvar row_ptr = row_ptr + 1;
        tempvar src_ptr = src_ptr + destination_len;
        tempvar n = n - 1;
    jmp transpose_loop if n != 0;

    return transpose_slice(source + 1, destination + 1, loop_counter - 1, destination_len);
}

func hash_values{
    range_check_ptr, blake2s_ptr: felt*, bitwise_ptr: BitwiseBuiltin*
    }(values: felt**, hashes: felt*, loop_counter){
    if(loop_counter == 0){
        return ();
    }
    alloc_locals;
    let digest = hash_elements(n_elements=FOLDING_FACTOR, elements=[values]);
    memcpy(hashes, digest, HASH_FELT_SIZE);
    return hash_values(values + 1, hashes + HASH_FELT_SIZE, loop_counter - 1);
}


// Compute the Merkle root hash of a set of hashes
func compute_merkle_root{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, blake2s_ptr: felt*}(
    leaves: felt*, leaves_len: felt
) -> felt* {
    alloc_locals;

    // The trivial case is a tree with a single leaf
    if (leaves_len == 1) {
        return leaves;
    }

    // Compute the next generation of leaves one level higher up in the tree
    let (next_leaves) = alloc();
    let next_leaves_len = (leaves_len) / 2;
    _compute_merkle_root_loop(leaves, next_leaves, next_leaves_len);

    // Ascend in the tree and recurse on the next generation one step closer to the root
    return compute_merkle_root(next_leaves, next_leaves_len);
}

// Compute the next generation of leaves by pairwise hashing
// the previous generation of leaves
func _compute_merkle_root_loop{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, blake2s_ptr: felt*}(
    prev_leaves: felt*, next_leaves: felt*, loop_counter
) {
    alloc_locals;

    // We loop until we've completed the next generation
    if (loop_counter == 0) {
        return ();
    }

    // Hash two prev_leaves to get one leaf of the next generation
    let (digest) = blake2s_as_words(data=prev_leaves, n_bytes=HASH_FELT_SIZE * 2 * UINT32_SIZE);
    copy_hash(digest, next_leaves);

    // Continue this loop with the next two prev_leaves
    return _compute_merkle_root_loop(
        prev_leaves + HASH_FELT_SIZE * 2, next_leaves + HASH_FELT_SIZE, loop_counter - 1
    );
}
