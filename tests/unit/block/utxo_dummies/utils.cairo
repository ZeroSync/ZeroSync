from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

from utxo_set.utreexo import utreexo_init, utreexo_add

// Insert elements into the UTXO set to consume them in a block test
func dummy_utxo_insert{hash_ptr: HashBuiltin*, utreexo_roots: felt*}(hash) {
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

func dummy_utxo_insert_batch{hash_ptr: HashBuiltin*, utreexo_roots: felt*}(
    hashes: felt*, hashes_end: felt*
) {
    if (hashes == hashes_end) {
        dummy_utxo_insert(hashes[0]);
        return ();
    }
    dummy_utxo_insert(hashes[0]);
    return dummy_utxo_insert_batch(hashes + 1, hashes_end);
}

func dummy_utxo_insert_block_number{hash_ptr: HashBuiltin*, utreexo_roots: felt*}(
    block_number: felt
) {
    alloc_locals;
    let (hashes: felt*) = alloc();
    local hashes_len: felt;
    %{
        import json
        import os
        path = os.getcwd() + "/tests/unit/block/utxo_dummies/block_" + str(ids.block_number) + ".json"
        file = open(path, 'r')
        utxo_hashes = json.load(file)
        segments.write_arg(ids.hashes, utxo_hashes)
        ids.hashes_len = len(utxo_hashes)
    %}
    dummy_utxo_insert_batch(hashes, hashes + hashes_len - 1);
    return ();
}

// Flash the UTXO set of the bridge node
func reset_bridge_node() {
    %{
        import urllib3
        http = urllib3.PoolManager()
        url = 'http://localhost:2121/reset/'
        r = http.request('GET', url)
    %}
    return ();
}
