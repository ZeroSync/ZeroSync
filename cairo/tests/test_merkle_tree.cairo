%lang starknet

from starkware.cairo.common.alloc import alloc
from src.merkle_tree import compute_merkle_root
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

@external
func test_compute_merkle_root{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
	# See https://medium.com/coinmonks/how-to-manually-verify-the-merkle-root-of-a-bitcoin-block-command-line-7881397d4db1
	# Note that bitcoin core and most block explorers swap the endianess when displaying a hash
	# So, we have to reverse the byte order to compute the merkle tree
	let (leaves) = alloc()

	# 82501c1178fa0b222c1f3d474ec726b832013f0a532b44bb620cce8624a5feb1
	assert leaves[0] = 0x82501c11
	assert leaves[1] = 0x78fa0b22
	assert leaves[2] = 0x2c1f3d47
	assert leaves[3] = 0x4ec726b8
	assert leaves[4] = 0x32013f0a
	assert leaves[5] = 0x532b44bb
	assert leaves[6] = 0x620cce86
	assert leaves[7] = 0x24a5feb1

	# 169e1e83e930853391bc6f35f605c6754cfead57cf8387639d3b4096c54f18f4
	assert leaves[8]  = 0x169e1e83
	assert leaves[9]  = 0xe9308533
	assert leaves[10] = 0x91bc6f35
	assert leaves[11] = 0xf605c675
	assert leaves[12] = 0x4cfead57
	assert leaves[13] = 0xcf838763
	assert leaves[14] = 0x9d3b4096
	assert leaves[15] = 0xc54f18f4

	# ff104ccb05421ab93e63f8c3ce5c2c2e9dbb37de2764b3a3175c8166562cac7d
	let (root) = compute_merkle_root(leaves, leaves_len = 2)
	assert root[0] = 0xff104ccb
	assert root[1] = 0x05421ab9
	assert root[2] = 0x3e63f8c3
	assert root[3] = 0xce5c2c2e
	assert root[4] = 0x9dbb37de
	assert root[5] = 0x2764b3a3
	assert root[6] = 0x175c8166
	assert root[7] = 0x562cac7d

	return()
end

