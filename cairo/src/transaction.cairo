# Serialization and Validation of a Bitcoin Transaction
#
# See also:
# - Bitcoin Core: https://developer.bitcoin.org/reference/transactions.html#raw-transaction-format
# - Example transactions of all types: https://github.com/coins/research/blob/master/bitcoin-tx.md

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from crypto.sha256d.sha256d import sha256d, HASH_SIZE
from buffer import Reader, Writer, read_uint8, peek_uint8, read_uint16, read_uint32, read_uint64, read_varint, read_hash, read_bytes, UINT32_SIZE, UINT64_SIZE, read_bytes_endian, write_uint32, write_varint
from block_header import BlockHeaderValidationContext

# Definition of a Bitcoin transaction
#
# See also:
# - https://developer.bitcoin.org/reference/transactions.html#raw-transaction-format
struct Transaction:
	member version: felt
	member input_count: felt
	member inputs: TxInput*
	member output_count: felt
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
	member amount: felt
	member script_pub_key_size: felt
	member script_pub_key: felt*
end

# Read a Transaction from a buffer
func read_transaction{reader: Reader, range_check_ptr}(
	) -> (transaction: Transaction, byte_size):
	alloc_locals
	let (version) = read_uint32()
	
	# Parse the SegWit flag
	let (is_not_segwit) = peek_uint8()
	if is_not_segwit == 0:
		# This is a SegWit transaction
		# Read the 2 bytes of "marker" and "flag"
		let (flag) = read_uint16()
		# Validate that they are set correctly
		assert flag = 0x0100
	end

	let input_count  = read_varint()
	let inputs       = read_inputs(input_count.value)
	let output_count = read_varint()
	let outputs      = read_outputs(output_count.value)
	let (locktime)   = read_uint32()

	return (Transaction(
		version, 
		input_count.value, 
		inputs.inputs, 
		output_count.value, 
		outputs.outputs, 
		locktime
	), 	
	# Compute the byte size of the transaction 
		UINT32_SIZE +
		input_count.byte_size + 
		inputs.byte_size +
		output_count.byte_size +
		outputs.byte_size +
		UINT32_SIZE
	)
end

# Read transaction inputs from a buffer
func read_inputs{reader:Reader, range_check_ptr}(
	input_count) -> (inputs: TxInput*, byte_size):
	alloc_locals
	let (inputs: TxInput*) = alloc()
	let (byte_size) = _read_inputs_loop(inputs, input_count)
	return (inputs, byte_size)
end

# LOOP: Read transaction inputs from a buffer
func _read_inputs_loop{reader:Reader, range_check_ptr}(
	inputs: TxInput*, loop_counter) -> (byte_size):
	alloc_locals
	if loop_counter == 0:
		return (0)
	end
	let input = read_input()
	assert [inputs] = input.input
	let (byte_size_accu) = _read_inputs_loop(inputs + TxInput.SIZE, loop_counter - 1)
	return (byte_size_accu + input.byte_size)
end

# Read a transaction input from a buffer
func read_input{reader:Reader, range_check_ptr}(
	) -> (input: TxInput, byte_size):
	alloc_locals
	let (txid)			= read_hash()
	let (vout)			= read_uint32()
	let script_sig_size	= read_varint()
	let (script_sig)	= read_bytes(script_sig_size.value)
	let (sequence)		= read_uint32()
	return (
		TxInput(
			txid, 
			vout, 
			script_sig_size.value, 
			script_sig, 
			sequence
		),	
		# Compute the input's byte size
			HASH_SIZE + 
			UINT32_SIZE + 
			script_sig_size.byte_size + 
			script_sig_size.value + 
			UINT32_SIZE
	)
end

# Read outputs from a buffer
func read_outputs{reader:Reader, range_check_ptr}(
	output_count) -> (outputs: TxOutput*, byte_size):
	alloc_locals
	let outputs: TxOutput* = alloc()
	let (byte_size) = _read_outputs_loop(outputs, output_count)
	return (outputs, byte_size)
end

# LOOP: Read transaction outputs
func _read_outputs_loop{reader:Reader, range_check_ptr}(
	outputs: TxOutput*, loop_counter) -> (byte_size):
	alloc_locals
	if loop_counter == 0:
		return (0)
	end
	let (output, byte_size) = read_output()
	assert [outputs] = output
	let (byte_size_accu) = _read_outputs_loop(outputs + TxOutput.SIZE, loop_counter - 1)
	return (byte_size_accu + byte_size)
end

# Read an output from a buffer
func read_output{reader:Reader, range_check_ptr}(
	) -> (output: TxOutput, byte_size):
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
		# Compute the output's byte size
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
	# member is_segwit: felt
	# member witnesses: felt**
	# member utxo_set_root_hash: felt*
end

# Read a transaction from a buffer and set its validation context
func read_transaction_validation_context{reader:Reader, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
	) -> (result: TransactionValidationContext):
	alloc_locals

	# TODO: Fix me properly. This is just a quick fix to prevent 
	# the bug occuring when reader.offset > 0. 
	let raw_reader = reader
	let (transaction, byte_size) = read_transaction()
	let (transaction_raw) = read_bytes_endian{reader = raw_reader}(byte_size)
	let (txid) = sha256d(transaction_raw, byte_size)
	
	return (TransactionValidationContext(
		transaction, transaction_raw, byte_size, txid))
end

# Validate all properties of a transaction, apply it to the current state
# and return the resulting next state root
func validate_and_apply_transaction(
	context: TransactionValidationContext, header_context: BlockHeaderValidationContext,
	prev_state: felt*
	) -> (next_state:felt*):
	
	let (state_root) = alloc()
	return (state_root)
end


# Write a transaction into a Writer
# 
# There are multiple different types of writing:
# 	- TXID:    Serialize for hashing the transaction id (that might mean to ignore the segwit flag)
# 	- wTXID:   Serialize for hashing the witness transaction id (add the segwit data)
# 	- sighash: Serialize for hashing with a given signature hash flag
#			   (tweak the inputs, outputs, and the script accordingly)
# 
# See also:
# - https://developer.bitcoin.org/devguide/transactions.html#signature-hash-types
#
func write_transaction{writer:Writer, range_check_ptr}(
	transaction: Transaction):
	write_uint32(transaction.version)
	
	write_varint(transaction.input_count)
	# write_inputs(transaction.inputs)

	write_varint(transaction.output_count)
	# write_outputs(transaction)
	write_uint32(transaction.locktime)
	return ()
end


# Sketch of an idea to make the writer carry meta data

# The different types of Writers
const IS_TXID = 1
const IS_WTXID = 2
const IS_SIGHASH = 3

struct TypedWriter:
	# This writer's type
	member type: felt
	# This writer's meta data (gets casted according to type)
	# Nullpointer if the type of this Writer has no meta data
	member meta: felt*
end

# - https://developer.bitcoin.org/devguide/transactions.html#signature-hash-types
# func hash_with_sighash_flag(transaction: Transaction, sighash: felt) -> (hash: felt*):
	
# 	return ()
#end


