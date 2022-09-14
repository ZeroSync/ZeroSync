# Utreexo Accumulator
#
# The algorithms for `add_utxo` and `delete_utxo` are 
# described in [the Utreexo paper](https://eprint.iacr.org/2019/611.pdf).
#
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.cairo_builtins import HashBuiltin


struct Forest:
	member roots: felt*
	member leaves_count: felt 
end


func utreexo_add{range_check_ptr, hash_ptr: HashBuiltin*, forest: Forest}(hash):
	alloc_locals
	let (roots_out) = alloc()
	_utreexo_add_loop(hash, forest.leaves_count, forest.roots, roots_out)
	let forest = Forest(roots_out, forest.leaves_count + 1)
	return ()
end

func _utreexo_add_loop{range_check_ptr, hash_ptr: HashBuiltin*}(
	hash, leaves_count, roots_in: felt*, roots_out: felt*):
	alloc_locals

	if leaves_count == 0:
		if hash == 0:
			return ()
		end
	end

	let (leaves_count, bit) = unsigned_div_rem(leaves_count, 2)

	if hash == 0:
		if bit == 1:
			assert [roots_out] = [roots_in]
			_utreexo_add_loop(hash, leaves_count, roots_in + 1, roots_out + 1)
			return ()
		else: 
			_utreexo_add_loop(hash, leaves_count, roots_in, roots_out)
			return ()
		end
	else:
		if bit == 1:
			let (new_root) = hash2(hash, [roots_in])
			_utreexo_add_loop(new_root, leaves_count, roots_in + 1, roots_out)
			return ()
		else:
			assert [roots_out] = hash
			_utreexo_add_loop(0, leaves_count, roots_in, roots_out + 1)
			return ()
		end  
	end
end

