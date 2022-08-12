# Bitcoin Block Header
#
# Specification: 
# https://developer.bitcoin.org/reference/block_chain.html#block-headers
# https://github.com/bitcoin/bitcoin/blob/7fcf53f7b4524572d1d0c9a5fdc388e87eb02416/src/primitives/block.h

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import assert_le, unsigned_div_rem
from starkware.cairo.common.pow import pow
from buffer import Writer, Reader, write_4_bytes, write_4_bytes_endian, write_hash, read_4_bytes, read_4_bytes_endian, read_hash
from utils import _compute_double_sha256

struct BlockHeader:
	member version : felt 
	member hash_prev_block : felt* 
	member hash_merkle_root : felt* 
	member time : felt 
	member bits : felt 
	member nonce : felt 

	# Computed fields
	member block_hash : felt*
	member target : felt
end

# The size of a block header is 80 bytes
const SIZE_OF_BLOCK_HEADER = 80
# The size of a block header encoded as an array of 32-bit integers is 20 felts
const FELT_SIZE_OF_BLOCK_HEADER = SIZE_OF_BLOCK_HEADER / 4

# Write a BlockHeader to a uint32 array
func write_block_header{ writer: Writer, range_check_ptr }(
	header : BlockHeader ):
	write_4_bytes_endian(header.version)
	write_hash(header.hash_prev_block)
	write_hash(header.hash_merkle_root)
	write_4_bytes_endian(header.time)
	write_4_bytes_endian(header.bits)
	write_4_bytes(header.nonce)
	return ()
end

# Read a BlockHeader from a uint32 array
func read_block_header{reader: Reader, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
	) -> (result : BlockHeader):
	alloc_locals

	let raw_block_header = reader.pointer
	let (block_hash) = _compute_double_sha256(
		FELT_SIZE_OF_BLOCK_HEADER, raw_block_header, SIZE_OF_BLOCK_HEADER)

	let (version) = read_4_bytes_endian()
	let (hash_prev_block) = read_hash()
	let (hash_merkle_root) = read_hash()
	let (time) = read_4_bytes_endian()
	let (bits) = read_4_bytes_endian()
	let (nonce) = read_4_bytes()

	let (target) = bits_to_target(bits)

	let result = BlockHeader(
		version, hash_prev_block, hash_merkle_root, time, bits, nonce,
		block_hash, target) 

	return (result)
end

# Calculate target from bits
# See https://developer.bitcoin.org/reference/block_chain.html#target-nbits
func bits_to_target{range_check_ptr}(bits) -> (target: felt):
    alloc_locals
    # Ensure that the max target is not exceeded (0x1d00FFFF)
    assert_le(bits, 0x1d00FFFF)

    # Parse the significand and the exponent
    # The exponent has 8 bits and the significand has 24 bits
    let (exponent, significand) = unsigned_div_rem(bits, 2**24)
    
    # Compute the target via exponentiation of significand and exponent
    let (tmp) = pow(2**8 , exponent - 3)
    return (significand * tmp)
end