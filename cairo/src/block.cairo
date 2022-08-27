# Validation of Bitcoin Blocks
#
# We do not implement block serialization here because 
# we never hash a block all at once but only its header and transactions.
#
# See also: 
# - Reference: https://developer.bitcoin.org/reference/block_chain.html#block-chain
# - Bitcoin Core: https://github.com/bitcoin/bitcoin/blob/7fcf53f7b4524572d1d0c9a5fdc388e87eb02416/src/primitives/block.h#L22

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from buffer import Reader, Writer, read_varint
from block_header import BlockHeaderValidationContext, ChainState, read_block_header_validation_context, validate_and_apply_block_header, apply_block_header
from transaction import TransactionValidationContext, read_transaction_validation_context, validate_and_apply_transaction
from merkle_tree import compute_merkle_root
from crypto.sha256d.sha256d import assert_hashes_equal, copy_hash, HASH_FELT_SIZE


# The state of the headers chain and the UTXO set
struct State:
	# The state of the chain of block headers
	member chain_state: ChainState
	# The state of the UTXO set represented in a (fancy) Merkle root hash
	member state_root: felt* 
end


struct BlockValidationContext:
	member header_context: BlockHeaderValidationContext
	member transaction_count: felt
	member transaction_contexts: TransactionValidationContext*
	member prev_state_root: felt*
end


func read_block_validation_context{reader: Reader, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
	prev_state: State) -> (context: BlockValidationContext):
	alloc_locals

	let (header_context) = read_block_header_validation_context(prev_state.chain_state)
	let (transaction_count, _) = read_varint()
	let (transaction_contexts) = read_transaction_validation_contexts(transaction_count)

	return (BlockValidationContext(
		header_context, 
		transaction_count,
		transaction_contexts,
		prev_state.state_root
	))
end


func read_transaction_validation_contexts{reader: Reader, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
	transaction_count) -> (contexts: TransactionValidationContext*):
	alloc_locals

	let (contexts: TransactionValidationContext*) = alloc()
	_read_transaction_validation_contexts_loop(contexts, transaction_count)
	return (contexts)
end


func _read_transaction_validation_contexts_loop{reader: Reader, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
	contexts: TransactionValidationContext*, loop_counter):

	if loop_counter == 0:
		return ()
	end
	let (context) = read_transaction_validation_context()
	assert [contexts] = context

	return _read_transaction_validation_contexts_loop(
		contexts + TransactionValidationContext.SIZE,
		loop_counter - 1
	)
end


# Validate all properties of a block, apply it to the previous state,
# and return the next state
#
# TODO: read the UTXO data required to validate the TX inputs (amounts and such) and verify the corresponding proofs
#
func validate_and_apply_block{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, utxo_data_reader: Reader}(
	context: BlockValidationContext) -> (next_state: State):
	alloc_locals

	let (next_chain_state) = validate_and_apply_block_header(context.header_context)
	validate_merkle_root(context)
	let (next_state_root) = validate_and_apply_transactions(context)
	return ( State(next_chain_state, next_state_root) )
end


# Compute the Merkle root of all transactions in this block
# and validate that it matches the Merkle root in the block header.
func validate_merkle_root{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
	context: BlockValidationContext):
	alloc_locals

	# Copy all transactions' TXIDs into an array
	let (txids) = alloc()
	_copy_txids_into_array_loop(
		context.transaction_contexts, txids, context.transaction_count)
	
	# Compute the Merkle root of the TXIDs
	let (merkle_root) = compute_merkle_root(txids, context.transaction_count)
	
	# Validate that the computed Merkle root 
	# matches the Merkle root in this block's header
	assert_hashes_equal(
		context.header_context.block_header.merkle_root_hash, merkle_root)
	return ()
end


func _copy_txids_into_array_loop(
	tx_contexts: TransactionValidationContext*, txids: felt*, loop_counter):

	if loop_counter == 0:
		return ()
	end
	copy_hash([tx_contexts].txid, txids)
	return _copy_txids_into_array_loop(
		tx_contexts + TransactionValidationContext.SIZE, 
		txids + HASH_FELT_SIZE, 
		loop_counter - 1
	)
end


# Validate that every transaction in this block is valid,
# apply them to the previous state and return the resulting state root
func validate_and_apply_transactions{range_check_ptr, utxo_data_reader: Reader}(
	context: BlockValidationContext) -> (next_state_root : felt*):

	# Validate the coinbase transaction with its special validation rules
	validate_and_apply_coinbase(context)
	
	# Validate all other transactions with the regular validation rules
	let (next_state_root, total_fees) = _validate_and_apply_transactions_loop(
		context.transaction_contexts + TransactionValidationContext.SIZE,
		context.header_context,
		context.prev_state_root,
		0,
		context.transaction_count - 1
	)
	%{ print('Validate total fees', ids.total_fees) %}

	return (next_state_root)
end


func _validate_and_apply_transactions_loop{range_check_ptr, utxo_data_reader: Reader}(
	tx_contexts: TransactionValidationContext*, 
	header_context: BlockHeaderValidationContext, 
	prev_state_root: felt*,
	total_fees,
	loop_counter) -> (next_state_root: felt*, total_fees):

	if loop_counter == 0:
		return (prev_state_root, total_fees)
	end
	
	let (next_state_root, tx_fee) = validate_and_apply_transaction(
		[tx_contexts], header_context, prev_state_root)

	return _validate_and_apply_transactions_loop(
		tx_contexts + TransactionValidationContext.SIZE,
		header_context,
		next_state_root,
		total_fees + tx_fee,
		loop_counter - 1
	)
end


# Validate the format of the coinbase transaction. Also validate that
# the coinbase's output amount is at most the current block reward 
# plus the transaction fees of this block.
#
# See also:
# - https://developer.bitcoin.org/reference/transactions.html#coinbase-input-the-input-of-the-first-transaction-in-a-block
func validate_and_apply_coinbase(context: BlockValidationContext):
	# TODO: implement me
	return ()
end