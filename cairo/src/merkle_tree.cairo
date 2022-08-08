from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.alloc import alloc
from utils import _compute_double_sha256, copy_hash, HASH_LEN
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

func compute_merkle_root{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(leaves : felt*, leaves_len : felt) -> (hash : felt*):
	alloc_locals

	# The trivial case is a tree with a single leaf
	if leaves_len == 1:
	 	let (root_hash) = _compute_double_sha256(HASH_LEN, leaves, HASH_LEN * 4)
	end
	
	# If the number of leaves is odd then duplicate the last leaf
	let (_, is_odd) = unsigned_div_rem(leaves_len, 2)
	if is_odd == 1:
		copy_hash(leaves + HASH_LEN * (leaves_len - 1), leaves + HASH_LEN * leaves_len)
	end

	# Compute the next generation of leaves one level higher up in the tree
	let (next_leaves) = alloc()
	let next_leaves_len = (leaves_len + is_odd) / 2
	_compute_merkle_root_loop(leaves, next_leaves, next_leaves_len, 0)

	# Ascend in the tree and hash the next generation
	return compute_merkle_root(next_leaves, next_leaves_len)
end

func _compute_merkle_root_loop{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
	leaves : felt*, next_leaves : felt*, next_leaves_len : felt, index : felt):

	# We're done when we've computed the entire next generation
	if index == next_leaves_len:
		return ()
	end

	# Hash two leaves to get a node of the next generation
	let (hash) = _compute_double_sha256(2 * HASH_LEN, leaves, 2 * HASH_LEN * 4)
	copy_hash(hash, next_leaves)

	# Continue this loop with the next two leaves
	return _compute_merkle_root_loop(leaves + 2 * HASH_LEN, next_leaves + HASH_LEN, next_leaves_len, index + 1)
end
