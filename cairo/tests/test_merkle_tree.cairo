# Note that Bitcoin Core and most block explorers swap the endianess when displaying a hash
# So, we have to reverse the byte order to compute the merkle tree

#
# To run only this test suite use:
# protostar test  --cairo-path=./src target tests/*_merkle_tree*
#

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import unsigned_div_rem, split_int
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from src.utils import HASH_LEN, assert_hashes_equal, to_big_endian
from src.merkle_tree import compute_merkle_root


# Write 4 bytes into an array of four 32-bit unsigned integers
# and swap the endianess
func write4_endian{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
	value, destination: felt*):
	let (value) = to_big_endian(value)
	assert destination[0] = value
	return ()
end

# Write 16 bytes into an array of four 32-bit unsigned integers
# and swap the endianess
func write16_endian{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
	value, destination: felt*):

	let (uint96,   uint32_3) = unsigned_div_rem(value,  2**32)
	let (uint64,   uint32_2) = unsigned_div_rem(uint96, 2**32)
	let (uint32_0, uint32_1) = unsigned_div_rem(uint64, 2**32)
	
	# Swap the order and endianess of the 32-bit integers 
	write4_endian(uint32_3, destination + 0)
	write4_endian(uint32_2, destination + 1)
	write4_endian(uint32_1, destination + 2)
	write4_endian(uint32_0, destination + 3)

	return ()
end

# Write a 32-bytes hash represented as 2 x 16 bytes
# into an array of 8 x 32-bit unsigned integers
# and swap the endianess
func write_hash{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
	high, low, destination: felt*):
	write16_endian(low, destination)
	let destination = destination + HASH_LEN / 2
	write16_endian(high, destination)
	return ()
end

# Write an array of 32-bytes hashes represented as 2 x 16 bytes
# into an array of 8 x 32-bit unsigned integers chunks in linear memory.
# And swap the endianess of the 32 bytes.
# Use `index` to address the index of the 32-byte chunks
# (Assumes that high and low are at most 16 bytes)
func write_hashes{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
	high, low, destination: felt*, index):
	let destination = destination + index * HASH_LEN
	write_hash(high, low, destination)
	return ()
end

@external
func test_write_hashes{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():

	let (leaves) = alloc()
	assert leaves[0] = 0x82501c11
	assert leaves[1] = 0x78fa0b22
	assert leaves[2] = 0x2c1f3d47
	assert leaves[3] = 0x4ec726b8
	assert leaves[4] = 0x32013f0a
	assert leaves[5] = 0x532b44bb
	assert leaves[6] = 0x620cce86
	assert leaves[7] = 0x24a5feb1

    write_hashes(0xb1fea52486ce0c62bb442b530a3f0132,0xb826c74e473d1f2c220bfa78111c5082, leaves, index = 1)

	assert_hashes_equal(leaves, leaves + HASH_LEN)
	return ()
end

# Simple test case (2 TXs)
# Test case from https://medium.com/coinmonks/how-to-manually-verify-the-merkle-root-of-a-bitcoin-block-command-line-7881397d4db1
@external
func test_compute_merkle_root{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():

	let (leaves) = alloc()
	write_hashes(0xb1fea52486ce0c62bb442b530a3f0132,0xb826c74e473d1f2c220bfa78111c5082, leaves, 0)
	write_hashes(0xf4184fc596403b9d638783cf57adfe4c,0x75c605f6356fbc91338530e9831e9e16, leaves, 1)

	let (root) = compute_merkle_root(leaves, leaves_len = 2)
	
	let (root_expected) = alloc()
	write_hash(0x7dac2c5666815c17a3b36427de37bb9d, 0x2e2c5ccec3f8633eb91a4205cb4c10ff, root_expected)

	assert_hashes_equal(root, root_expected)
	return()
end


# Power of 2 test case (8 TXs)
# https://blockchain.info/block/000000000000307b75c9b213f61b2a0c429a34b41b628daae9774cb9b5ff1059
# Test case from https://gist.github.com/thereal1024/45bb035e580430988a34
@external
func test_compute_merkle_root_power_of_2{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():

	let (leaves) = alloc()
	write_hashes(0x04a2808134e646ba67ff83f0bc7535a0,0x08b6e154c98953f5e2c9d40429880faf, leaves, 0)
	write_hashes(0xb6b3ff7b4d004a788c751f3f8fc881f9,0x6c7b647ae06eb9a720bddc924e6f9147, leaves, 1)
	write_hashes(0xe614ebb7e059e248e1f4c440f91af5c9,0x617394a05d72233d7acf6feb153362f1, leaves, 2)
	write_hashes(0x5bbc4545145126108c91689e62c18066,0x46468c547999241f5c2883a526e015b6, leaves, 3)
	write_hashes(0xde56c21783d3d466c0a5a155ed909c70,0x11879df1996d8c418dac74465ebc3564, leaves, 4)
	write_hashes(0xd327f96d32afdbf4238458684570189d,0xe26ba5dc300d5cd19fa1a9cdcecdb527, leaves, 5)
	write_hashes(0x702c3d845810f31c194e7c9ea3d2b363,0x6f3b8b9ee71f3d93a2f36e9d1a4e9a81, leaves, 6)
	write_hashes(0xb320e44b0e4cbe5973b4ebdea0c63939,0xf9cc196982e3f4d15daaa1baa16f0004, leaves, 7)

	let (root) = compute_merkle_root(leaves, leaves_len = 8)
	
	let (root_expected) = alloc()
    write_hash(0x0b0192e318af62f8f91243948ea4c7ea,0x9d696197e88b9401bce35ecb0a0cb59b, root_expected)
	
	assert_hashes_equal(root, root_expected)
	return()
end

# Uneven test case (13 TXs)
# https://blockchain.info/block/0000000000004563d49a8e7f7f2a2f0aec01101fa971fb63714b8fbf32f62f91
# Test case from https://gist.github.com/thereal1024/45bb035e580430988a34
@external
func test_compute_merkle_root_uneven{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():

	let (leaves) = alloc()
    write_hashes(0xdf70f26b6df54332ad29c08aab5e5d55,0x60d1468311e90484ebd89f87ac6264e8, leaves, 0)
    write_hashes(0x2148314cd02237786abe127f23b7346d,0xf8a116a2851745cb987652a3e132fc50, leaves, 1)
    write_hashes(0x06c303894833eb5d639f06f95ceb2c4b,0xd08e0ab4ae1d94cccfa54f02e9b35990, leaves, 2)
    write_hashes(0x90ae3d27a5215dbb8e2e1657c927f81b,0xdb9601106a6159f5384b4cde53836f24, leaves, 3)
    write_hashes(0x51cfe20029ed6366e7f475a123ad84c9,0x6c54522e9ae64cb2f548811124a6f833, leaves, 4)
    write_hashes(0x1e856be000b0fbaa5929b88775509510,0x6f4f0d3d19f9cd9cb07ab2239c8b4b18, leaves, 5)
    write_hashes(0x9d6314d68d9de8250513563e02f83ffc,0x80973ec8b7c2966835e2cbcac3320898, leaves, 6)
    write_hashes(0x5d6e3fc4b0c44b867b83b7d7ca365754,0xa8bb87d93c4f365ecacc1f0109b4c99c, leaves, 7)
    write_hashes(0x58afcfed0a60792c3e15d8bb2bd8d59f,0x2a968639473e575e2fc1c270fcfae910, leaves, 8)
    write_hashes(0x50a0e15c32c257934f75ee2fa125dd7e,0x9a542d38b5989efc380ea2c06a299804, leaves, 9)
    write_hashes(0xacd706cdbe74f82040cc583e42dfc28d,0x8603c2f7d2fe29c0d41ee2e8d78be51b, leaves, 10)
    write_hashes(0xc7be55d3b55bd59f1ca19d2dc3ffbe8c,0x28917c9e27f02456872755215b4b8a1f, leaves, 11)
    write_hashes(0xe323fe6719e707b8deb108d3f4bcc43d,0x9e018cf48e027b8f88941886a0744f60, leaves, 12)

	let (root) = compute_merkle_root(leaves, leaves_len = 13)
	
	let (root_expected) = alloc()
    write_hash(0x560a4d3b44e57ff78be70d29698a8f98,0xce11677c1a59fb9966a7cd1795c9b47b, root_expected)
	
	assert_hashes_equal(root, root_expected)
	return()
end


