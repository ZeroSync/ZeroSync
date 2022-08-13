# Bitcoin Block Header
#
# Specification: 
# https://developer.bitcoin.org/reference/block_chain.html#block-headers
# https://github.com/bitcoin/bitcoin/blob/7fcf53f7b4524572d1d0c9a5fdc388e87eb02416/src/primitives/block.h

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import assert_le, unsigned_div_rem
from starkware.cairo.common.pow import pow
from buffer import Reader, Writer, read_uint32, write_uint32, read_hash, write_hash
from utils import _compute_double_sha256, assert_hashes_equal

struct BlockHeader:
	member version : felt 
	member prev_block_hash : felt* 
	member merkle_root_hash : felt* 
	member time : felt 
	member bits : felt 
	member nonce : felt 
end

# The size of a block header is 80 bytes
const SIZE_OF_BLOCK_HEADER = 80
# The size of a block header encoded as an array of Uint32 is 20 felts
const FELT_SIZE_OF_BLOCK_HEADER = SIZE_OF_BLOCK_HEADER / 4

# Write a BlockHeader to a Uint32 array
func write_block_header{writer: Writer, range_check_ptr}(
	header : BlockHeader):
	write_uint32(header.version)
	write_hash(  header.prev_block_hash)
	write_hash(  header.merkle_root_hash)
	write_uint32(header.time)
	write_uint32(header.bits)
	write_uint32(header.nonce)
	return ()
end

# Read a BlockHeader from a Uint32 array
func read_block_header{reader: Reader, range_check_ptr}(
	) -> (result : BlockHeader):
	alloc_locals

	let (version)			= read_uint32()
	let (prev_block_hash)	= read_hash()
	let (merkle_root_hash)	= read_hash()
	let (time)				= read_uint32()
	let (bits)				= read_uint32()
	let (nonce)				= read_uint32()

	let result = BlockHeader(
		version, prev_block_hash, merkle_root_hash, time, bits, nonce) 

	return (result)
end

struct BlockHeaderValidationContext:
	member block_header_raw: felt*
	member block_header: BlockHeader
	member block_hash : felt*
	member target : felt
	member prev_context : BlockHeaderValidationContext*
	# member total_work: felt
	# member block_height: felt
	# member median_time: felt
end

func read_block_header_validation_context{reader: Reader, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
	prev_context: BlockHeaderValidationContext*) -> (result : BlockHeaderValidationContext):
	alloc_locals

	let block_header_raw = reader.head

	let (block_header) = read_block_header()
	
	let (target) = bits_to_target(block_header.bits)
	
	let (block_hash) = _compute_double_sha256(
		FELT_SIZE_OF_BLOCK_HEADER, block_header_raw, SIZE_OF_BLOCK_HEADER)

	return (BlockHeaderValidationContext(
		block_header_raw, block_header, block_hash, target, prev_context)
)
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
    let (tmp) = pow(2**8, exponent - 3)
    return (significand * tmp)
end


# The timestamp in a BlockHeader must be strictly greater 
# than the median time of the previous 11 blocks. 
# Full nodes will not accept blocks with headers more than two hours in the future 
# according to their clock.
#
# See:
# - https://developer.bitcoin.org/reference/block_chain.html#block-headers
# - https://github.com/bitcoin/bitcoin/blob/36c83b40bd68a993ab6459cb0d5d2c8ce4541147/src/chain.h#L290
func validate_median_time(context: BlockHeaderValidationContext):
	# TODO
	# Step 1: Let python sort the array and compute a permutation (array of indexes)
	# Step 2: Use the permutation to create a sorted array of pointers
	# Step 3: Prove sortedness of the sorted array in linear time
	# Step 4: Read the median from the sorted array
	return()
end

func validate_block_header(context: BlockHeaderValidationContext):
	# Validate previous block hash
	validate_prev_block_hash(context)

	# Validate proof-of-work
	validate_proof_of_work(context)

	# Validate the difficulty
	validate_difficulty(context)

	# Validate timestamp
	validate_median_time(context)

	return ()
end

#
# See
# https://github.com/bitcoin/bitcoin/blob/7fcf53f7b4524572d1d0c9a5fdc388e87eb02416/src/pow.cpp#L13
func validate_difficulty(context: BlockHeaderValidationContext):
	# TODO
	return()
end

func validate_prev_block_hash(context: BlockHeaderValidationContext):
	assert_hashes_equal(context.prev_context.block_hash, context.block_header.prev_block_hash)
	return()
end

func validate_proof_of_work(context: BlockHeaderValidationContext):
	# Securely convert block_hash to a felt and then compare it to the target
	# TODO
	return ()
end