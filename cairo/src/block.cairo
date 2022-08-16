# Validation of Bitcoin Blocks
#
# We do not implement block serialization because 
# we never hash a block all at once but only its header and transactions.
#
# See also: 
# - Reference: https://developer.bitcoin.org/reference/block_chain.html#block-chain
# - Bitcoin Core: https://github.com/bitcoin/bitcoin/blob/7fcf53f7b4524572d1d0c9a5fdc388e87eb02416/src/primitives/block.h#L22


struct BlockValidationContext:
	member transactions_context: TransactionValidationContext*
	member block_context: BlockValidationContext
end


func read_block_validation_context():
	return ()
end

func validate_block(context: BlockValidationContext):
	return ()
end

func validate_merkle_root(context: BlockValidationContext):
	return()
end

func validate_transactions(context: BlockValidationContext):
	return()
end



