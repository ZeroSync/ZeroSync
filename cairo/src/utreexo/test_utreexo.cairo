#
# To run only this test suite use:
# protostar test  --cairo-path=./src target src/**/*_utreexo*
#
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin

from utreexo.utreexo import utreexo_add, utreexo_delete, utreexo_init


@external
func test_utreexo{range_check_ptr, pedersen_ptr: HashBuiltin*}():
	alloc_locals

	let (forest) = utreexo_init()

	utreexo_add{hash_ptr=pedersen_ptr, forest=forest}(0xff00ff00ff00ff00ff00ff00)
	assert 0xff00ff00ff00ff00ff00ff00 = forest[0]

	utreexo_add{hash_ptr=pedersen_ptr, forest=forest}(0x00ff00ff00ff00ff00ff00ff)
	assert 0 = forest[0]
	assert 0x1c60c3a9a8fc2ebb9a12921bfa16c341abc787d4fa8c0806026991397925885 = forest[1]
	
	utreexo_add{hash_ptr=pedersen_ptr, forest=forest}(0x33ff00ff00ff00ff00ff00ff)
	assert 0x33ff00ff00ff00ff00ff00ff = forest[0]
	assert 0x1c60c3a9a8fc2ebb9a12921bfa16c341abc787d4fa8c0806026991397925885 = forest[1]

	utreexo_add{hash_ptr=pedersen_ptr, forest=forest}(0x44ff00ff00ff00ff00ff00ff)
	assert 0 = forest[0]
	assert 0 = forest[1]
	assert 0x458c8b68353c8b2105f4ec79ff225fca660aee06df5ae56b4b8328b5edd8d71 = forest[2]


	let (proof) = alloc()
	assert proof[0] = 0x44ff00ff00ff00ff00ff00ff
	assert proof[1] = 0x1c60c3a9a8fc2ebb9a12921bfa16c341abc787d4fa8c0806026991397925885

	let proof_len = 2
	let index = 2
	let leaf = 0x33ff00ff00ff00ff00ff00ff
	utreexo_delete{hash_ptr=pedersen_ptr, forest=forest}(proof, proof_len, index, leaf)

	return ()
end 