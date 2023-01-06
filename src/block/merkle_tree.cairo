// Compute Merkle Hash Trees
//
// See also:
// - Bitcoin Core https://github.com/bitcoin/bitcoin/blob/master/src/consensus/merkle.cpp
//

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from crypto.hash256 import hash256
from crypto.hash_utils import copy_hash, assert_hashes_not_equal, HASH_FELT_SIZE
from utils.serialize import UINT32_SIZE

// Compute the Merkle root hash of a set of hashes
// - https://github.com/bitcoin/bitcoin/issues/19598#issuecomment-693212439
func compute_merkle_root{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, sha256_ptr: felt*}(
    leaves: felt*, leaves_len: felt
) -> felt* {
    alloc_locals;

    // The trivial case is a tree with a single leaf
    if (leaves_len == 1) {
        return leaves;
    }

    // If the number of leaves is odd then duplicate the last leaf
    let (_, is_odd) = unsigned_div_rem(leaves_len, 2);
    if (is_odd == 1) {
        copy_hash(leaves + HASH_FELT_SIZE * (leaves_len - 1), leaves + HASH_FELT_SIZE * leaves_len);
    } else {
        // CVE-2012-2459 bug fix
        with_attr error_message("unexpected node duplication in merkle tree") {
            assert_hashes_not_equal(
                leaves + (leaves_len - 1) * HASH_FELT_SIZE,
                leaves + (leaves_len - 2) * HASH_FELT_SIZE,
            );
        }
    }

    // Compute the next generation of leaves one level higher up in the tree
    let (next_leaves) = alloc();
    let next_leaves_len = (leaves_len + is_odd) / 2;
    _compute_merkle_root_loop(leaves, next_leaves, next_leaves_len);

    // Ascend in the tree and recurse on the next generation one step closer to the root
    return compute_merkle_root(next_leaves, next_leaves_len);
}

// Compute the next generation of leaves by pairwise hashing
// the previous generation of leaves
func _compute_merkle_root_loop{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, sha256_ptr: felt*}(
    prev_leaves: felt*, next_leaves: felt*, loop_counter
) {
    alloc_locals;

    // We loop until we've completed the next generation
    if (loop_counter == 0) {
        return ();
    }

    // Hash two prev_leaves to get one leave of the next generation
    let hash = hash256(prev_leaves, HASH_FELT_SIZE * UINT32_SIZE * 2);
    copy_hash(hash, next_leaves);

    // Continue this loop with the next two prev_leaves
    return _compute_merkle_root_loop(
        prev_leaves + HASH_FELT_SIZE * 2, next_leaves + HASH_FELT_SIZE, loop_counter - 1
    );
}
