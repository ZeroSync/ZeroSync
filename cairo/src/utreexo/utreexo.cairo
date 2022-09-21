# Utreexo Accumulator
#
# The algorithms for `utreexo_add` and `utreexo_delete` are 
# described in [the Utreexo paper](https://eprint.iacr.org/2019/611.pdf).
#
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.memset import memset


const UTREEXO_ROOTS_LEN = 27 # ~ log2( 70,000,000 UTXOs )


func utreexo_init() -> (utreexo_roots:felt*):
	alloc_locals
	let (utreexo_roots) = alloc()
	memset(utreexo_roots, 0, UTREEXO_ROOTS_LEN)
	return (utreexo_roots)
end


func utreexo_add{hash_ptr: HashBuiltin*, utreexo_roots: felt*}(leaf):
	alloc_locals
	let (roots_out) = alloc()
	_utreexo_add_loop(utreexo_roots, roots_out, leaf, 0)
	let utreexo_roots = roots_out
	return ()
end


func _utreexo_add_loop{hash_ptr: HashBuiltin*}(
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


func utreexo_delete{hash_ptr: HashBuiltin*, utreexo_roots: felt*}(
	leaf, leaf_index, proof: felt*, proof_len):
	alloc_locals

	utreexo_prove_inclusion(utreexo_roots, leaf, leaf_index, proof, proof_len)
	
	let (roots_out) = alloc()
	_utreexo_delete_loop(utreexo_roots, roots_out, proof, proof_len, 0, 0)
	let utreexo_roots = roots_out
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


func utreexo_prove_inclusion{hash_ptr: HashBuiltin*}(
	utreexo_roots: felt*, leaf, leaf_index, proof: felt*, proof_len):
	alloc_locals

	let (proof_root) = _utreexo_prove_inclusion_loop(proof, proof_len, leaf_index, leaf)

	local root_index
	%{
        root_index = 0
        bit = 1
        index = 0
        while root_index < ids.UTREEXO_ROOTS_LEN:
            if memory[ids.utreexo_roots + root_index] != 0:
                if index + bit < ids.leaf_index:
                    break
                index += bit
            bit *= 2
            root_index += 1

        ids.root_index = root_index 
    %}

	assert utreexo_roots[root_index] = proof_root
	return ()
end


func _utreexo_prove_inclusion_loop{hash_ptr: HashBuiltin*}(
	proof: felt*, proof_len, index, prev_node) -> (proof_root):
	
	if proof_len == 0:
		return (prev_node)
	end

	alloc_locals
	local next_index
	local lowest_bit
	%{
        ids.lowest_bit = ids.index & 1
        ids.next_index = (ids.index - ids.lowest_bit) // 2
    %}

	if lowest_bit == 0:
		let (next_node) = hash2([proof], prev_node)
	else:
		let (next_node) = hash2(prev_node, [proof])
	end
	
	return _utreexo_prove_inclusion_loop(proof + 1, proof_len - 1, next_index, next_node)
end



# Returns the inclusion proof for a leaf
func fetch_inclusion_proof(leaf) -> (leaf_index, proof:felt*, proof_len):
	alloc_locals
	local leaf_index
	let (proof) = alloc()
	local proof_len

	%{
        hex_hash = hex(ids.leaf).replace('0x','')
        # print('>> Delete hash from utreexo DB', hex_hash) 
        # import urllib3
        http = urllib3.PoolManager()
        url = 'http://localhost:2121/delete/' + hex_hash
        r = http.request('GET', url)

        import json
        response = json.loads(r.data)
        
        print('inclusion proof:\n',response)

        ids.leaf_index = response['leaf_index']
        proof = list(map(lambda hash_hex: int(hash_hex, 16), response['proof']))
        segments.write_arg(ids.proof, proof)
        ids.proof_len = len(proof)
    %}

    return (leaf_index, proof, proof_len)
end