# Utreexo Accumulator
#
# The algorithms for `add_utxo` and `delete_utxo` are 
# described in [the Utreexo paper](https://eprint.iacr.org/2019/611.pdf).
#
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.memset import memset


const UTREEXO_ROOTS_LEN = 25

func init_forest() -> (forest:felt*):
	alloc_locals
	let (forest) = alloc()
	memset(forest, 0, UTREEXO_ROOTS_LEN)
	return (forest)
end


# TODO: do we have to sanitize `leaf != 0` here?
func utreexo_add{range_check_ptr, hash_ptr: HashBuiltin*, forest: felt*}(leaf):
	alloc_locals
	let (roots_out) = alloc()
	_utreexo_add_loop(forest, roots_out, leaf, 0)
	let forest = roots_out
	return ()
end

func _utreexo_add_loop{range_check_ptr, hash_ptr: HashBuiltin*}(
	roots_in: felt*, roots_out: felt*, n, h):
	alloc_locals

	let r = roots_in[h]

	if r == 0:
		assert roots_out[h] = n
		memcpy(roots_out + h + 1, roots_in + h + 1, UTREEXO_ROOTS_LEN - h - 1)
		return ()
	end

	let (n) = hash2(r, n)
	assert roots_out[h] = 0

	return _utreexo_add_loop(roots_in, roots_out, n, h + 1)
end



func utreexo_delete{range_check_ptr, hash_ptr: HashBuiltin*, forest: felt*}(
	proof: felt*, proof_len, index, leaf):
	alloc_locals
	utreexo_prove_inclusion(forest, proof, proof_len, index, leaf)
	
	let (roots_out) = alloc()
	_utreexo_delete_loop(forest, roots_out, proof, proof_len, 0, 0)
	let forest = roots_out
	return ()
end


func _utreexo_delete_loop{hash_ptr: HashBuiltin*}(
	roots_in: felt*, roots_out: felt*, proof: felt*, proof_len, n, h):

	if h == proof_len:
		assert roots_out[h] = n
		memcpy(roots_out + h + 1, roots_in + h + 1, UTREEXO_ROOTS_LEN - h - 1)
		return ()
	end

	let p = proof[h]

	if n != 0:
		let (n) = hash2(p, n)
		return _utreexo_delete_loop(roots_in, roots_out, proof, proof_len, n, h + 1)
	end

	if roots_in[h] == 0:
		assert roots_out[h] = p
		return _utreexo_delete_loop(roots_in, roots_out, proof, proof_len, n, h + 1)
	end

	let (n) = hash2(p, roots_in[h])
	assert roots_out[h] = 0
	return _utreexo_delete_loop(roots_in, roots_out, proof, proof_len, n, h + 1)
end


func utreexo_prove_inclusion{range_check_ptr, hash_ptr: HashBuiltin*}(
	forest: felt*, proof: felt*, proof_len, index, leaf):
	alloc_locals

	let (root) = _utreexo_prove_inclusion_loop(proof, proof_len, index, leaf)

	local root_index

	%{ 
        import math
        ids.root_index = math.ceil( math.log(ids.index, 2) ) + 1 
    %}

	assert forest[root_index] = root
	return ()
end


func _utreexo_prove_inclusion_loop{range_check_ptr, hash_ptr: HashBuiltin*}(
	proof: felt*, proof_len, index, prev_node) -> (root):
	if proof_len == 0:
		return (prev_node)
	end

	let (index, bit) = unsigned_div_rem(index, 2)

	if bit == 0:
		let (next_node) = hash2(prev_node, [proof])
	else:
		let (next_node) = hash2([proof], prev_node)
	end
	
	return _utreexo_prove_inclusion_loop(proof + 1, proof_len - 1, index, next_node)

end



