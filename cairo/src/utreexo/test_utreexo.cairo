#
# To run only this test suite use:
# protostar test  --cairo-path=./src target src/**/*_utreexo*
#
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin

from utreexo.utreexo import utreexo_add, Forest


@external
func test_utreexo_add{range_check_ptr, pedersen_ptr: HashBuiltin*}():
	let (roots) = alloc()
	let forest = Forest(roots, 0)

	utreexo_add{hash_ptr=pedersen_ptr, forest=forest}(0xff00ff00ff00ff00ff00ff00)
	assert forest.leaves_count = 1
	assert [forest.roots] = 0xff00ff00ff00ff00ff00ff00

	utreexo_add{hash_ptr=pedersen_ptr, forest=forest}(0x00ff00ff00ff00ff00ff00ff)
	assert forest.leaves_count = 2
	assert [forest.roots] = 0x676c1cf796b56802dd5fe6607743b73c4112e44037e88429325071c6c98b8a9
	
	utreexo_add{hash_ptr=pedersen_ptr, forest=forest}(0x33ff00ff00ff00ff00ff00ff)
	assert forest.leaves_count = 3
	assert [forest.roots] = 0x33ff00ff00ff00ff00ff00ff
	assert [forest.roots + 1] = 0x676c1cf796b56802dd5fe6607743b73c4112e44037e88429325071c6c98b8a9

	return ()
end 