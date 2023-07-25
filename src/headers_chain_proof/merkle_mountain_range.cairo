from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.memset import memset

const MMR_ROOTS_LEN = 27;  // ~ log2( 100,000,000 headers )


func mmr_add{hash_ptr: HashBuiltin*, mmr_roots: felt*}(leaf) {
    alloc_locals;
    let (roots_out) = alloc();
    _mmr_add_loop(mmr_roots, roots_out, leaf, 0);
    let mmr_roots = roots_out;
    return ();
}

func _mmr_add_loop{hash_ptr: HashBuiltin*}(roots_in: felt*, roots_out: felt*, n, h) {
    alloc_locals;

    let r = roots_in[h];

    if (r == 0) {
        assert roots_out[h] = n;
        let h = h + 1;
        memcpy(roots_out + h, roots_in + h, MMR_ROOTS_LEN - h);
        return ();
    }

    let (n) = hash2(r, n);

    assert roots_out[h] = 0;

    return _mmr_add_loop(roots_in, roots_out, n, h + 1);
}


func mmr_add_leaves{hash_ptr: HashBuiltin*, mmr_roots: felt*}(leaves: felt*, n_leaves) {
    if (n_leaves == 0) {
        return ();
    }
    alloc_locals;
    mmr_add([leaves]);
    return mmr_add_leaves(leaves + 1, n_leaves-1);
}
