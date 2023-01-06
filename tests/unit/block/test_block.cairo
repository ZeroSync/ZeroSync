//
// To run only this test suite use:
// protostar test --cairo-path=./src target tests/unit/block/*_block.cairo
//
// Note that you have to run the bridge node to make all these tests pass
//

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

from utils.python_utils import setup_python_defs
from crypto.sha256 import finalize_sha256
from transaction.transaction import TransactionValidationContext
from block.block_header import ChainState
from utxo_set.utreexo import utreexo_init, utreexo_add
from utils.serialize import init_reader
from tests.unit.block.utxo_dummies.utils import dummy_utxo_insert_block_number, reset_bridge_node
from block.block import (
    BlockValidationContext,
    State,
    read_block_validation_context,
    validate_and_apply_block,
    compute_block_reward,
)

// Create a dummy for the previous timestamps
func dummy_prev_timestamps() -> felt* {
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
    return prev_timestamps;
}

// Test a simple Bitcoin block with only a single transaction.
//
// Example: Block at height 6425
//
// - Block hash: 000000004d15e01d3ffc495df7bb638c2b35c5b5dd0ba405615f513e3393f0c7
// - Block explorer: https://blockstream.info/block/000000004d15e01d3ffc495df7bb638c2b35c5b5dd0ba405615f513e3393f0c7
// - Stackoverflow: https://stackoverflow.com/questions/67631407/raw-or-hex-of-a-whole-bitcoin-block
// - Blockchair: https://api.blockchair.com/bitcoin/raw/block/000000004d15e01d3ffc495df7bb638c2b35c5b5dd0ba405615f513e3393f0c7
@external
func test_verify_block_with_1_transaction{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, pedersen_ptr: HashBuiltin*
}() {
    alloc_locals;
    setup_python_defs();
    reset_bridge_node();

    // Create a dummy for the previous chain state
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
                "00000000ddc2c05eeaa044dcd039cd68c74f2747f8fe38b2f08a511634ead4a0"
        ], ids.prev_block_hash)
    %}

    let prev_timestamps = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height=6424,
        total_work=0,
        best_block_hash=prev_block_hash,
        current_target=0x1d00ffff,
        epoch_start_time=0,
        prev_timestamps,
    );
    let utreexo_roots = utreexo_init();

    let prev_state = State(prev_chain_state, utreexo_roots);

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;

    // Parse the block validation context
    with sha256_ptr {
        let context = read_block_validation_context(prev_state);
        validate_and_apply_block{hash_ptr=pedersen_ptr}(context);
        finalize_sha256(sha256_ptr_start, sha256_ptr);
    }
    return ();
}

// Test a Bitcoin block with 4 transactions.
//
// Example: Block at height 100000
//
// - Block hash: 000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506
// - Block explorer: https://blockstream.info/block/000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506
// - Stackoverflow: https://stackoverflow.com/questions/67631407/raw-or-hex-of-a-whole-bitcoin-block
// - Blockchair: https://api.blockchair.com/bitcoin/raw/block/000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506
@external
func test_verify_block_with_4_transactions{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, pedersen_ptr: HashBuiltin*
}() {
    alloc_locals;
    setup_python_defs();
    reset_bridge_node();

    // Create a dummy for the previous chain state
    // Block 99999: https://blockstream.info/block/000000000002d01c1fccc21636b607dfd930d31d01c3a62104612a1719011250
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
                "000000000002d01c1fccc21636b607dfd930d31d01c3a62104612a1719011250"
        ], ids.prev_block_hash)
    %}

    let prev_timestamps = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height=99999,
        total_work=0,
        best_block_hash=prev_block_hash,
        current_target=0x1b04864c,
        epoch_start_time=0,
        prev_timestamps,
    );

    // We need some UTXOs to spend in this block
    let utreexo_roots = utreexo_init();
    dummy_utxo_insert_block_number{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(100000);

    let prev_state = State(prev_chain_state, utreexo_roots);

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;

    // Parse the block validation context using the previous state
    with sha256_ptr {
        let context = read_block_validation_context(prev_state);
    }

    // Sanity Check
    // The second output of the second transaction should be 44.44 BTC
    let transaction = context.transaction_contexts[1].transaction;
    assert 4444 * 10 ** 6 = transaction.outputs[1].amount;

    // Validate the block
    with sha256_ptr {
        let next_state = validate_and_apply_block{hash_ptr=pedersen_ptr}(context);
        finalize_sha256(sha256_ptr_start, sha256_ptr);
    }

    return ();
}

// Test a Bitcoin block with 27 transactions.
//
// Example: Block at height 170000
//
// - Block hash: 000000000000051f68f43e9d455e72d9c4e4ce52e8a00c5e24c07340632405cb
// - Block explorer: https://blockstream.info/block/000000000000051f68f43e9d455e72d9c4e4ce52e8a00c5e24c07340632405cb
// - Blockchair: https://api.blockchair.com/bitcoin/raw/block/000000000000051f68f43e9d455e72d9c4e4ce52e8a00c5e24c07340632405cb
// @external
func test_verify_block_with_27_transactions{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, pedersen_ptr: HashBuiltin*
}() {
    alloc_locals;
    setup_python_defs();
    reset_bridge_node();

    // Create a dummy for the previous chain state
    // Block 169999: https://blockstream.info/block/000000000000096b85408520f97770876fc88944b8cc72083a6e6dca9f167b33
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
                "000000000000096b85408520f97770876fc88944b8cc72083a6e6dca9f167b33"
        ], ids.prev_block_hash)
    %}

    let prev_timestamps = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height=169999,
        total_work=0,
        best_block_hash=prev_block_hash,
        current_target=0x1a0b350c,
        epoch_start_time=0,
        prev_timestamps,
    );

    // We need some UTXOs to spend in this block
    reset_bridge_node();
    let utreexo_roots = utreexo_init();
    dummy_utxo_insert_block_number{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(170000);

    let prev_state = State(prev_chain_state, utreexo_roots);

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;

    // Parse the block validation context using the previous state
    with sha256_ptr {
        let context = read_block_validation_context(prev_state);
    }

    // Sanity Check
    // Transaction count should be 27
    assert 27 = context.transaction_count;

    // Sanity Check
    // The second output of the second transaction should be 54.46 BTC
    let transaction = context.transaction_contexts[1].transaction;
    assert 5446 * 10 ** 6 = transaction.outputs[1].amount;

    // Validate the block
    with sha256_ptr {
        validate_and_apply_block{hash_ptr=pedersen_ptr}(context);
        finalize_sha256(sha256_ptr_start, sha256_ptr);
    }
    return ();
}

// Test a Bitcoin block with 49 transactions.
//
// Example: Block at height 328734
//
// - Block hash: 000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728
// - Block explorer: https://blockstream.info/block/000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728
// - Blockchair: https://api.blockchair.com/bitcoin/raw/block/000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728
// @external
func test_verify_block_with_49_transactions{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, pedersen_ptr: HashBuiltin*
}() {
    alloc_locals;
    setup_python_defs();

    // Create a dummy for the previous chain state
    // Block 328733: https://blockstream.info/block/00000000000000000cca48eb4b330d91e8d946d344ca302a86a280161b0bffb6
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
                "00000000000000000cca48eb4b330d91e8d946d344ca302a86a280161b0bffb6"
        ], ids.prev_block_hash)
    %}

    let prev_timestamps = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height=328733,
        total_work=0,
        best_block_hash=prev_block_hash,
        current_target=0x181bc330,
        epoch_start_time=0,
        prev_timestamps,
    );

    // We need some UTXOs to spend in this block
    reset_bridge_node();
    let utreexo_roots = utreexo_init();
    dummy_utxo_insert_block_number{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(328734);

    let prev_state = State(prev_chain_state, utreexo_roots);

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;

    // Parse the block validation context using the previous state
    with sha256_ptr {
        let context = read_block_validation_context(prev_state);
    }

    // Sanity Check
    // Transaction count should be 49
    assert 49 = context.transaction_count;

    // Sanity Check
    // The second output of the second transaction should be 0.11883137 BTC

    let transaction = context.transaction_contexts[1].transaction;
    assert transaction.outputs[1].amount = 11883137;

    // Validate the block
    with sha256_ptr {
        validate_and_apply_block{hash_ptr=pedersen_ptr}(context);
        finalize_sha256(sha256_ptr_start, sha256_ptr);
    }
    return ();
}

// TODO: Add tests between 49 and 2496 transactions

// Test a Bitcoin block with 108 transactions.
//
// Example: Block at height 222224
//
// - Block hash: 00000000000000ae408a0d645b4a2dafdb886e46add4963ac0b4b10cb4c95d26
// - Block explorer: https://blockstream.info/block/00000000000000ae408a0d645b4a2dafdb886e46add4963ac0b4b10cb4c95d26
// @external
func test_verify_block_with_108_transactions{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, pedersen_ptr: HashBuiltin*
}() {
    alloc_locals;
    setup_python_defs();

    // Create a dummy for the previous chain state
    // Block 222223: https://blockstream.info/block/00000000000000ae408a0d645b4a2dafdb886e46add4963ac0b4b10cb4c95d26
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
                "000000000000011dd201c22edad20e9945440fce0b5d991a3afcc16ab789ecf5"
        ], ids.prev_block_hash)
    %}

    let prev_timestamps = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height=222223,
        total_work=0,
        best_block_hash=prev_block_hash,
        current_target=0x1a04985c,
        epoch_start_time=0,
        prev_timestamps,
    );

    // We need some UTXOs to spend in this block
    reset_bridge_node();
    let utreexo_roots = utreexo_init();
    dummy_utxo_insert_block_number{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(222224);

    let prev_state = State(prev_chain_state, utreexo_roots);

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;

    // Parse the block validation context using the previous state
    with sha256_ptr {
        let context = read_block_validation_context(prev_state);
    }

    // Sanity Check
    // Transaction count should be 108
    assert 108 = context.transaction_count;

    // Sanity Check
    // The second output of the second transaction should be 2000 BTC

    let transaction = context.transaction_contexts[1].transaction;
    assert transaction.outputs[1].amount = 2 * 10 ** 11;

    // Validate the block
    with sha256_ptr {
        validate_and_apply_block{hash_ptr=pedersen_ptr}(context);
        finalize_sha256(sha256_ptr_start, sha256_ptr);
    }
    return ();
}

// Test a Bitcoin block with 933 transactions.
//
// Example: Block at height 383838
//
// - Block hash: 00000000000000000e9b42248aa61593ccc4aa0a399b3cb6b50c650f45761c3a
// - Block explorer: https://blockstream.info/block/00000000000000000e9b42248aa61593ccc4aa0a399b3cb6b50c650f45761c3a
// @external
func test_verify_block_with_933_transactions{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, pedersen_ptr: HashBuiltin*
}() {
    alloc_locals;
    setup_python_defs();

    // Create a dummy for the previous chain state
    // Block 383837: https://blockstream.info/block/0000000000000000017b5c4e4fcf210dec65fc67cbfdd841a1af77f178bb7ab7
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
                "0000000000000000017b5c4e4fcf210dec65fc67cbfdd841a1af77f178bb7ab7"
        ], ids.prev_block_hash)
    %}

    let prev_timestamps = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height=383837,
        total_work=0,
        best_block_hash=prev_block_hash,
        current_target=0x1810b289,
        epoch_start_time=0,
        prev_timestamps,
    );

    // We need some UTXOs to spend in this block
    reset_bridge_node();
    let utreexo_roots = utreexo_init();
    dummy_utxo_insert_block_number{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(383838);

    let prev_state = State(prev_chain_state, utreexo_roots);

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;

    // Parse the block validation context using the previous state
    with sha256_ptr {
        let context = read_block_validation_context(prev_state);
    }

    // Sanity Check
    // Transaction count should be 933
    assert 933 = context.transaction_count;

    // Sanity Check
    // The second output of the second transaction should be 8.96275171 BTC

    let transaction = context.transaction_contexts[1].transaction;
    assert transaction.outputs[1].amount = 896275171;

    // Validate the block
    with sha256_ptr {
        validate_and_apply_block{hash_ptr=pedersen_ptr}(context);
        finalize_sha256(sha256_ptr_start, sha256_ptr);
    }
    return ();
}

// Test a Bitcoin block with 2496 transactions.
//
// Example: Block at height 750000
//
// Note: This requires a lot of steps (so memory and time).
//
// - Block hash: 00000000000000000001e3aee44a04a5c3461181d25c8803ff6d617173e34533
// - Block explorer: https://blockstream.info/block/0000000000000000000592a974b1b9f087cb77628bb4a097d5c2c11b3476a58e
// - Blockchair: https://api.blockchair.com/bitcoin/raw/block/0000000000000000000592a974b1b9f087cb77628bb4a097d5c2c11b3476a58e
// @external
func test_verify_block_with_2496_transactions{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, pedersen_ptr: HashBuiltin*
}() {
    alloc_locals;
    setup_python_defs();

    // Create a dummy for the previous chain state
    // Block 749999: https://blockstream.info/block/00000000000000000001e3aee44a04a5c3461181d25c8803ff6d617173e34533
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
                "00000000000000000001e3aee44a04a5c3461181d25c8803ff6d617173e34533"
        ], ids.prev_block_hash)
    %}

    let prev_timestamps = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height=749999,
        total_work=0,
        best_block_hash=prev_block_hash,
        current_target=0x1709ed88,
        epoch_start_time=0,
        prev_timestamps,
    );
    // We need some UTXOs to spend in this block
    reset_bridge_node();
    let utreexo_roots = utreexo_init();
    dummy_utxo_insert_block_number{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(750000);

    let prev_state = State(prev_chain_state, utreexo_roots);

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;

    // Parse the block validation context using the previous state
    with sha256_ptr {
        let context = read_block_validation_context(prev_state);
    }

    // Sanity Check
    // Transaction count should be 49
    assert 2496 = context.transaction_count;

    // Sanity Check
    // The second output of the third transaction should be 0.01071525 BTC

    let transaction = context.transaction_contexts[2].transaction;
    assert 1071525 = transaction.outputs[1].amount;

    // Validate the block
    with sha256_ptr {
        validate_and_apply_block{hash_ptr=pedersen_ptr}(context);
        finalize_sha256(sha256_ptr_start, sha256_ptr);
    }
    return ();
}

@external
func test_block_reward{range_check_ptr}() {
    alloc_locals;

    let result1 = compute_block_reward(0);
    assert result1 = 50 * 10 ** 8;

    let result2 = compute_block_reward(42);
    assert result2 = 50 * 10 ** 8;

    let result3 = compute_block_reward(210000);
    assert result3 = 25 * 10 ** 8;

    // current reward
    let result4 = compute_block_reward(787520);
    assert result4 = 625 * 10 ** 6;

    // when we start rounding
    let result5 = compute_block_reward(2100000);
    assert result5 = 4882812;

    // last halving
    let result6 = compute_block_reward(6720000);
    assert result6 = 1;

    // reward gets 0
    let result7 = compute_block_reward(6930000);
    assert result7 = 0;

    return ();
}
