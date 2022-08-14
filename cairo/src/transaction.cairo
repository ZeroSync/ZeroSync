# Bitcoin Transactions 
#
# See also:
# - https://developer.bitcoin.org/reference/transactions.html#raw-transaction-format
# - https://github.com/coins/research/blob/master/bitcoin-tx.md

struct Transaction:
	member version: felt
	member inputs_len: felt
	member inputs: TxInput*
	member outputs_len: felt
	member outputs: TxOutput*
	member locktime: felt
end

struct TxInput:
	member txid: felt*
	member vout: felt
	member script_sig_size: felt
	member script_sig: felt*
	member sequence: felt
end

struct TxOutput:
	member value: felt
	member script_pub_key_size: felt
	member script_pub_key: felt*
end

func read_transaction{reader:Reader}() -> (transaction: Transaction):
	let version		= read_uint32()
	let inputs_len	= read_varint()
	let inputs		= read_inputs(inputs_len)
	let outputs_len = read_varint()
	let outputs 	= read_outputs(outputs_len)
	let locktime 	= read_uint32()
	# TODO: Compute byte size of transaction while reading it

	return (Transaction(
		version, 
		inputs_len, 
		inputs, 
		outputs_len, 
		outputs, 
		locktime
	))
end

func read_inputs{reader:Reader}(inputs_len) -> (inputs: TxInput*):
	let inputs = alloc()
	_read_inputs_loop(inputs, inputs_len)
	return (inputs)
end

func _read_inputs_loop{reader:Reader}(inputs: felt*, inputs_len):
	if inputs_len == 0:
		return ()
	end
	let (input) = read_input() 
	assert [inputs] = input
	_read_inputs_loop(inputs + 1, inputs_len - 1)
	return ()
end

func read_input{reader:Reader}() -> (input: TxInput):
	let txid			= read_hash()
	let vout			= read_uint32()
	let script_sig_size	= read_varint()
	let script_sig		= read_bytes(script_sig_size)
	let sequence		= read_uint32()
	return (TxInput(txid, vout, script_sig_size, script_sig, sequence))
end

func read_outputs{reader:Reader}(outputs_len) -> (outputs: TxOutput*):
	let outputs = alloc()
	_read_outputs_loop(outputs, outputs_len)
	return (outputs)
end

func _read_outputs_loop{reader:Reader}(outputs: felt*, outputs_len):
	if outputs_len == 0:
		return ()
	end
	let (output) = read_output()
	assert [outputs] = output
	_read_outputs_loop(outputs + 1, outputs_len - 1)
	return ()
end

func read_output{reader:Reader}() -> (output: TxOutput):
	let value				= read_uint64()
	let script_pub_key_size	= read_varint()
	let script_pub_key		= read_bytes(script_pub_key_size)
	return (TxOutput(value, script_pub_key_size, script_pub_key))
end


struct TransactionValidationContext:
	member transaction: Transaction
	member transaction_raw: felt*
	member transaction_raw_size: felt
	member txid: felt*
	# member utxo_set_root_hash: felt*
end

func read_transaction_validation_context{reader:Reader}(
	) -> (result: TransactionValidationContext):
	let transaction_raw = reader.head
	let transaction = read_transaction()
	let transaction_raw_size = 0 # TODO: implement me
	let txid = alloc() # TODO: implement me
	return (TransactionValidationContext(
		transaction_raw, transaction_raw_size, transaction_raw_size, txid))
end