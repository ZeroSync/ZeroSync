//
// To run only this test suite use:
// protostar test  --cairo-path=./src target src/block/*_block_header*
//

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from utils.python_utils import setup_python_defs
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
    compute_work_from_target,
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
    with_attr error_message("Invalid block version.") {
        assert block_header.version = 0x02;
    }

    // Test hash of the previous block
    let (prev_block_hash_expected) = alloc();
    %{
        hashes_from_hex(["00000000000000000cca48eb4b330d91e8d946d344ca302a86a280161b0bffb6"], 
            ids.prev_block_hash_expected)
    %}
    with_attr error_message("Invalid hash of the previous block.") {
        assert_hashes_equal(block_header.prev_block_hash, prev_block_hash_expected);
    }

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
        current_target = 0x181bc330,
        epoch_start_time = 0,
        prev_timestamps,
    );

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();

    // Read a block header from the byte stream
    // This is our next chain tip
    with sha256_ptr {
        let (context) = read_block_header_validation_context(prev_chain_state);
    }

    // Sanity check: block version should be 2
    with_attr error_message("Invalid block version. It should be 2.") {
        assert 0x02 = context.block_header.version;
    }

    // Check if the target was computed correctly
    with_attr error_message("Target computed incorrectly.") {
        assert 0x1bc330000000000000000000000000000000000000000000 = context.target;
    }
    // Check if the block hash is correct
    let (block_hash_expected) = alloc();
    %{
        hashes_from_hex([
            "000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728"
            ], ids.block_hash_expected)
    %}
    with_attr error_message("Invalid block hash.") {
        assert_hashes_equal(context.block_hash, block_hash_expected);
    }

    // Try to validate the block header.
    // This should succeed for valid block headers
    let (next_state) = validate_and_apply_block_header(context);

    // Sanity check for prev_timestamps of next_state
    // First element is the timestamp of this block
    with_attr error_message("The first element does not correspond to the timestamp of the block.") {
        assert 1415239972 = next_state.prev_timestamps[0];
    }
    // Our 2nd element should be the 1st of the dummy
    with_attr error_message("The state does not correspond with the dummy.") {
        assert 0 = next_state.prev_timestamps[1];
    }
    // ...
    with_attr error_message("The state does not correspond with the dummy.") {
        assert 6 = next_state.prev_timestamps[7];
    }
    // ...
    with_attr error_message("The state does not correspond with the dummy.") {
        assert 8 = next_state.prev_timestamps[9];
    }
    // Our 11th element should be the 10th of the dummy
    with_attr error_message("The state does not correspond with the dummy.") {
        assert 9 = next_state.prev_timestamps[10];
    }

    return ();
}

@external
func test_bits_to_target{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}() {
    alloc_locals;
    let bits = 0x181bc330;
    let (target) = bits_to_target(bits);
    with_attr error_message("Invalid target.") {
        assert 0x1bc330000000000000000000000000000000000000000000 = target;
    }
    return ();
}

// Test a current_target adjustment
// After this block the current_target gets adjusted because it is a last block of an epoch.
//
// Block at height 201599 ( because 201599 % 2016 == 2015 )
// - https://blockstream.info/block/000000000000041fb61665c8a31b8b5c3ae8fe81903ea81530c979d5094e6f9d
// - https://blockstream.info/api/block/000000000000041fb61665c8a31b8b5c3ae8fe81903ea81530c979d5094e6f9d
// - https://blockstream.info/api/block/000000000000041fb61665c8a31b8b5c3ae8fe81903ea81530c979d5094e6f9d/header
//
// Block at height 201598:
// - https://blockstream.info/block/00000000000000ccb28f2e462f46ee762e801995862388f11ba9a682670e7590
//
@external
func test_adjust_current_target{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
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

    // The current_target of the previous epoch 
    let prev_current_target = 0x1a05db8b;

    let (prev_timestamps) = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height = 201598,
        total_work = 0,
        best_block_hash = prev_block_hash,
        current_target = prev_current_target,
        epoch_start_time = epoch_start_time,
        prev_timestamps,
    );

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();

    // Read a block header from the byte stream
    // This is our next chain tip
    with sha256_ptr {
        let (context) = read_block_header_validation_context(prev_chain_state);
    }

    // Sanity check: block version should be 2
    with_attr error_message("Invalid block version.") {
        assert 0x02 = context.block_header.version;
    }

    // Check if the target was computed correctly
    assert context.target = 0x5db8b0000000000000000000000000000000000000000000000;

    // Check if the block hash is correct
    let (block_hash_expected) = alloc();
    %{
        hashes_from_hex([
            "000000000000041fb61665c8a31b8b5c3ae8fe81903ea81530c979d5094e6f9d"
            ], ids.block_hash_expected)
    %}

    with_attr error_message("invalid block hash") {
        assert_hashes_equal(context.block_hash, block_hash_expected);
    }

    // Try to validate the block header.
    // This should succeed for valid block headers
    let (next_state) = validate_and_apply_block_header(context);

    // Verify that the current_target was correctly adjusted
    with_attr error_message("The current_target wasn't adjusted correctly.") {
        assert 0x1a057e08 = next_state.current_target;
    }
    
    return ();
}

@external
func test_insufficient_pow{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();
    
    // Block hashes for block 0 and 1
    // https://blockstream.info/block/00000000839a8e6886ab5951d76f411475428afc90947ee320161bbf18eb6048
    // https://blockstream.info/block/000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f
    let (prev_block_hash) = alloc();
    let (block_hash_expected) = alloc();
    %{
        hashes_from_hex([
            "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f"
        ], ids.prev_block_hash)
        hashes_from_hex([
            "00000000839a8e6886ab5951d76f411475428afc90947ee320161bbf18eb6048"
            ], ids.block_hash_expected)
    %}

    // Run a sanity check that header validation does not error with correct pow.
    let (prev_timestamps) = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height = 0,
        total_work = 0,
        best_block_hash = prev_block_hash,
        current_target = 0x1d00ffff,
        epoch_start_time = 0,
        prev_timestamps,
    );

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();

    // Block 1 will be read here.
    with sha256_ptr {
        let (context) = read_block_header_validation_context(prev_chain_state);
    }
    
    // Check if the block hash is correct.
    with_attr error_message("Invalid block hash.") {
        assert_hashes_equal(context.block_hash, block_hash_expected);
    }

    // Try to validate the block header.
    // This should succeed for the currently correct target.
    with sha256_ptr {
        let (next_state) = validate_and_apply_block_header(context);
    }

    // Run a test with manipulated target.
    let (prev_timestamps) = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height = 0,
        total_work = 0,
        best_block_hash = prev_block_hash,
        current_target = 0x1d00ffff,
        epoch_start_time = 0,
        prev_timestamps,
    );

    // Block 1 will be read here.
    with sha256_ptr {
        let (context) = read_block_header_validation_context(prev_chain_state);
    }

    // Check if the block hash is correct
    with_attr error_message("Invalid block hash.") {
        assert_hashes_equal(context.block_hash, block_hash_expected);
    }

    // Manipulate the target and set it to 1.
    let low_target_context = BlockHeaderValidationContext(
        block_header = context.block_header,
        block_hash = context.block_hash,
        target = 1,
        prev_chain_state = context.prev_chain_state,
        block_height = context.block_height
    );
    
    // Try to validate the block header.
    // This should fail now because of the low target and pow validation.
    %{ expect_revert() %}
    let (next_state) = validate_and_apply_block_header(low_target_context);
    
    return ();
}

@external
func test_compute_work_from_target1{range_check_ptr}() {
    let expected_work = 0x0100010001;
    let target = 0x00000000ffff0000000000000000000000000000000000000000000000000000;
    let (work) = compute_work_from_target(target);
    assert expected_work = work;

    return ();
}

@external
func test_compute_work_from_target2{range_check_ptr}() {
    let expected_work = 0x26d946e509ac00026d;
    let target = 0x00000000000000000696f4000000000000000000000000000000000000000000;
    let (work) = compute_work_from_target(target);
    assert expected_work = work;

    return ();
}

@external
func test_compute_work_from_target3{range_check_ptr}() {
    let expected_work = 0xe10005d2a0269364ff907d1d1d3ce0e1b351d743fe3222740c2440d07;
    let target = 0x12345600;
    let (work) = compute_work_from_target(target);
    assert expected_work = work;

    return ();
}

@external
func test_compute_work_from_target4{range_check_ptr}() {
    let expected_work = 0x1c040c95d1a74d2e27abbbd2255f66c9db2cad7511eb970cd4dac39e4;
    let target = 0x92340000;
    let (work) = compute_work_from_target(target);
    assert expected_work = work;

    return ();
}

@external
func test_compute_work_from_target5{range_check_ptr}() {
    let expected_work = 0x21809b468faa88dbe34f;
    let target = 0x00000000000000000007a4290000000000000000000000000000000000000000;
    let (work) = compute_work_from_target(target);
    assert expected_work = work;

    return ();
}
