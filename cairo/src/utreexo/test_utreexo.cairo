#
# To run only this test suite use:
# protostar test  --cairo-path=./src target src/**/*_utreexo*
#
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin

from utreexo.utreexo import utreexo_add, utreexo_delete, utreexo_init


@external
func test_utreexo_basics{range_check_ptr, pedersen_ptr: HashBuiltin*}():
	alloc_locals

	let (utreexo_roots) = utreexo_init()

	utreexo_add{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x111111111111111111111111)
	assert 0x111111111111111111111111 = utreexo_roots[0]

	utreexo_add{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x222222222222222222222222)
	assert 0 = utreexo_roots[0]
	assert 0x1b586e993478db71562f0cfe2ad81ccc463b0d18e64bde2fc825530714d8328 = utreexo_roots[1]
	
	utreexo_add{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x333333333333333333333333)
	assert 0x333333333333333333333333 = utreexo_roots[0]
	assert 0x1b586e993478db71562f0cfe2ad81ccc463b0d18e64bde2fc825530714d8328 = utreexo_roots[1]

	utreexo_add{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x444444444444444444444444)
	assert 0 = utreexo_roots[0]
	assert 0 = utreexo_roots[1]
	assert 0x155d0053a90471bdcccd6f93c7bcea38a8e4dddb190077568fb8514cf9f3392 = utreexo_roots[2]

	let (inclusion_proof) = alloc()
	assert inclusion_proof[0] = 0x444444444444444444444444
	assert inclusion_proof[1] = 0x1b586e993478db71562f0cfe2ad81ccc463b0d18e64bde2fc825530714d8328

	let inclusion_proof_len = 2
	let leaf_index = 2
	let leaf = 0x333333333333333333333333
	utreexo_delete{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(leaf, leaf_index, inclusion_proof, inclusion_proof_len)

	return ()
end 
