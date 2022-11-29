

from starkware.cairo.common.memcpy import memcpy

from serialize.serialize import UINT32_SIZE

const HASH_FELT_SIZE = 8;

// Copy a hash represented as an array of 8 x Uint32.
// It reads from `source` and writes to `destination`
func copy_hash(source: felt*, destination: felt*) {
    memcpy(destination, source, HASH_FELT_SIZE);
    return ();
}

// Assert equality of two hashes represented as an array of 8 x Uint32
//
func assert_hashes_equal(hash1: felt*, hash2: felt*) {
    // We're doing some odd gymnastics here,
    // because in Cairo it isn't straight-forward to determine if a variable is uninitialized.
    // The hack `assert 0 = a - b` ensures that both `a` and `b` are initialized.
    assert 0 = hash1[0] - hash2[0];
    assert 0 = hash1[1] - hash2[1];
    assert 0 = hash1[2] - hash2[2];
    assert 0 = hash1[3] - hash2[3];
    assert 0 = hash1[4] - hash2[4];
    assert 0 = hash1[5] - hash2[5];
    assert 0 = hash1[6] - hash2[6];
    assert 0 = hash1[7] - hash2[7];
    return ();
}

func assert_hashes_not_equal(hash1: felt*, hash2: felt*) {
    return _assert_hashes_not_equal_loop(hash1, hash2, HASH_FELT_SIZE);
}

func _assert_hashes_not_equal_loop(hash1_ptr: felt*, hash2_ptr: felt*, length) {
    if (length == 0) {
        assert 1 = 0;
        return ();
    }
    if ([hash1_ptr] != [hash2_ptr]) {
        return ();
    }
    return _assert_hashes_not_equal_loop(hash1_ptr + 1, hash2_ptr + 1, length - 1);
}
