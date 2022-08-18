# Serialization and Validation of Bitcoin Block Headers
#
# See also: 
# - Reference: https://developer.bitcoin.org/reference/block_chain.html#block-headers
# - Bitcoin Core: https://github.com/bitcoin/bitcoin/blob/7fcf53f7b4524572d1d0c9a5fdc388e87eb02416/src/primitives/block.h#L22

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import assert_le, unsigned_div_rem
from starkware.cairo.common.pow import pow
from starkware.cairo.common.alloc import alloc

from buffer import Reader, Writer, read_uint32, write_uint32, read_hash, write_hash, UINT32_SIZE, BYTE
from crypto.sha256d.sha256d import sha256d_felt_sized, assert_hashes_equal

# The size of a block header is 80 bytes
const BLOCK_HEADER_SIZE = 80
# The size of a block header encoded as an array of Uint32 is 20 felts
const BLOCK_HEADER_FELT_SIZE = BLOCK_HEADER_SIZE / UINT32_SIZE

# Definition of a Bitcoin block header
# 
# See also:
# - https://developer.bitcoin.org/reference/block_chain.html#block-headers
struct BlockHeader:
	# The block version number indicates which set of block validation rules to follow
	member version: felt

	# The hash of the previous block in the chain
	member prev_block_hash: felt*
	
	# The Merkle root hash of all transactions in this block
	member merkle_root_hash: felt*

	# The timestamp of this block header
	member time: felt

	# The target for the proof-of-work in compact encoding
	member bits: felt

	# The lucky nonce which solves the proof-of-work
	member nonce: felt
end

# Read a BlockHeader from a Uint32 array
func read_block_header{reader: Reader, range_check_ptr}(
	) -> (result: BlockHeader):
	alloc_locals

	let (version)          = read_uint32()
	let (prev_block_hash)  = read_hash()
	let (merkle_root_hash) = read_hash()
	let (time)             = read_uint32()
	let (bits)             = read_uint32()
	let (nonce)            = read_uint32()

	return (BlockHeader(
		version, prev_block_hash, merkle_root_hash, time, bits, nonce))
end

# Write a BlockHeader into a Uint32 array
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

# A summary of the current state of a block chain
struct ChainState:
	# The number of blocks in the longest chain
	member block_height: felt

	# The total amount of work in the longest chain
	member total_work: felt

	# The block_hash of the current chain tip
	member best_hash: felt*

	# The difficulty for targets
	member difficulty: felt

	# The start time used to recalibrate the difficulty after 2016 blocks
	member epoch_start_time: felt

	# The timestamps of the latest 11 blocks
	member prev_timestamps : felt*
end

# The validation context for block headers
struct BlockHeaderValidationContext:
	# The block header serialized as uint32 array
	member block_header_raw: felt*
	
	# The block header parsed into a struct
	# TODO: should be a pointer
	member block_header: BlockHeader
	
	# The hash of this block header
	member block_hash: felt*
	
	# The target for the proof-of-work 
	# ASSUMPTION: Target is smaller than 2**246. Might overflow otherwise
	member target: felt
	
	# The previous state that is updated by this block
	member prev_chain_state: ChainState

	# The block height of this block header
	member block_height: felt
end


# Read a block header and its validation context from a reader and a previous validation context
func read_block_header_validation_context{reader: Reader, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
	prev_chain_state: ChainState) -> (context : BlockHeaderValidationContext):
	alloc_locals

	# TODO: what if reader.offset > 0 here?
	# block_header_raw should be a "pointer" into the raw byte string
	# (actually, that's just the same as a Reader) 
	assert reader.offset = 0
	let block_header_raw = reader.head

	let (block_header) = read_block_header()
	
	let (target) = bits_to_target(block_header.bits)
	
	let (block_hash) = sha256d_felt_sized(block_header_raw, BLOCK_HEADER_FELT_SIZE)

	let block_height = prev_chain_state.block_height + 1

	return (BlockHeaderValidationContext(
		block_header_raw,
		block_header,
		block_hash,
		target,
		prev_chain_state,
		block_height
	))
end

# Calculate target from bits
# See https://developer.bitcoin.org/reference/block_chain.html#target-nbits
func bits_to_target{range_check_ptr}(bits) -> (target: felt):
    alloc_locals
    # Ensure that the max target is not exceeded (0x1d00FFFF)
    assert_le(bits, 0x1d00FFFF)

    # Decode `bits` into exponent and significand
    # There's 1 byte for the exponent followed by 3 bytes for the significand
    let (exponent, significand) = unsigned_div_rem(bits, BYTE**3)
    
    # Compute the target via exponentiation of significand and exponent
    let (shift_left) = pow(BYTE, exponent - 3)
    return (significand * shift_left)
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

# Validate that a block header correctly extends the current chain
func validate_prev_block_hash(context: BlockHeaderValidationContext):
	# TODO: FIXME 
	assert_hashes_equal(context.prev_chain_state.best_hash, context.block_header.prev_block_hash)
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

# Validate that the timestamp of a block header is strictly greater than the median time 
# of the previous 11 blocks.
#
# See also:
# - https://developer.bitcoin.org/reference/block_chain.html#block-headers
# - https://github.com/bitcoin/bitcoin/blob/36c83b40bd68a993ab6459cb0d5d2c8ce4541147/src/chain.h#L290
func validate_median_time(context: BlockHeaderValidationContext):
	# TODO: implement me using nondeterminism
	# Step 1: Let Python sort the array and compute a permutation (array of indexes)
	# Step 2: Use that permutation to create a sorted array of pointers in Cairo
	# Step 3: Prove sortedness of the sorted array in linear time
	# Step 4: Read the median from the sorted array
	return ()
end
