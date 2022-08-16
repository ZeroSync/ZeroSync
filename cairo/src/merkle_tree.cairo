# Compute Merkle Hash Trees
#
# See also:
# - Bitcoin Core https://github.com/bitcoin/bitcoin/blob/master/src/consensus/merkle.cpp
# 
# TODOs:
# - Fix CVE-2012-2459

from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.alloc import alloc
from utils import sha256d, copy_hash, HASH_SIZE, HASH_FELT_SIZE
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

# Compute the Merkle root hash of a set of hashes
func compute_merkle_root{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
	leaves : felt*, leaves_len : felt) -> (hash : felt*):
	alloc_locals

	# The trivial case is a tree with a single leaf
	if leaves_len == 1:
	 	return (leaves)
	end
	
	# If the number of leaves is odd then duplicate the last leaf
	let (_, is_odd) = unsigned_div_rem(leaves_len, 2)
	if is_odd == 1:
		copy_hash(leaves + HASH_FELT_SIZE * (leaves_len - 1), leaves + HASH_FELT_SIZE * leaves_len)
	end

	# Compute the next generation of leaves one level higher up in the tree
	let (next_leaves) = alloc()
	let next_leaves_len = (leaves_len + is_odd) / 2
	_compute_merkle_root_loop(leaves, next_leaves, next_leaves_len)

	# Ascend in the tree and recurse on the next generation one step closer to the root
	return compute_merkle_root(next_leaves, next_leaves_len)
end

# Compute the next generation of leaves by pairwise hashing the current generation
func _compute_merkle_root_loop{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
	leaves : felt*, next_leaves : felt*, loop_counter):
	alloc_locals
	
	# We loop until we've completed the next generation
	if loop_counter == 0:
		return ()
	end

	# Hash two leaves to get a node of the next generation
	let (hash) = sha256d(leaves, 2 * HASH_SIZE)
	copy_hash(hash, next_leaves)

	# Continue this loop with the next two leaves
	return _compute_merkle_root_loop(leaves + 2 * HASH_FELT_SIZE, next_leaves + HASH_FELT_SIZE, loop_counter - 1)
end
