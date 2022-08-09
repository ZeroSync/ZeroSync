# See https://medium.com/coinmonks/how-to-manually-verify-the-merkle-root-of-a-bitcoin-block-command-line-7881397d4db1
# Note that Bitcoin Core and most block explorers swap the endianess when displaying a hash
# So, we have to reverse the byte order to compute the merkle tree

#
# To run only this test use:
# protostar test  --cairo-path=./src target tests/*_merkle_tree*
#

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import unsigned_div_rem, split_int
from src.merkle_tree import compute_merkle_root
from src.utils import HASH_LEN, assert_hashes_equal
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin


func to_words{range_check_ptr}(high, low, destination: felt*, index):
	let destination = destination + index * HASH_LEN

	let (uint96,   uint32_3) = unsigned_div_rem(high,   2**32)
	let (uint64,   uint32_2) = unsigned_div_rem(uint96, 2**32)
	let (uint32_0, uint32_1) = unsigned_div_rem(uint64, 2**32)
	assert destination[0] = uint32_0
	assert destination[1] = uint32_1
	assert destination[2] = uint32_2
	assert destination[3] = uint32_3
	let destination = destination + HASH_LEN / 2

	let (uint96,   uint32_3) = unsigned_div_rem(low,    2**32)
	let (uint64,   uint32_2) = unsigned_div_rem(uint96, 2**32)
	let (uint32_0, uint32_1) = unsigned_div_rem(uint64, 2**32)
	assert destination[0] = uint32_0
	assert destination[1] = uint32_1
	assert destination[2] = uint32_2
	assert destination[3] = uint32_3

	return ()
end

@external
func test_to_words{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
	alloc_locals
	let (leaves) = alloc()

	assert leaves[0] = 0x82501c11
	assert leaves[1] = 0x78fa0b22
	assert leaves[2] = 0x2c1f3d47
	assert leaves[3] = 0x4ec726b8
	assert leaves[4] = 0x32013f0a
	assert leaves[5] = 0x532b44bb
	assert leaves[6] = 0x620cce86
	assert leaves[7] = 0x24a5feb1

    to_words(0x82501c1178fa0b222c1f3d474ec726b8, 0x32013f0a532b44bb620cce8624a5feb1, leaves, 1)

	assert_hashes_equal(leaves, leaves + HASH_LEN)
	return()
end


@external
func test_compute_merkle_root{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
	alloc_locals
	let (leaves) = alloc()

	to_words(0x82501c1178fa0b222c1f3d474ec726b8, 0x32013f0a532b44bb620cce8624a5feb1, leaves, 0)
	to_words(0x169e1e83e930853391bc6f35f605c675, 0x4cfead57cf8387639d3b4096c54f18f4, leaves, 1)

	let (root) = compute_merkle_root(leaves, leaves_len = 2)
	
	# ff104ccb05421ab93e63f8c3ce5c2c2e9dbb37de2764b3a3175c8166562cac7d
	let (root_expected) = alloc()
	to_words(0xff104ccb05421ab93e63f8c3ce5c2c2e, 0x9dbb37de2764b3a3175c8166562cac7d, root_expected, 0)

	assert_hashes_equal(root, root_expected)
	return()
end


@external
func test_compute_merkle_root_power_of_2{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
	# Test cases https://gist.github.com/thereal1024/45bb035e580430988a34
	alloc_locals
	let (leaves) = alloc()

	to_words(0xaf0f882904d4c9e2f55389c954e1b608, 0xa03575bcf083ff67ba46e6348180a204, leaves, 0)
	to_words(0x47916f4e92dcbd20a7b96ee07a647b6c, 0xf981c88f3f1f758c784a004d7bffb3b6, leaves, 1)
	to_words(0xf1623315eb6fcf7a3d23725da0947361, 0xc9f51af940c4f4e148e259e0b7eb14e6, leaves, 2)
	to_words(0xb615e026a583285c1f249979548c4646, 0x6680c1629e68918c102651144545bc5b, leaves, 3)
	to_words(0x6435bc5e4674ac8d418c6d99f19d8711, 0x709c90ed55a1a5c066d4d38317c256de, leaves, 4)
	to_words(0x27b5cdcecda9a19fd15c0d30dca56be2, 0x9d18704568588423f4dbaf326df927d3, leaves, 5)
	to_words(0x819a4e1a9d6ef3a2933d1fe79e8b3b6f, 0x63b3d2a39e7c4e191cf31058843d2c70, leaves, 6)
	to_words(0x04006fa1baa1aa5dd1f4e3826919ccf9, 0x3939c6a0deebb47359be4c0e4be420b3, leaves, 7)

	let (root) = compute_merkle_root(leaves, leaves_len = 8)
	
	# 0b0192e318af62f8f91243948ea4c7ea9d696197e88b9401bce35ecb0a0cb59b
	let (root_expected) = alloc()
    to_words(0x9bb50c0acb5ee3bc01948be89761699d, 0xeac7a48e944312f9f862af18e392010b, root_expected, 0)
	
	assert_hashes_equal(root, root_expected)
	return()
end


@external
func test_compute_merkle_root_uneven{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
	# Test cases https://gist.github.com/thereal1024/45bb035e580430988a34
	alloc_locals
	let (leaves) = alloc()

    to_words(0xe86462ac879fd8eb8404e9118346d160, 0x555d5eab8ac029ad3243f56d6bf270df, leaves, 0)
    to_words(0x50fc32e1a3527698cb451785a216a1f8, 0x6d34b7237f12be6a783722d04c314821, leaves, 1)
    to_words(0x9059b3e9024fa5cfcc941daeb40a8ed0, 0x4b2ceb5cf9069f635deb33488903c306, leaves, 2)
    to_words(0x246f8353de4c4b38f559616a100196db, 0x1bf827c957162e8ebb5d21a5273dae90, leaves, 3)
    to_words(0x33f8a624118148f5b24ce69a2e52546c, 0xc984ad23a175f4e76663ed2900e2cf51, leaves, 4)
    to_words(0x184b8b9c23b27ab09ccdf9193d0d4f6f, 0x1095507587b82959aafbb000e06b851e, leaves, 5)
    to_words(0x980832c3cacbe2356896c2b7c83e9780, 0xfc3ff8023e56130525e89d8dd614639d, leaves, 6)
    to_words(0x9cc9b409011fccca5e364f3cd987bba8, 0x545736cad7b7837b864bc4b0c43f6e5d, leaves, 7)
    to_words(0x10e9fafc70c2c12f5e573e473986962a, 0x9fd5d82bbbd8153e2c79600aedcfaf58, leaves, 8)
    to_words(0x0498296ac0a20e38fc9e98b5382d549a, 0x7edd25a12fee754f9357c2325ce1a050, leaves, 9)
    to_words(0x1be58bd7e8e21ed4c029fed2f7c20386, 0x8dc2df423e58cc4020f874becd06d7ac, leaves, 10)
    to_words(0x1f8a4b5b215527875624f0279e7c9128, 0x8cbeffc32d9da11c9fd55bb5d355bec7, leaves, 11)
    to_words(0x604f74a0861894888f7b028ef48c019e, 0x3dc4bcf4d308b1deb807e71967fe23e3, leaves, 12)

	let (root) = compute_merkle_root(leaves, leaves_len = 13)
	
	# 0b0192e318af62f8f91243948ea4c7ea9d696197e88b9401bce35ecb0a0cb59b
	let (root_expected) = alloc()
    to_words(0x7bb4c99517cda76699fb591a7c6711ce, 0x988f8a69290de78bf77fe5443b4d0a56, root_expected, 0)
	
	assert_hashes_equal(root, root_expected)
	return()
end



