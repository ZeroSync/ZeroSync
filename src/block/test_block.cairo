//
// To run only this test suite use:
// protostar test --cairo-path=./src target src/block/*_block.cairo
//
// Note that you have to run the bridge node to make all this tests pass
//

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

from python_utils import setup_python_defs
from transaction.transaction import TransactionValidationContext
from block.block_header import ChainState
from block.block import (
    BlockValidationContext,
    State,
    read_block_validation_context,
    validate_and_apply_block,
)
from utreexo.utreexo import utreexo_init, utreexo_add

from serialize.serialize import init_reader


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

    // Create a dummy for the previous chain state
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
            "00000000ddc2c05eeaa044dcd039cd68c74f2747f8fe38b2f08a511634ead4a0"
        ], ids.prev_block_hash)
    %}

    let (prev_timestamps) = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height=6424,
        total_work=0,
        best_block_hash=prev_block_hash,
        difficulty=0,
        epoch_start_time=0,
        prev_timestamps,
    );
    let (utreexo_roots) = utreexo_init();

    let prev_state = State(prev_chain_state, utreexo_roots);

    // Parse the block validation context
    let (context) = read_block_validation_context(prev_state);

    validate_and_apply_block{hash_ptr=pedersen_ptr}(context);
    return ();
}

func dummy_utxo_insert{hash_ptr: HashBuiltin*, utreexo_roots: felt*}(hash) {
    %{
        import urllib3
        http = urllib3.PoolManager()
        hex_hash = hex(ids.hash).replace('0x','')
        url = 'http://localhost:2121/add/' + hex_hash
        r = http.request('GET', url)
    %}

    utreexo_add(hash);
    return ();
}

func reset_bridge_node() {
    %{
        import urllib3
        http = urllib3.PoolManager()
        url = 'http://localhost:2121/reset/'
        r = http.request('GET', url)
    %}
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

    // Create a dummy for the previous chain state
    // Block 99999: https://blockstream.info/block/000000000002d01c1fccc21636b607dfd930d31d01c3a62104612a1719011250
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
            "000000000002d01c1fccc21636b607dfd930d31d01c3a62104612a1719011250"
        ], ids.prev_block_hash)
    %}

    let (prev_timestamps) = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height=99999,
        total_work=0,
        best_block_hash=prev_block_hash,
        difficulty=0,
        epoch_start_time=0,
        prev_timestamps,
    );

    // We need some UTXOs to spend in this block
    reset_bridge_node();
    let (prev_utreexo_roots) = utreexo_init();
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(
        0x2d3ef8215980ca7bfe3aea785eb7a2f234eb33418ef4bc87683ca23287cd309
    );
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(
        0x1aa9272136be702146acae34cf02dfaed63288404e0e5842ae3b60341848779
    );
    dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(
        0x75f708000a3e08f9d6f01ced23f5e5d510bdf6dfa6d4447858586d4026b516e
    );

    let prev_state = State(prev_chain_state, prev_utreexo_roots);

    // Parse the block validation context using the previous state
    let (context) = read_block_validation_context(prev_state);

    // Sanity Check
    // The second output of the second transaction should be 44.44 BTC
    let transaction = context.transaction_contexts[1].transaction;
    assert transaction.outputs[1].amount = 4444 * 10 ** 6;

    // Validate the block
    let (next_state) = validate_and_apply_block{hash_ptr=pedersen_ptr}(context);

    %{
        # addr = ids.next_state.utreexo_roots
        # print('Next state root:', memory[addr], memory[addr + 1], memory[addr + 2], memory[addr + 3])
    %}
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

    // Create a dummy for the previous chain state
    // Block 299999: https://blockstream.info/block/000000000000096b85408520f97770876fc88944b8cc72083a6e6dca9f167b33
    let (prev_block_hash) = alloc();
    %{
        hashes_from_hex([
            "000000000000096b85408520f97770876fc88944b8cc72083a6e6dca9f167b33"
        ], ids.prev_block_hash)
    %}

    let (prev_timestamps) = dummy_prev_timestamps();

    let prev_chain_state = ChainState(
        block_height=169999,
        total_work=0,
        best_block_hash=prev_block_hash,
        difficulty=0,
        epoch_start_time=0,
        prev_timestamps,
    );

    // We need some UTXOs to spend in this block
    reset_bridge_node();
    let (utreexo_roots) = utreexo_init();

    let prev_state = State(prev_chain_state, utreexo_roots);

    // Parse the block validation context using the previous state
    let (context) = read_block_validation_context(prev_state);

    // Sanity Check
    // Transaction count should be 27
    assert context.transaction_count = 27;

    // Sanity Check
    // The second output of the second transaction should be 54.46 BTC
    let transaction = context.transaction_contexts[1].transaction;
    assert transaction.outputs[1].amount = 5446 * 10 ** 6;

    // Validate the block
    // validate_and_apply_block{hash_ptr = pedersen_ptr}(context)
    return ();
}
