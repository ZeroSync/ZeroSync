from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import unsigned_div_rem, assert_le
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.hash import hash2
from utils.pow2 import pow2

func compute_merkle_root_pedersen{range_check_ptr, hash_ptr: HashBuiltin*}(
    leaves: felt*, leaves_len: felt
) -> felt {
    alloc_locals;

    // The trivial case is a tree with a single leaf
    if (leaves_len == 1) {
        return leaves[0];
    }

    // TODO: Figure out if this allows attackers to create wrong merkle trees
    // If the number of leaves is odd then set the last leaf to 0
    let (_, is_odd) = unsigned_div_rem(leaves_len, 2);
    if (is_odd == 1) {
        assert leaves[leaves_len] = 0;
    }

    // Compute the next generation of leaves one level higher up in the tree
    let (next_leaves) = alloc();
    let next_leaves_len = (leaves_len + is_odd) / 2;
    _compute_merkle_root_pedersen_loop(leaves, next_leaves, next_leaves_len);

    // Ascend in the tree and recurse on the next generation one step closer to the root
    return compute_merkle_root_pedersen(next_leaves, next_leaves_len);
}

// starting leaves contains first node of the merkle_path if necessary
// (so the merkle path is one entry shorter than it actually is)
// old_merkle_path[x] is zero if the node of the path is not required for recalculating level x
func append_merkle_tree_pedersen{range_check_ptr, hash_ptr: HashBuiltin*}(
    leaves: felt*, leaves_len: felt, merkle_path: felt*, merkle_path_len
) -> felt {
    alloc_locals;

    // The trivial case is a tree with a single leaf
    if (leaves_len == 1) {
        if (merkle_path_len == 0) {
            return leaves[0];
        } else {
            // Hash with the final part of the merkle_path
        }
    }

    // TODO: Figure out if this allows attackers to create wrong merkle trees
    // If the number of leaves is odd then set the last leaf to 0
    let (_, is_odd) = unsigned_div_rem(leaves_len, 2);
    if (is_odd == 1) {
        assert leaves[leaves_len] = 0;
    }

    let (next_leaves) = alloc();
    let next_leaves_len = (leaves_len + is_odd) / 2;

    // If the Merkle path is empty continue to hash without merkle_path
    if (merkle_path_len == 0) {
        // Compute the next generation of leaves one level higher up in the tree
        _compute_merkle_root_pedersen_loop(leaves, next_leaves, next_leaves_len);
        // Ascend in the tree and recurse on the next generation one step closer to the root
        return append_merkle_tree_pedersen(next_leaves, next_leaves_len, merkle_path, 0);
    }
    if (merkle_path[0] == 0) {
        _compute_merkle_root_pedersen_loop(leaves, next_leaves, next_leaves_len);
        return append_merkle_tree_pedersen(
            next_leaves, next_leaves_len, merkle_path + 1, merkle_path_len - 1
        );
    }
    // Put the merkle_path entry for the next level into next_leaves
    assert next_leaves[0] = merkle_path[0];
    // Compute the next generation of leaves one level higher up in the tree
    // Account for the already filled position 0 in next_leaves
    _compute_merkle_root_pedersen_loop(leaves, next_leaves + 1, next_leaves_len);
    return append_merkle_tree_pedersen(
        next_leaves, next_leaves_len + 1, merkle_path + 1, merkle_path_len - 1
    );
}

// Compute the next generation of leaves by pairwise hashing
// the previous generation of leaves
func _compute_merkle_root_pedersen_loop{range_check_ptr, hash_ptr: HashBuiltin*}(
    prev_leaves: felt*, next_leaves: felt*, loop_counter
) {
    alloc_locals;

    // We loop until we've completed the next generation
    if (loop_counter == 0) {
        return ();
    }

    // Hash two prev_leaves to get one leaf of the next generation
    let (hash) = hash2(prev_leaves[0], prev_leaves[1]);
    assert next_leaves[0] = hash;
    // Continue this loop with the next two prev_leaves
    return _compute_merkle_root_pedersen_loop(prev_leaves + 2, next_leaves + 1, loop_counter - 1);
}

// Verify the merkle_path_len and merkle_path for the lowest 0 node in the tree.
// (Verifying the merkle_path_len enforces the 0 node to be the lowest one in the tree)
// In case no 0 node exists the tree was complete.
func verify_merkle_path_zero{hash_ptr: HashBuiltin*, range_check_ptr}(
    merkle_path: felt*, merkle_path_len, merkle_root, old_leaves_len
) {
    alloc_locals;
    let expected_merkle_path_len = calculate_merkle_path_len(old_leaves_len);
    assert expected_merkle_path_len = merkle_path_len;
    verify_merkle_path(0, merkle_path, merkle_path_len, merkle_root);
    return ();
}

// NOTE: This function is used in a setting where the only proof we check is of the right most leaf.
// Therefore, we assume that every hash in the tree has every non-zero merkle path entry as a left leave.
func verify_merkle_path{hash_ptr: HashBuiltin*}(
    element, merkle_path: felt*, merkle_path_len, merkle_root
) {
    if (merkle_path_len == 0) {
        assert element = merkle_root;
        return ();
    }
    if (merkle_path[0] == 0) {
        let (new_element) = hash2(element, merkle_path[0]);
    } else {
        let (new_element) = hash2(merkle_path[0], element);
    }
    verify_merkle_path(new_element, merkle_path + 1, merkle_path_len - 1, merkle_root);

    return ();
}

func calculate_height{range_check_ptr}(len) -> felt {
    alloc_locals;
    local height: felt;
    %{
        import math
        ids.height = math.ceil(math.log2(ids.len))
    %}
    // check that the calculated height is correct
    // len > 2**(h-1)
    if (height == 0) {
        tempvar range_check_ptr = range_check_ptr;
    } else {
        let len_lower_bound = pow2(height - 1);
        assert_le(len_lower_bound, len - 1);
        tempvar range_check_ptr = range_check_ptr;
    }
    // len <= 2 ** h
    let len_upper_bound = pow2(height);
    assert_le(len, len_upper_bound);

    return height;
}

// Calculate the length of a Merkle path for the lowest 0 node
// in a Merkle tree with leaves_len leaves
func calculate_merkle_path_len{range_check_ptr}(leaves_len) -> felt {
    if (leaves_len == 1) {
        return 0;
    }

    let (_, is_odd) = unsigned_div_rem(leaves_len, 2);
    if (is_odd == 1) {
        // The first 0 node is at this level - start counting the next levels
        let count = count_remaining_levels((leaves_len + is_odd) / 2);
        return count + 1;  // Add one for the current level
    }
    return calculate_merkle_path_len(leaves_len / 2);
}

func count_remaining_levels{range_check_ptr}(leaves_len) -> felt {
    if (leaves_len == 1) {
        return 0;
    }
    let (_, is_odd) = unsigned_div_rem(leaves_len, 2);
    let count = count_remaining_levels((leaves_len + is_odd) / 2);
    return 1 + count;
}
