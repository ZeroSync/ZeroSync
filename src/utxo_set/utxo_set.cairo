from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.hash import hash2

from crypto.sha256d.sha256d import HASH_FELT_SIZE
from utils.python_utils import setup_python_defs
from utreexo.utreexo import utreexo_add, utreexo_delete, fetch_inclusion_proof

// TODO: Clean up all the copy pasta. This entire file looks like code smell.

func utxo_set_insert{range_check_ptr, hash_ptr: HashBuiltin*, utreexo_roots: felt*}(
    txid: felt*, vout, amount, script_pub_key: felt*, script_pub_key_size
) {
    alloc_locals;

    let (script_pub_key_len, _) = unsigned_div_rem(script_pub_key_size + 3, 4);
    let (local hash) = hash_output(txid, vout, amount, script_pub_key, script_pub_key_len);

    %{
        import urllib3
        http = urllib3.PoolManager()
        hex_hash = hex(ids.hash).replace('0x','')
        url = 'http://localhost:2121/add/' + hex_hash
        r = http.request('GET', url)
    %}

    utreexo_add(hash);
    return ();
}

func utxo_set_extract{hash_ptr: HashBuiltin*, utreexo_roots: felt*}(txid: felt*, vout) -> (
    amount: felt, script_pub_key: felt*, script_pub_key_len: felt
) {
    alloc_locals;

    local amount;
    local script_pub_key_size;
    local script_pub_key_len;
    let (script_pub_key) = alloc();

    setup_python_defs();
    %{
        txid = hash_from_memory(ids.txid) 

        import urllib3
        http = urllib3.PoolManager()
        url = 'https://blockstream.info/api/tx/' + txid
        r = http.request('GET', url)

        import json
        tx = json.loads(r.data)
        tx_output = tx["vout"][ids.vout]

        ids.amount = tx_output["value"]

        byte_size, felt_size = from_hex( tx_output["scriptpubkey"], ids.script_pub_key)
        ids.script_pub_key_len = felt_size
        ids.script_pub_key_size = byte_size
        print('UTXOSET extract:', 'txid', txid, 'vout', ids.vout, 'amount', ids.amount, 'script_pub_key_size', ids.script_pub_key_size)
    %}

    let (prevout_hash) = hash_output(txid, vout, amount, script_pub_key, script_pub_key_len);

    let (leaf_index, proof, proof_len) = fetch_inclusion_proof(prevout_hash);

    // Prove inclusion and delete from accumulator
    utreexo_delete(prevout_hash, leaf_index, proof, proof_len);

    return (amount, script_pub_key, script_pub_key_len);
}

func hash_output{hash_ptr: HashBuiltin*}(
    txid: felt*, vout, amount, script_pub_key: felt*, script_pub_key_len
) -> (hash: felt) {
    alloc_locals;
    let (script_pub_key_hash) = hash_chain(script_pub_key, script_pub_key_len);
    let (txid_hash) = hash_chain(txid, HASH_FELT_SIZE);
    let (tmp1) = hash2(amount, script_pub_key_hash);
    let (tmp2) = hash2(vout, tmp1);
    let (hash) = hash2(txid_hash, tmp2);
    return (hash,);
}

// Computes a hash chain of a sequence whose length is given at [data_ptr] and the data starts at
// data_ptr. The hash is calculated backwards (from the highest memory address to the lowest).
// For example, for the 3-element sequence [x, y, z] the hash is:
//   h(3, h(x, h(y, z)))
// If data_length = 0, the function does not return (takes more than field prime steps).
func hash_chain{hash_ptr: HashBuiltin*}(data_ptr: felt*, data_length) -> (hash: felt) {
    struct LoopLocals {
        data_ptr: felt*,
        hash_ptr: HashBuiltin*,
        cur_hash: felt,
    }

    tempvar data_ptr_end = data_ptr + data_length - 1;
    // Prepare the loop_frame for the first iteration of the hash_loop.
    tempvar loop_frame = LoopLocals(
        data_ptr=data_ptr_end,
        hash_ptr=hash_ptr,
        cur_hash=[data_ptr_end]);

    hash_loop:
    let curr_frame = cast(ap - LoopLocals.SIZE, LoopLocals*);
    let current_hash: HashBuiltin* = curr_frame.hash_ptr;

    tempvar new_data = [curr_frame.data_ptr - 1];

    let n_elements_to_hash = [ap];
    // Assign current_hash inputs and allocate space for n_elements_to_hash.
    current_hash.x = new_data, ap++;
    current_hash.y = curr_frame.cur_hash;

    // Set the frame for the next loop iteration (going backwards).
    tempvar next_frame = LoopLocals(
        data_ptr=curr_frame.data_ptr - 1,
        hash_ptr=curr_frame.hash_ptr + HashBuiltin.SIZE,
        cur_hash=current_hash.result);

    // Update n_elements_to_hash and loop accordingly. Note that the hash is calculated backwards.
    n_elements_to_hash = next_frame.data_ptr - data_ptr;
    jmp hash_loop if n_elements_to_hash != 0;

    // Set the hash_ptr implicit argument and return the result.
    let hash_ptr = next_frame.hash_ptr;
    return (hash=next_frame.cur_hash);
}
