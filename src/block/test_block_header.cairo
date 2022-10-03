//
// To run only this test suite use:
// protostar test  --cairo-path=./src target src/block/*_block_header*
//

// TODO: Test that a block which does not match its PoW target throws an error

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from python_utils import setup_python_defs
from serialize.serialize import init_reader, init_writer, flush_writer
from crypto.sha256d.sha256d import assert_hashes_equal
from block.block_header import (
    read_block_header,
    bits_to_target, target_to_bits,
    BLOCK_HEADER_FELT_SIZE,
    BlockHeaderValidationContext,
    read_block_header_validation_context,
    validate_and_apply_block_header,
    ChainState,
)

// Test block header serialization
//
// See also:
// - https://developer.bitcoin.org/reference/block_chain.html#block-headers
//
// Example copied from:
// - https://blockstream.info/block/000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728
// - https://blockstream.info/api/block/000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728/header
@external
func test_serialize_block_header{range_check_ptr}() {
    alloc_locals;
    setup_python_defs();

    let (block_header_raw) = alloc();
    %{
        from_hex((
            "02000000b6ff0b1b1680a2862a30ca44d346d9e8910d334beb48ca0c00000000"
            "000000009d10aa52ee949386ca9385695f04ede270dda20810decd12bc9b048a"
            "aab3147124d95a5430c31b18fe9f0864"), ids.block_header_raw)
    %}

    let (reader) = init_reader(block_header_raw);

    let (block_header) = read_block_header{reader=reader}();

    // Test block version
    assert block_header.version = 0x02;

    // Test hash of the previous block
    let (prev_block_hash_expected) = alloc();
    %{
        hashes_from_hex(["00000000000000000cca48eb4b330d91e8d946d344ca302a86a280161b0bffb6"], 
            ids.prev_block_hash_expected)
    %}
    assert_hashes_equal(block_header.prev_block_hash, prev_block_hash_expected);


    return ();
}

// Create a dummy for the previous timestamps
func dummy_prev_timestamps() -> (timestamps: felt*) {
    let (prev_timestamps) = alloc();
    assert prev_timestamps[0] = 0;
    assert prev_timestamps[1] = 1;
    assert prev_timestamps[2] = 2;
    assert prev_timestamps[3] = 3;
    assert prev_timestamps[4] = 4;
    assert prev_timestamps[5] = 5;
    assert prev_timestamps[6] = 6;
    assert prev_timestamps[7] = 7;
    assert prev_timestamps[8] = 8;
    assert prev_timestamps[9] = 9;
    assert prev_timestamps[10] = 10;
    return (prev_timestamps,);
}

// Test a block header validation context
//
//
// Block at height 328734:
// - https://blockstream.info/block/000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728
// - https://blockstream.info/api/block/000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728
// - https://blockstream.info/api/block/000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728/header
//
// Block at height 328733:
// - https://blockstream.info/block/00000000000000000cca48eb4b330d91e8d946d344ca302a86a280161b0bffb6
@external
func test_read_block_header_validation_context{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();


    // Create a dummy for the previous chain state
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
            "00000000000000000cca48eb4b330d91e8d946d344ca302a86a280161b0bffb6"
        ], ids.prev_block_hash)
    %}

    let (prev_timestamps) = dummy_prev_timestamps();
    let prev_chain_state = ChainState(
        block_height = 328733,
        total_work = 0,
        best_block_hash = prev_block_hash,
        difficulty = 0x181bc330,
        epoch_start_time = 0,
        prev_timestamps,
    );

    // Read a block header from the byte stream
    // This is our next chain tip
    let (context) = read_block_header_validation_context(prev_chain_state);

    // Sanity check: block version should be 2
    assert context.block_header.version = 0x02;

    // Check if the target was computed correctly
    assert context.target = 0x1bc330000000000000000000000000000000000000000000;
    // Check if the block hash is correct
    let (block_hash_expected) = alloc();
    %{
        hashes_from_hex([
            "000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728"
            ], ids.block_hash_expected)
    %}
    assert_hashes_equal(context.block_hash, block_hash_expected);

    // Try to validate the block header.
    // This should succeed for valid block headers
    let (next_state) = validate_and_apply_block_header(context);

    // Sanity check for prev_timestamps of next_state
    // First element is the timestamp of this block
    assert next_state.prev_timestamps[0] = 1415239972;
    // Our 2nd element should be the 1st of the dummy
    assert next_state.prev_timestamps[1] = 0;
    // ...
    assert next_state.prev_timestamps[7] = 6;
    // ...
    assert next_state.prev_timestamps[9] = 8;
    // Our 11th element should be the 10th of the dummy
    assert next_state.prev_timestamps[10] = 9;

    return ();
}

@external
func test_bits_to_target{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}() {
    alloc_locals;
    let bits = 0x181bc330;
    let (target) = bits_to_target(bits);
    assert target = 0x1bc330000000000000000000000000000000000000000000;
    return ();
}

@external
func test_target_to_bits{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}() {
    alloc_locals;
    let target = 0x1bc330000000000000000000000000000000000000000000;
    let (bits) = target_to_bits(target);
    assert bits = 0x181bc330;
    return ();
}



// Test a difficulty recalibration
//
//
// Block at height 201599:
// - https://blockstream.info/block/000000000000041fb61665c8a31b8b5c3ae8fe81903ea81530c979d5094e6f9d
// - https://blockstream.info/api/block/000000000000041fb61665c8a31b8b5c3ae8fe81903ea81530c979d5094e6f9d
// - https://blockstream.info/api/block/000000000000041fb61665c8a31b8b5c3ae8fe81903ea81530c979d5094e6f9d/header
//
// Block at height 201598:
// - https://blockstream.info/block/00000000000000ccb28f2e462f46ee762e801995862388f11ba9a682670e7590
@external
func test_recalibrate_difficulty{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();


    // Create a dummy for the previous chain state
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
            "00000000000000ccb28f2e462f46ee762e801995862388f11ba9a682670e7590"
        ], ids.prev_block_hash)
    %}

    // The previous epoch started at the timestamp of the block at height = 201600 - 2016 = 199584
    // https://blockstream.info/block/000000000000002e00a243fe9aa49c78f573091d17372c2ae0ae5e0f24f55b52
    // https://blockstream.info/api/block/000000000000002e00a243fe9aa49c78f573091d17372c2ae0ae5e0f24f55b52
    let epoch_start_time = 1348092851;

    // The difficulty of the previous epoch 
    let prev_difficulty = 0x1a05db8b;

    let (prev_timestamps) = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height = 201598,
        total_work = 0,
        best_block_hash = prev_block_hash,
        difficulty = prev_difficulty,
        epoch_start_time = epoch_start_time,
        prev_timestamps,
    );

    // Read a block header from the byte stream
    // This is our next chain tip
    let (context) = read_block_header_validation_context(prev_chain_state);

    // Sanity check: block version should be 2
    assert context.block_header.version = 0x02;

    // Check if the target was computed correctly
    assert context.target = 0x5db8b0000000000000000000000000000000000000000000000;

    // Check if the block hash is correct
    let (block_hash_expected) = alloc();
    %{
        hashes_from_hex([
            "000000000000041fb61665c8a31b8b5c3ae8fe81903ea81530c979d5094e6f9d"
            ], ids.block_hash_expected)
    %}
    assert_hashes_equal(context.block_hash, block_hash_expected);

    // Try to validate the block header.
    // This should succeed for valid block headers
    let (next_state) = validate_and_apply_block_header(context);

    // Verify that the difficulty was correctly adjusted
    assert next_state.difficulty = 0x1a057e08;
    
    return ();
}