// Validation of Bitcoin Blocks
//
// We do not implement block serialization here because
// we never hash a block all at once but only its header and transactions.
//
// See also:
// - Reference: https://developer.bitcoin.org/reference/block_chain.html#block-chain
// - Bitcoin Core: https://github.com/bitcoin/bitcoin/blob/7fcf53f7b4524572d1d0c9a5fdc388e87eb02416/src/primitives/block.h#L22

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.math import assert_le, unsigned_div_rem
from starkware.cairo.common.memset import memset
from utils.pow2 import pow2

from serialize.serialize import Reader, Writer, read_varint
from block.block_header import (
    BlockHeaderValidationContext,
    ChainState,
    read_block_header_validation_context,
    validate_and_apply_block_header,
    apply_block_header,
)
from transaction.transaction import (
    TransactionValidationContext,
    read_transaction_validation_context,
    validate_and_apply_transaction,
    validate_outputs_loop,
)
from block.merkle_tree import compute_merkle_root
from crypto.sha256d.sha256d import assert_hashes_equal, copy_hash, HASH_FELT_SIZE

// The state of the headers chain and the UTXO set
struct State {
    // The state of the chain of block headers
    chain_state: ChainState,
    // The UTXO set represented as the roots of all trees in a Utreexo forest
    utreexo_roots: felt*,
}

struct BlockValidationContext {
    header_context: BlockHeaderValidationContext,
    transaction_count: felt,
    transaction_contexts: TransactionValidationContext*,
    prev_utreexo_roots: felt*,
}
func fetch_transaction_count(block_height) -> felt {
    alloc_locals;
    local transaction_count;

    %{
        import urllib3
        import json
        http = urllib3.PoolManager()

        url = 'https://blockstream.info/api/block-height/' + str(ids.block_height)
        r = http.request('GET', url)
        block_hash = str(r.data, 'utf-8')

        url = f'https://blockstream.info/api/block/{ block_hash }' 
        r = http.request('GET', url)
        block = json.loads(r.data)

        ids.transaction_count = block["tx_count"]
    %}
    return transaction_count;
}

func read_block_validation_context{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, sha256_ptr: felt*
}(prev_state: State) -> BlockValidationContext {
    alloc_locals;

    let header_context = read_block_header_validation_context(prev_state.chain_state);

    let block_height = prev_state.chain_state.block_height + 1;
    let transaction_count = fetch_transaction_count(block_height);
    let transaction_contexts = read_transaction_validation_contexts(
        block_height, transaction_count
    );

    let ctx = BlockValidationContext(
        header_context, transaction_count, transaction_contexts, prev_state.utreexo_roots
    );
    return ctx;
}

func read_transaction_validation_contexts{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, sha256_ptr: felt*
}(block_height, transaction_count) -> TransactionValidationContext* {
    alloc_locals;

    let (contexts: TransactionValidationContext*) = alloc();
    _read_transaction_validation_contexts_loop(
        contexts, block_height, transaction_count, transaction_count
    );
    return contexts;
}

func _read_transaction_validation_contexts_loop{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, sha256_ptr: felt*
}(contexts: TransactionValidationContext*, block_height, loop_counter, transaction_count) {
    if (loop_counter == 0) {
        return ();
    }

    let context = read_transaction_validation_context(
        block_height, transaction_count - loop_counter
    );
    assert [contexts] = context;

    return _read_transaction_validation_contexts_loop(
        contexts + TransactionValidationContext.SIZE,
        block_height,
        loop_counter - 1,
        transaction_count,
    );
}

// Validate all properties of a block, apply it to the previous state,
// and return the next state
//
func validate_and_apply_block{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, hash_ptr: HashBuiltin*, sha256_ptr: felt*
}(context: BlockValidationContext) -> State {
    alloc_locals;

    let next_chain_state = validate_and_apply_block_header(context.header_context);
    validate_merkle_root(context);
    let utreexo_roots = context.prev_utreexo_roots;
    validate_and_apply_transactions{utreexo_roots=utreexo_roots}(context);
    let state = State(next_chain_state, utreexo_roots);
    return state;
}

// Compute the Merkle root of all transactions in this block
// and validate that it matches the Merkle root in the block header.
func validate_merkle_root{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, sha256_ptr: felt*}(
    context: BlockValidationContext
) {
    alloc_locals;

    // Copy all transactions' TXIDs into an array
    let (txids) = alloc();
    _copy_txids_into_array_loop(context.transaction_contexts, txids, context.transaction_count);

    // Compute the Merkle root of the TXIDs
    let merkle_root = compute_merkle_root(txids, context.transaction_count);

    // Validate that the computed Merkle root
    // matches the Merkle root in this block's header
    with_attr error_message(
            "Computed Merkle root doesn't match the Merkle root in the block's header.") {
        assert_hashes_equal(context.header_context.block_header.merkle_root_hash, merkle_root);
    }
    return ();
}

func _copy_txids_into_array_loop(
    tx_contexts: TransactionValidationContext*, txids: felt*, loop_counter
) {
    if (loop_counter == 0) {
        return ();
    }
    copy_hash([tx_contexts].txid, txids);
    return _copy_txids_into_array_loop(
        tx_contexts + TransactionValidationContext.SIZE, txids + HASH_FELT_SIZE, loop_counter - 1
    );
}

// Validate that every transaction in this block is valid,
// apply them to the previous state and return the resulting state root
func validate_and_apply_transactions{range_check_ptr, hash_ptr: HashBuiltin*, utreexo_roots: felt*}(
    context: BlockValidationContext
) {
    alloc_locals;

    // Validate all transactions except for the coinbase with the regular validation rules
    let total_fees = _validate_and_apply_transactions_loop(
        context.transaction_contexts + TransactionValidationContext.SIZE,
        context.header_context,
        0,
        context.transaction_count - 1,
    );

    // Validate the coinbase transaction with its special validation rules
    validate_and_apply_coinbase(context, total_fees);

    return ();
}

func _validate_and_apply_transactions_loop{
    range_check_ptr, hash_ptr: HashBuiltin*, utreexo_roots: felt*
}(
    tx_contexts: TransactionValidationContext*,
    header_context: BlockHeaderValidationContext,
    total_fees,
    loop_counter,
) -> felt {
    if (loop_counter == 0) {
        return total_fees;
    }

    alloc_locals;
    let tx_fee = validate_and_apply_transaction([tx_contexts], header_context);

    return _validate_and_apply_transactions_loop(
        tx_contexts + TransactionValidationContext.SIZE,
        header_context,
        total_fees + tx_fee,
        loop_counter - 1,
    );
}

// Validate the format of the coinbase transaction. Also validate that
// the coinbase's output amount is at most the current block reward
// plus the transaction fees of this block.
//
// See also:
// - https://developer.bitcoin.org/reference/transactions.html#coinbase-input-the-input-of-the-first-transaction-in-a-block
// - https://bitcoin.stackexchange.com/questions/20721/what-is-the-format-of-the-coinbase-transaction
func validate_and_apply_coinbase{range_check_ptr, hash_ptr: HashBuiltin*, utreexo_roots: felt*}(
    context: BlockValidationContext, total_fees
) {
    alloc_locals;

    let tx_context = context.transaction_contexts[0];

    // / Validate the coinbase input
    // Ensure there is exactly one coinbase input
    with_attr error_message("`input_count` of coinbase should be 1") {
        assert 1 = tx_context.transaction.input_count;
    }
    // Ensure the input's vout is 0xFFFFFFFF
    with_attr error_message("`vout` of coinbase input should be 0xFFFFFFFF") {
        assert 0xFFFFFFFF = tx_context.transaction.inputs[0].vout;
    }
    // Ensure the input's TXID is zero
    with_attr error_message("`txid` of coinbase input should be 0") {
        // Using `memset` as hack for `assert`
        memset(tx_context.transaction.inputs[0].txid, 0x00000000, 8);
    }

    // / Validate the outputs' amounts
    // Sum up the total amount of all outputs
    // and also add the outputs to the UTXO set.
    let total_output_amount = validate_outputs_loop(
        tx_context, tx_context.transaction.outputs, 0, 0, tx_context.transaction.output_count
    );
    // Ensure the total amount is at most the block reward + TX fees
    let block_reward = compute_block_reward(context.header_context.block_height);
    with_attr error_message("`total_output_amount <= block_reward + total_fees` should be true") {
        assert_le(total_output_amount, block_reward + total_fees);
    }

    // TODO: implement BIP34
    return ();
}

// Compute the miner's block reward with respect to the block height
//
func compute_block_reward{range_check_ptr}(block_height) -> felt {
    let (number_halvings, _) = unsigned_div_rem(block_height, 210000);
    let denominator = pow2(number_halvings);
    let (block_reward, _) = unsigned_div_rem(50 * 10 ** 8, denominator);
    return block_reward;
}
