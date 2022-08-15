# Bitcoin Transactions 
#
# See also:
# - https://developer.bitcoin.org/reference/transactions.html#raw-transaction-format
# - https://github.com/coins/research/blob/master/bitcoin-tx.md

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from utils import __compute_double_sha256
from buffer import Reader, read_uint32, read_uint64, read_varint, read_hash, read_bytes, UINT32_SIZE, UINT64_SIZE

# A Bitcoin transaction
struct Transaction:
	member version: felt
	member inputs_len: felt
	member inputs: TxInput*
	member outputs_len: felt
	member outputs: TxOutput*
	member locktime: felt
end

# A transaction input
struct TxInput:
	member txid: felt*
	member vout: felt
	member script_sig_size: felt
	member script_sig: felt*
	member sequence: felt
end

# A transaction output
struct TxOutput:
	member value: felt
	member script_pub_key_size: felt
	member script_pub_key: felt*
end

# Read a Transaction from a buffer
func read_transaction{reader:Reader, range_check_ptr}() -> (transaction: Transaction, byte_size):
	alloc_locals
	let (version)	= read_uint32()
	let inputs_len	= read_varint()
	let inputs		= read_inputs(inputs_len.value)
	let outputs_len	= read_varint()
	let outputs		= read_outputs(outputs_len.value)
	let (locktime)	= read_uint32()
	return (Transaction(
		version, 
		inputs_len.value, 
		inputs.inputs, 
		outputs_len.value, 
		outputs.outputs, 
		locktime
	), 	# Compute the byte size of the transaction 
		UINT32_SIZE +
		inputs_len.byte_size + 
		inputs.byte_size +
		outputs_len.byte_size +
		outputs.byte_size +
		UINT32_SIZE
	)
end

# Read transaction inputs from a buffer
func read_inputs{reader:Reader, range_check_ptr}(inputs_len) -> (inputs: TxInput*, byte_size):
	alloc_locals
	let (inputs: TxInput*) = alloc()
	let (byte_size) = _read_inputs_loop(inputs, inputs_len)
	return (inputs, byte_size)
end

# LOOP: Read transaction inputs from a buffer
func _read_inputs_loop{reader:Reader, range_check_ptr}(inputs: TxInput*, inputs_len) -> (byte_size):
	alloc_locals
	if inputs_len == 0:
		return (0)
	end
	let (input, byte_size) = read_input()
	assert [inputs] = input
	let (byte_size_accu) = _read_inputs_loop(inputs + TxInput.SIZE, inputs_len - 1)
	return (byte_size_accu + byte_size)
end

# Read a transaction input from a buffer
func read_input{reader:Reader, range_check_ptr}() -> (input: TxInput, byte_size):
	alloc_locals
	let (txid)				= read_hash()
	let (vout)				= read_uint32()
	let script_sig_size		= read_varint()
	let (script_sig)		= read_bytes(script_sig_size.value)
	let (sequence)			= read_uint32()
	return (
		TxInput(
			txid, 
			vout, 
			script_sig_size.value, 
			script_sig, 
			sequence
		),	# Compute the input's byte length
			32 + 
			UINT32_SIZE + 
			script_sig_size.byte_size + 
			script_sig_size.value + 
			UINT32_SIZE
	)
end

# Read outputs from a buffer
func read_outputs{reader:Reader, range_check_ptr}(outputs_len) -> (outputs: TxOutput*, byte_size):
	alloc_locals
	let outputs: TxOutput* = alloc()
	let (byte_size) = _read_outputs_loop(outputs, outputs_len)
	return (outputs, byte_size)
end

# LOOP: Read transaction outputs
func _read_outputs_loop{reader:Reader, range_check_ptr}(outputs: TxOutput*, outputs_len) -> (byte_size):
	alloc_locals
	if outputs_len == 0:
		return (0)
	end
	let (output, byte_size) = read_output()
	assert [outputs] = output
	let (byte_size_accu) = _read_outputs_loop(outputs + TxOutput.SIZE, outputs_len - 1)
	return (byte_size_accu + byte_size)
end

# Read an output from a buffer
func read_output{reader:Reader, range_check_ptr}() -> (output: TxOutput, byte_size):
	alloc_locals
	let (amount)			= read_uint64()
	let script_pub_key_size	= read_varint()
	let (script_pub_key)	= read_bytes(script_pub_key_size.value)
	return (
		TxOutput(
			amount, 
			script_pub_key_size.value, 
			script_pub_key
		),
			UINT64_SIZE + 
			script_pub_key_size.byte_size +
			script_pub_key_size.value
	)
end

# The validation context for transactions
struct TransactionValidationContext:
	member transaction: Transaction
	member transaction_raw: felt*
	member transaction_size: felt
	member txid: felt*
	# member utxo_set_root_hash: felt*
end

# Read a transaction from a buffer and set its validation context
func read_transaction_validation_context{reader:Reader, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
	) -> (result: TransactionValidationContext):
	alloc_locals
	let transaction_raw = reader.head
	let (transaction, byte_size) = read_transaction()
	# let (txid) = __compute_double_sha256(transaction_raw, byte_size)
	let (txid) = __compute_double_sha256(transaction_raw, 64) # TODO fix byte_size of the sha256
	return (TransactionValidationContext(
		transaction, transaction_raw, byte_size, txid))
end