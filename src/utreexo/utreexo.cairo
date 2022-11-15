// Utreexo Accumulator
//
// The algorithms for `utreexo_add` and `utreexo_delete` are
// described in [the Utreexo paper](https://eprint.iacr.org/2019/611.pdf).
//
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.memset import memset

const UTREEXO_ROOTS_LEN = 27;  // ~ log2( 70,000,000 UTXOs )

func utreexo_init() -> felt* {
    alloc_locals;
    let (utreexo_roots) = alloc();
    memset(utreexo_roots, 0, UTREEXO_ROOTS_LEN);
    return utreexo_roots;
}

func utreexo_add{hash_ptr: HashBuiltin*, utreexo_roots: felt*}(leaf) {
    alloc_locals;
    let (roots_out) = alloc();
    _utreexo_add_loop(utreexo_roots, roots_out, leaf, 0);
    let utreexo_roots = roots_out;
    return ();
}

func _utreexo_add_loop{hash_ptr: HashBuiltin*}(roots_in: felt*, roots_out: felt*, n, h) {
    alloc_locals;

    let r = roots_in[h];

    if (r == 0) {
        assert roots_out[h] = n;
        let h = h + 1;
        memcpy(roots_out + h, roots_in + h, UTREEXO_ROOTS_LEN - h);
        return ();
    }

    let (n) = hash2(r, n);

    assert roots_out[h] = 0;

    return _utreexo_add_loop(roots_in, roots_out, n, h + 1);
}

func utreexo_delete{hash_ptr: HashBuiltin*, utreexo_roots: felt*}(
    leaf, leaf_index, proof: felt*, proof_len
) {
    alloc_locals;

    utreexo_prove_inclusion(utreexo_roots, leaf, leaf_index, proof, proof_len);

    let (roots_out) = alloc();
    _utreexo_delete_loop(utreexo_roots, roots_out, proof, proof_len, 0, 0);
    let utreexo_roots = roots_out;
    return ();
}

func _utreexo_delete_loop{hash_ptr: HashBuiltin*}(
    roots_in: felt*, roots_out: felt*, proof: felt*, proof_len, n, h
) {
    if (h == proof_len) {
        assert roots_out[h] = n;
        let h = h + 1;
        memcpy(roots_out + h, roots_in + h, UTREEXO_ROOTS_LEN - h);
        return ();
    }

    let p = proof[h];

    if (n != 0) {
        let (n) = hash2(p, n);

        assert roots_out[h] = roots_in[h];
        return _utreexo_delete_loop(roots_in, roots_out, proof, proof_len, n, h + 1);
    }

    if (roots_in[h] == 0) {
        assert roots_out[h] = p;
        return _utreexo_delete_loop(roots_in, roots_out, proof, proof_len, n, h + 1);
    }

    let (n) = hash2(p, roots_in[h]);
    assert roots_out[h] = 0;
    return _utreexo_delete_loop(roots_in, roots_out, proof, proof_len, n, h + 1);
}

func utreexo_prove_inclusion{hash_ptr: HashBuiltin*}(
    utreexo_roots: felt*, leaf, leaf_index, proof: felt*, proof_len
) {
    let proof_root = _utreexo_prove_inclusion_loop(proof, proof_len, leaf_index, leaf);
    with_attr error_message("The leaf {leaf} is not included in the Utreexo set.") {
        assert utreexo_roots[proof_len] = proof_root;
    }
    return ();
}

func _utreexo_prove_inclusion_loop{hash_ptr: HashBuiltin*}(
    proof: felt*, proof_len, index, prev_node
) -> felt {
    if (proof_len == 0) {
        return prev_node;
    }

    alloc_locals;
    local next_index;
    local lowest_bit;
    %{
        ids.lowest_bit = ids.index & 1
        ids.next_index = (ids.index - ids.lowest_bit) // 2
    %}

    if (lowest_bit == 0) {
        let (next_node) = hash2(prev_node, [proof]);
    } else {
        let (next_node) = hash2([proof], prev_node);
    }

    return _utreexo_prove_inclusion_loop(proof + 1, proof_len - 1, next_index, next_node);
}

// Returns the inclusion proof for a leaf
func fetch_inclusion_proof(leaf) -> (leaf_index: felt, proof: felt*, proof_len: felt) {
    alloc_locals;
    local leaf_index;
    let (proof) = alloc();
    local proof_len;

    %{
        hex_hash = hex(ids.leaf).replace('0x','')
        # print('>> Delete hash from utreexo DB', hex_hash) 
        # import urllib3
        http = urllib3.PoolManager()
        url = 'http://localhost:2121/delete/' + hex_hash
        r = http.request('GET', url)

        import json
        response = json.loads(r.data)

        print('UTREEXO: Inclusion proof:\n',response)

        ids.leaf_index = response['leaf_index']
        proof = list(map(lambda hash_hex: int(hash_hex, 16), response['proof']))
        segments.write_arg(ids.proof, proof)
        ids.proof_len = len(proof)
    %}

    return (leaf_index, proof, proof_len);
}
