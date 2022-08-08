%lang starknet

from starkware.cairo.common.alloc import alloc
from src.merkle_tree import compute_merkle_root
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

@external
func test_compute_merkle_root{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
	
	let (leaves) = alloc()

	# b1fea52486ce0c62bb442b530a3f0132b826c74e473d1f2c220bfa78111c5082
	assert leaves[0] = 0xb1fea524
	assert leaves[1] = 0x86ce0c62
	assert leaves[2] = 0xbb442b53
	assert leaves[3] = 0x0a3f0132
	assert leaves[4] = 0xb826c74e
	assert leaves[5] = 0x473d1f2c
	assert leaves[6] = 0x220bfa78
	assert leaves[7] = 0x111c5082

	# f4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16
	assert leaves[8]  = 0xf4184fc5
	assert leaves[9]  = 0x96403b9d
	assert leaves[10] = 0x638783cf
	assert leaves[11] = 0x57adfe4c
	assert leaves[12] = 0x75c605f6
	assert leaves[13] = 0x356fbc91
	assert leaves[14] = 0x338530e9
	assert leaves[15] = 0x831e9e16

	let (root) = compute_merkle_root(leaves, leaves_len = 2)

	# 7dac2c5666815c17a3b36427de37bb9d2e2c5ccec3f8633eb91a4205cb4c10ff
	assert root[0] = 0x7dac2c56
	assert root[1] = 0x66815c17
	assert root[2] = 0xa3b36427
	assert root[3] = 0xde37bb9d
	assert root[4] = 0x2e2c5cce
	assert root[5] = 0xc3f8633e
	assert root[6] = 0xb91a4205
	assert root[7] = 0xcb4c10ff

	return()
end