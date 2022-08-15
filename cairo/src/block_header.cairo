# Bitcoin Block Header
#
# See also: 
# - https://developer.bitcoin.org/reference/block_chain.html#block-headers
# - https://github.com/bitcoin/bitcoin/blob/7fcf53f7b4524572d1d0c9a5fdc388e87eb02416/src/primitives/block.h

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import assert_le, unsigned_div_rem
from starkware.cairo.common.pow import pow
from buffer import Reader, Writer, read_uint32, write_uint32, read_hash, write_hash, UINT32_SIZE, BYTE
from utils import _compute_double_sha256, assert_hashes_equal

# The size of a block header is 80 bytes
const BLOCK_HEADER_SIZE = 80
# The size of a block header encoded as an array of Uint32 is 20 felts
const BLOCK_HEADER_FELT_SIZE = BLOCK_HEADER_SIZE / UINT32_SIZE

struct BlockHeader:
	member version : felt 
	member prev_block_hash : felt* 
	member merkle_root_hash : felt* 
	member time : felt 
	member bits : felt 
	member nonce : felt 
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

	return (BlockHeader(
		version, prev_block_hash, merkle_root_hash, time, bits, nonce))
end

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

struct BlockHeaderValidationContext:
	member block_header_raw: felt*
	member block_header: BlockHeader
	member block_hash : felt*
	member target : felt
	member prev_context : BlockHeaderValidationContext*
	# member total_work: felt
	# member block_height: felt
end

func read_block_header_validation_context{reader: Reader, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
	prev_context: BlockHeaderValidationContext*) -> (result : BlockHeaderValidationContext):
	alloc_locals

	let block_header_raw = reader.head

	let (block_header) = read_block_header()
	# let block_header_ptr : BlockHeader* = &block_header
	
	let (target) = bits_to_target( block_header.bits )
	
	let (block_hash) = _compute_double_sha256(
		BLOCK_HEADER_FELT_SIZE, block_header_raw, BLOCK_HEADER_SIZE)

	return (BlockHeaderValidationContext(
		block_header_raw, block_header, block_hash, target, prev_context))
end

# Calculate target from bits
# See https://developer.bitcoin.org/reference/block_chain.html#target-nbits
func bits_to_target{range_check_ptr}(bits) -> (target: felt):
    alloc_locals
    # Ensure that the max target is not exceeded (0x1d00FFFF)
    assert_le(bits, 0x1d00FFFF)

    # Parse the significand and the exponent
    # The exponent has 8 bits and the significand has 24 bits
    let (exponent, significand) = unsigned_div_rem(bits, BYTE**3)
    
    # Compute the target via exponentiation of significand and exponent
    let (base) = pow(BYTE, exponent - 3)
    return (significand * base)
end

# Validate a block header
func validate_block_header(context: BlockHeaderValidationContext):
	# Validate previous block hash
	validate_prev_block_hash(context)

	# Validate the proof-of-work
	validate_proof_of_work(context)

	# Validate the difficulty of the proof-of-work
	validate_target(context)

	# Validate the block's timestamp
	validate_median_time(context)
	return ()
end

# Validate a block header correctly extends the current chain
func validate_prev_block_hash(context: BlockHeaderValidationContext):
	assert_hashes_equal(context.prev_context.block_hash, context.block_header.prev_block_hash)
	return ()
end

# Validate a block header's proof-of-work matches its target
func validate_proof_of_work(context: BlockHeaderValidationContext):
	# Securely convert block_hash to a felt and then compare it to the target
	# TODO: implement me
	return ()
end

# Validate that the proof-of-work target is sufficiently difficult
#
# See also:
# - https://github.com/bitcoin/bitcoin/blob/7fcf53f7b4524572d1d0c9a5fdc388e87eb02416/src/pow.cpp#L13
func validate_target(context: BlockHeaderValidationContext):
	# TODO: implement me
	return ()
end

# The timestamp of a block header must be strictly greater than the median time 
# of the previous 11 blocks. 
#
# See also:
# - https://developer.bitcoin.org/reference/block_chain.html#block-headers
# - https://github.com/bitcoin/bitcoin/blob/36c83b40bd68a993ab6459cb0d5d2c8ce4541147/src/chain.h#L290
func validate_median_time(context: BlockHeaderValidationContext):
	# TODO: implement me
	# Step 1: Let Python sort the array and compute a permutation (array of indexes)
	# Step 2: Use that permutation to create a sorted array of pointers in Cairo
	# Step 3: Prove sortedness of the sorted array in linear time
	# Step 4: Read the median from the sorted array
	return ()
end
