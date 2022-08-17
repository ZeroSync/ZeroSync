# Validation of Bitcoin Blocks
#
# We do not implement block serialization here because 
# we never hash a block all at once but only its header and transactions.
#
# See also: 
# - Reference: https://developer.bitcoin.org/reference/block_chain.html#block-chain
# - Bitcoin Core: https://github.com/bitcoin/bitcoin/blob/7fcf53f7b4524572d1d0c9a5fdc388e87eb02416/src/primitives/block.h#L22

from block_header import BlockValidationContext
from transaction import TransactionValidationContext

struct BlockValidationContext:
	member header_context: BlockHeaderValidationContext
	member transactions_context: TransactionValidationContext*
end

func read_block_validation_context(prev_context: BlockValidationContext):
	let header_context = read_block_header_validation_context(prev_context.header_context)
	let transactions_context = read_transactions_validation_context()
	return ()
end

func validate_block(context: BlockValidationContext):
	# validate_block_header(context.header_context)
	validate_merkle_root(context)
	return ()
end

func validate_merkle_root(context: BlockValidationContext):
	let txids = alloc()
	_copy_txids_into_array_loop(context.transactions_context, txids, block.transactions_size)
	let merkle_root = compute_merkle_root(txids)
	assert_hashes_equal(
		context.header_context.block_header.merkle_root_hash,
		merkle_root
	)
	return()
end

func _copy_txids_into_array_loop(
	transactions_context: TransactionValidationContext*, txids: felt*, loop_counter):
	if loop_counter == 0:
		return ()
	end
	copy_hash([context].txid, txids)
	return _copy_txids_into_array_loop(
		context + TransactionValidationContext.SIZE, 
		txids + HASH_FELT_SIZE, 
		loop_counter - 1
	)
end

func validate_transactions(context: BlockValidationContext):
	return()
end



