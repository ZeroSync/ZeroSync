// Serialization and Validation of Bitcoin Block Headers
//
// See also:
// - Reference: https://developer.bitcoin.org/reference/block_chain.html#block-headers
// - Bitcoin Core: https://github.com/bitcoin/bitcoin/blob/7fcf53f7b4524572d1d0c9a5fdc388e87eb02416/src/primitives/block.h#L22

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.math import assert_le, unsigned_div_rem, assert_le_felt, split_felt
from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.pow import pow
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.uint256 import (
    Uint256, uint256_neg, uint256_add, uint256_sub, uint256_mul, uint256_unsigned_div_rem )
from serialize.serialize import (
    Reader, read_uint32, read_hash, UINT32_SIZE, BYTE, init_reader, read_bytes )
from crypto.sha256d.sha256d import sha256d_felt_sized, assert_hashes_equal
from utils.compute_median import compute_timestamps_median
// The size of a block header is 80 bytes
const BLOCK_HEADER_SIZE = 80;
// The size of a block header encoded as an array of Uint32 is 20 felts
const BLOCK_HEADER_FELT_SIZE = BLOCK_HEADER_SIZE / UINT32_SIZE;

// The minimum amount of work required for a block to be valid (represented as `bits`)
const MAX_BITS = 0x1d00FFFF;
// The minimum amount of work required for a block to be valid (represented as `target`)
const MAX_TARGET = 0x00000000FFFF0000000000000000000000000000000000000000000000000000;
// An epoch should be two weeks (represented as number of seconds)
// seconds/minute * minutes/hour * hours/day * 14 days 
const EXPECTED_EPOCH_TIMESPAN = 60 * 60 * 24 * 14;
// Number of blocks per epoch 
const BLOCKS_PER_EPOCH = 2016;


// Definition of a Bitcoin block header
//
// See also:
// - https://developer.bitcoin.org/reference/block_chain.html#block-headers
//
struct BlockHeader {
    // The block version number indicates which set of block validation rules to follow
    version: felt,

    // The hash of the previous block in the chain
    prev_block_hash: felt*,

    // The Merkle root hash of all transactions in this block
    merkle_root_hash: felt*,

    // The timestamp of this block header
    time: felt,

    // The target for the proof-of-work in compact encoding
    bits: felt,

    // The lucky nonce which solves the proof-of-work
    nonce: felt,
}


// Read a BlockHeader from a Uint32 array
//
func read_block_header{reader: Reader, range_check_ptr}() -> (result: BlockHeader) {
    alloc_locals;

    let (version) = read_uint32();
    let (prev_block_hash) = read_hash();
    let (merkle_root_hash) = read_hash();
    let (time) = read_uint32();
    let (bits) = read_uint32();
    let (nonce) = read_uint32();

    return (BlockHeader(
        version, prev_block_hash, merkle_root_hash, time, bits, nonce),);
}


// A summary of the current state of a block chain
//
struct ChainState {
    // The number of blocks in the longest chain
    block_height: felt,

    // The total amount of work in the longest chain
    total_work: felt,

    // The block_hash of the current chain tip
    best_block_hash: felt*,

    // The required difficulty for targets in this epoch
    // In Bitcoin Core this is the result of GetNextWorkRequired
    current_target: felt,

    // The start time used to recalibrate the current_target
    // after an epoch of about 2 weeks (exactly 2016 blocks)
    epoch_start_time: felt,

    // The timestamps of the 11 most recent blocks
    prev_timestamps: felt*,
}


// The validation context for block headers
//
struct BlockHeaderValidationContext {

    // The block header parsed into a struct
    block_header: BlockHeader,

    // The hash of this block header
    block_hash: felt*,

    // The target for the proof-of-work
    // ASSUMPTION: Target is smaller than 2**246. Might overflow otherwise
    target: felt,

    // The previous state that is updated by this block
    prev_chain_state: ChainState,

    // The block height of this block header
    block_height: felt,
}

// Fetch a block header from our blockchain data provider
//
func fetch_block_header(block_height) -> (raw_block_header: felt*) {
    let (raw_block_header) = alloc();

    %{
        block_height = ids.block_height

        import urllib3
        import json
        http = urllib3.PoolManager()

        url = 'https://blockstream.info/api/block-height/' + str(block_height)
        r = http.request('GET', url)
        block_hash = str(r.data, 'utf-8')

        url = f'https://blockstream.info/api/block/{ block_hash }/header'
        r = http.request('GET', url)
        block_hex = r.data.decode('utf-8')

        from_hex(block_hex, ids.raw_block_header)
    %}

    return (raw_block_header,);
}


// Read a block header and its validation context from a reader and a previous validation context
//
func read_block_header_validation_context{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    prev_chain_state: ChainState) -> (context: BlockHeaderValidationContext) {
    alloc_locals;

    let block_height = prev_chain_state.block_height + 1;

    let (raw_block_header) = fetch_block_header(block_height);
    let (reader) = init_reader(raw_block_header);

    let (block_header) = read_block_header{reader=reader}();

    let (target) = bits_to_target(block_header.bits);

    let (block_hash) = sha256d_felt_sized(raw_block_header, BLOCK_HEADER_FELT_SIZE);

    return (
        BlockHeaderValidationContext(
            block_header,
            block_hash,
            target,
            prev_chain_state,
            block_height
        ),
    );
}


// Calculate target from bits
//
// See also:
// - https://developer.bitcoin.org/reference/block_chain.html#target-nbits
//
func bits_to_target{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(bits) -> (target: felt) {
    alloc_locals;
    // Ensure that the max target is not exceeded (0x1d00FFFF)
    with_attr error_message("Bits exceeded the max target.") {
        assert_le(bits, MAX_BITS);
    }

    // Decode the 4 bytes of `bits` into exponent and significand.
    // There's 1 byte for the exponent followed by 3 bytes for the significand

    // To do so, first we need a mask with the first 8 bits:
    const MASK_BITS_TO_SHIFT = 0xFF000000;
    // Then, using a bitwise and to get only the first 8 bits.
    let (bits_to_shift) = bitwise_and(bits, MASK_BITS_TO_SHIFT);
    // And finally, do the shifts
    let exponent = bits_to_shift / 0x1000000;

    // extract last 3 bytes from `bits` to get the significand
    let (significand) = bitwise_and(bits, 0x00ffffff);

    // The target is the `significand` shifted `exponent` times to the left
    // when the exponent is greater than 3.
    // And it is `significand` shifted `exponent` times to the right when
    // it is less than 3.
    let is_greater_than_2 = (2 - exponent) * (1 - exponent) * exponent;
    if (is_greater_than_2 == 0) {
        let (shift) = pow(BYTE, 3 - exponent);
        local target;
        %{ ids.target = ids.significand // ids.shift %}
        return (target=target);
    } else {
        let (shift) = pow(BYTE, exponent - 3);
        let target = significand * shift;
        return (target=target);
    }
}


// Validate a block header, apply it to the previous state
// and return the next state
//
func validate_and_apply_block_header{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    context: BlockHeaderValidationContext) -> (next_state: ChainState) {
    alloc_locals;
    // Validate previous block hash
    validate_prev_block_hash(context);

    // Validate the proof-of-work
    validate_proof_of_work(context);

    // Validate the current_target of the proof-of-work
    validate_target(context);

    // Validate the block's timestamp
    validate_timestamp(context);

    // Apply this block to the previous state
    // and return the next state
    let (next_state) = apply_block_header(context);

    return (next_state,);
}


// Validate that a block header correctly extends the current chain
//
func validate_prev_block_hash(context: BlockHeaderValidationContext) {
    assert_hashes_equal(
        context.prev_chain_state.best_block_hash, context.block_header.prev_block_hash
    );
    return ();
}


// Validate a block header's proof-of-work matches its target.
// Expects that the 4 most significant bytes of `block_hash` are zero.
//
func validate_proof_of_work{range_check_ptr}(context: BlockHeaderValidationContext) {
    // Swap the endianess in the uint32 chunks of the hash
    let (reader) = init_reader(context.block_hash);
    let (hash) = read_bytes{reader=reader}(32);

    // Validate that the hash's most significant uint32 chunk is zero
    // This guarantees that the hash fits into a felt.
    with_attr error_message("Hash's most significant uint32 chunk is not zero.") {
        assert 0 = hash[7];
    }
    // Sum up the other 7 uint32 chunks of the hash into 1 felt
    const BASE = 2 ** 32;
    let hash_felt = hash[0] * BASE ** 0 +
                    hash[1] * BASE ** 1 +
                    hash[2] * BASE ** 2 +
                    hash[3] * BASE ** 3 +
                    hash[4] * BASE ** 4 +
                    hash[5] * BASE ** 5 +
                    hash[6] * BASE ** 6;

    // Validate that the hash is smaller than the target
    with_attr error_message("Insufficient proof of work. Expected block hash to be less than or equal to target.") {
        assert_le_felt(hash_felt, context.target);
    }
    return ();
}


// Validate that the proof-of-work target is sufficiently difficult
//
// See also:
// - https://github.com/bitcoin/bitcoin/blob/7fcf53f7b4524572d1d0c9a5fdc388e87eb02416/src/pow.cpp#L13
// - https://github.com/bitcoin/bitcoin/blob/3a7e0a210c86e3c1750c7e04e3d1d689cf92ddaa/src/rpc/blockchain.cpp#L76
//
func validate_target(context: BlockHeaderValidationContext) {  
    with_attr error_message("Invalid target.") {
        assert context.prev_chain_state.current_target = context.block_header.bits;
    }
    return ();
}


// Validate that the timestamp of a block header is strictly greater than the median time
// of the 11 most recent blocks.
//
// See also:
// - https://developer.bitcoin.org/reference/block_chain.html#block-headers
// - https://github.com/bitcoin/bitcoin/blob/36c83b40bd68a993ab6459cb0d5d2c8ce4541147/src/chain.h#L290
//
func validate_timestamp{range_check_ptr}(context: BlockHeaderValidationContext) {
    alloc_locals;

    let prev_timestamps = context.prev_chain_state.prev_timestamps;
    let (median_time) = compute_timestamps_median(prev_timestamps);

    // Compare this block's timestamp to the median time
    with_attr error_message("Median time is greater than block's timestamp.") {
        assert_le(median_time, context.block_header.time);
    }
    return ();
}


// Compute the total work invested into the longest chain
//
func compute_total_work{range_check_ptr}(
    context: BlockHeaderValidationContext) -> (work: felt) {
    let (work_in_block) = compute_work_from_target(context.target);
    return (context.prev_chain_state.total_work + work_in_block,);
}


// Convert a target into units of work.
// Work is the expected number of hashes required to hit a target.
//
// See also:
// - https://bitcoin.stackexchange.com/questions/936/how-does-a-client-decide-which-is-the-longest-block-chain-if-there-is-a-fork/939#939
// - https://github.com/bitcoin/bitcoin/blob/v0.16.2/src/chain.cpp#L121
// - https://github.com/bitcoin/bitcoin/blob/v0.16.2/src/validation.cpp#L3713
//
func compute_work_from_target{range_check_ptr}(target) -> (work: felt) {
    let (hi, lo) = split_felt(target);
    let target256 = Uint256(lo, hi);
    let (neg_target256) = uint256_neg(target256);
    let (not_target256) = uint256_sub(neg_target256, Uint256(1, 0));
    let (div, _) = uint256_unsigned_div_rem(not_target256, target256);
    let (result, _) = uint256_add(div, Uint256(1, 0));
    return (result.low + result.high * 2 ** 128,);
}


// Compute the 11 most recent timestamps for the next state
//
func next_prev_timestamps(context: BlockHeaderValidationContext) -> (timestamps: felt*) {
    // Copy the timestamp of the most recent block
    alloc_locals;
    let (timestamps) = alloc();
    assert timestamps[0] = context.block_header.time;

    // Copy the 10 most recent timestamps from the previous state
    let prev_timestamps = context.prev_chain_state.prev_timestamps;
    memcpy(timestamps + 1, prev_timestamps, 10);
    return (timestamps,);
}


// Apply a block header to a previous chain state to obtain the next chain state
//
func apply_block_header{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    context: BlockHeaderValidationContext) -> (next_state: ChainState) {
    alloc_locals;

    let (prev_timestamps) = next_prev_timestamps(context);
    let (total_work) = compute_total_work(context);
    let (current_target, epoch_start_time) = adjust_difficulty(context);

    return (
        ChainState(
            context.block_height,
            total_work,
            context.block_hash,
            current_target,
            epoch_start_time,
            prev_timestamps
        ),
    );
}




// Adjust the current_target after about 2 weeks of blocks
// See also:
// - https://en.bitcoin.it/wiki/Difficulty
// - https://en.bitcoin.it/wiki/Target
// - https://github.com/bitcoin/bitcoin/blob/7fcf53f7b4524572d1d0c9a5fdc388e87eb02416/src/pow.cpp#L49
//
func adjust_difficulty{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    context: BlockHeaderValidationContext) -> (current_target:felt, epoch_start_time:felt){
    alloc_locals;
    let current_target = context.prev_chain_state.current_target;

    let (_, position_in_epoch) = unsigned_div_rem(context.block_height, BLOCKS_PER_EPOCH);
    if (position_in_epoch == BLOCKS_PER_EPOCH - 1) {
        // This is the last block of the current epoch, so we adjust the current_target now.
        
        let state = context.prev_chain_state;

        //
        // This code is ported from Bitcoin Core
        // https://github.com/bitcoin/bitcoin/blob/7fcf53f7b4524572d1d0c9a5fdc388e87eb02416/src/pow.cpp#L49
        //

        let fe_actual_timespan = context.block_header.time - state.epoch_start_time;

        // Limit adjustment step        
        let is_too_large = is_le_felt(EXPECTED_EPOCH_TIMESPAN * 4, fe_actual_timespan);
        let is_too_small = is_le_felt(fe_actual_timespan, EXPECTED_EPOCH_TIMESPAN / 4);

        if (is_too_large == 1){
            tempvar fe_actual_timespan = EXPECTED_EPOCH_TIMESPAN * 4;
        } else {
            if (is_too_small == 1){
                tempvar fe_actual_timespan = EXPECTED_EPOCH_TIMESPAN / 4;
            } else {
                tempvar fe_actual_timespan = fe_actual_timespan;
            }
        }
        let actual_timespan = felt_to_uint256(fe_actual_timespan);

        // Retarget
        let bn_pow_limit = felt_to_uint256(MAX_TARGET);

        let ( fe_target ) = bits_to_target(state.current_target);
        let bn_new = felt_to_uint256( fe_target );

        let (bn_new, _) = uint256_mul( bn_new, actual_timespan );

        let UINT256_MAX_TARGET = felt_to_uint256(EXPECTED_EPOCH_TIMESPAN);
        let (bn_new, _) = uint256_unsigned_div_rem(bn_new, UINT256_MAX_TARGET);

        let (next_target) = target_to_bits(bn_new.low + bn_new.high * 2**128);

        // Return next target and reset the epoch start time
        return (next_target, context.block_header.time);
    } else {
        return (current_target, context.prev_chain_state.epoch_start_time);
    }
}


// Calculate bits from target
//
func target_to_bits{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(target) -> (bits: felt) {
    alloc_locals;
    local bits;
    
    %{
        def target_to_bits(target):
            if target == 0:
                return 0
            target = min(target, ids.MAX_TARGET)
            size = (target.bit_length() + 7) // 8
            mask64 = 0xffffffffffffffff
            if size <= 3:
                compact = (target & mask64) << (8 * (3 - size))
            else:
                compact = (target >> (8 * (size - 3))) & mask64

            if compact & 0x00800000:
                compact >>= 8
                size += 1
            assert compact == (compact & 0x007fffff)
            assert size < 256
            return compact | size << 24

        ids.bits = target_to_bits(ids.target)
    %}

    // We need to perform 24 right-shifts
    // So we need only the 8 most significative bits.

    // To do so, first we need a mask with the first 8 bits:
    const MASK_BITS_TO_SHIFT = 0xFF000000;
    // Then, using a bitwise and to get only the first 8 bits.
    let (bits_to_shift) = bitwise_and(bits, MASK_BITS_TO_SHIFT);
    // And finally, do the shifts
    let quotient = bits_to_shift / 0x1000000;

    let (expected_target) = bits_to_target(bits);

    let is_greater_than_2 = (2 - quotient) * (1 - quotient) * quotient;
    if (is_greater_than_2 == 0) {
        return (bits=bits);
    } else {
        // if exponent >= 3 we check that
        // ((target & (threshold * 0xffffff)) - expected_target) == 0
        let (threshold) = pow(BYTE, quotient - 3);
        let mask = threshold * 0xffffff;
        let (masked_target) = bitwise_and(target, mask);

        let diff = masked_target - expected_target;
        assert diff = 0;
        return (bits=bits);
    }
}

// Convert a felt to a Uint256
//
func felt_to_uint256{range_check_ptr}(value) -> Uint256{
    let (high, low) = split_felt(value);
    let value256 = Uint256(low, high);
    return value256;
}
