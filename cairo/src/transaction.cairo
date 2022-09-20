# Serialization and Validation of a Bitcoin Transaction
#
# See also:
# - Bitcoin Core: https://developer.bitcoin.org/reference/transactions.html#raw-transaction-format
# - Example transactions of all types: https://github.com/coins/research/blob/master/bitcoin-tx.md

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.math import assert_le, unsigned_div_rem
from starkware.cairo.common.hash import hash2

from crypto.sha256d.sha256d import sha256d, HASH_SIZE
from buffer import (
	Reader, read_uint8, read_uint16, read_uint32, read_uint64,
	read_varint, read_hash, read_bytes, read_bytes_endian, peek_uint8,
	Writer,  write_uint32, write_varint, UINT32_SIZE, UINT64_SIZE )
from block_header import BlockHeaderValidationContext
from utreexo.utreexo import utreexo_add, utreexo_delete, fetch_inclusion_proof


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
func validate_and_apply_transaction{range_check_ptr, utreexo_roots: felt*, hash_ptr: HashBuiltin*}(
	context: TransactionValidationContext, 
	header_context: BlockHeaderValidationContext) -> (tx_fee):
	alloc_locals

	let (total_input_amount) = validate_and_apply_inputs_loop(
		context, context.transaction.inputs, 0, context.transaction.input_count)

	let (total_output_amount) = validate_outputs_loop(
		context, context.transaction.outputs, 0, 0, context.transaction.output_count)

	assert_le(total_output_amount, total_input_amount)
	let tx_fee = total_input_amount - total_output_amount

	return (tx_fee)
end


func validate_and_apply_inputs_loop{range_check_ptr, utreexo_roots: felt*, hash_ptr: HashBuiltin*}(
	context: TransactionValidationContext, input: TxInput*, total_input_amount, loop_counter) -> (total_input_amount):
	alloc_locals
	
	if loop_counter == 0:
		return (total_input_amount)
	end

	let (amount) = validate_and_apply_input([input])

	return validate_and_apply_inputs_loop(
		context,
		input + TxInput.SIZE,
		total_input_amount + amount,
		loop_counter - 1
	)
end







# Computes a hash chain of a sequence whose length is given at [data_ptr] and the data starts at
# data_ptr + 1. The hash is calculated backwards (from the highest memory address to the lowest).
# For example, for the 3-element sequence [x, y, z] the hash is:
#   h(3, h(x, h(y, z)))
# If data_length = 0, the function does not return (takes more than field prime steps).
func hash_chain{hash_ptr : HashBuiltin*}(data_ptr : felt*, data_length) -> (hash : felt):
    struct LoopLocals:
        member data_ptr : felt*
        member hash_ptr : HashBuiltin*
        member cur_hash : felt
    end

    tempvar data_ptr_end = data_ptr + data_length - 1
    # Prepare the loop_frame for the first iteration of the hash_loop.
    tempvar loop_frame = LoopLocals(
        data_ptr=data_ptr_end,
        hash_ptr=hash_ptr,
        cur_hash=[data_ptr_end])

    hash_loop:
    let curr_frame = cast(ap - LoopLocals.SIZE, LoopLocals*)
    let current_hash : HashBuiltin* = curr_frame.hash_ptr

    tempvar new_data = [curr_frame.data_ptr - 1]

    let n_elements_to_hash = [ap]
    # Assign current_hash inputs and allocate space for n_elements_to_hash.
    current_hash.x = new_data; ap++
    current_hash.y = curr_frame.cur_hash

    # Set the frame for the next loop iteration (going backwards).
    tempvar next_frame = LoopLocals(
        data_ptr=curr_frame.data_ptr - 1,
        hash_ptr=curr_frame.hash_ptr + HashBuiltin.SIZE,
        cur_hash=current_hash.result)

    # Update n_elements_to_hash and loop accordingly. Note that the hash is calculated backwards.
    n_elements_to_hash = next_frame.data_ptr - data_ptr
    jmp hash_loop if n_elements_to_hash != 0

    # Set the hash_ptr implicit argument and return the result.
    let hash_ptr = next_frame.hash_ptr
    return (hash=next_frame.cur_hash)
end


func hash_output{hash_ptr: HashBuiltin*}(
	txid:felt*, vout, amount, script_pub_key: felt*, script_pub_key_len)->(hash):
	alloc_locals
    let (script_pub_key_hash) = hash_chain(script_pub_key, script_pub_key_len) 
    let (txid_hash) = hash_chain(txid, 8) 
    let (tmp1) = hash2(amount, script_pub_key_hash) 
    let (tmp2) = hash2(vout, tmp1)
    let (hash) = hash2(txid_hash, tmp2)
	return (hash)
end


func validate_and_apply_input{range_check_ptr, utreexo_roots: felt*, hash_ptr: HashBuiltin*}(
	input: TxInput) -> (amount):
	alloc_locals
	# Validate an inclusion proof

	# Query (input.txid, input.vout)
	# for the tupel T = (amount, script_pub_key_size, script_pub_key)

	local amount
	local script_pub_key_size
	local script_pub_key_len
	let (script_pub_key) = alloc()

    %{
        def swap32(i):
            return struct.unpack("<I", struct.pack(">I", i))[0]

        BASE = 2**32
        def _read_i(address, i):
            return swap32( memory[address + i] ) * BASE ** i 

        def hash_from_memory(address):
            hash = _read_i(address, 0)  \
                 + _read_i(address, 1)  \
                 + _read_i(address, 2)  \
                 + _read_i(address, 3)  \
                 + _read_i(address, 4)  \
                 + _read_i(address, 5)  \
                 + _read_i(address, 6)  \
                 + _read_i(address, 7)
            return hex(hash).replace('0x','')

        txid = hash_from_memory(ids.input.txid) 


        import urllib3
        http = urllib3.PoolManager()
        url = 'https://blockstream.info/api/tx/' + txid
        r = http.request('GET', url)
        

        import json
        tx = json.loads(r.data)
        tx_output = tx["vout"][ids.input.vout]

        ids.amount = tx_output["value"]       
        ids.script_pub_key_size = len(tx_output["scriptpubkey"]) // 2
        

        import re
        def hex_to_felt(hex_string):
            # Seperate hex_string into chunks of 8 chars.
            felts = re.findall(".?.?.?.?.?.?.?.", hex_string)
            # Fill remaining space in last chunk with 0.
            while len(felts[-1]) < 8:
                felts[-1] += "0"
            return [int(x, 16) for x in felts]

        # Writes a hex string string into an uint32 array
        #
        # Using multi-line strings in python:
        # - https://stackoverflow.com/questions/10660435/how-do-i-split-the-definition-of-a-long-string-over-multiple-lines
        def from_hex(hex_string, destination):
            # To see if there are only 0..f in hex_string we can try to turn it into an int
            try:
                check_if_hex = int(hex_string, 16)
            except ValueError:
                print("ERROR: Input to from_hex contains non-hex characters.")
            felts = hex_to_felt(hex_string)
            segments.write_arg(destination, felts)

            # Return the byte size of the uint32 array and the array length.
            return len(hex_string) // 2, len(felts)

        print('input amount', ids.amount)

        _, felt_size = from_hex( tx_output["scriptpubkey"], ids.script_pub_key)
        ids.script_pub_key_len = felt_size
    %}

	# my_hash = hash2(txid, vout, T)
    let (prevout_hash) = hash_output(input.txid, input.vout, amount, script_pub_key, script_pub_key_len)

	
	let (leaf_index, proof, proof_len) = fetch_inclusion_proof(prevout_hash)

	# Prove inclusion and delete from accumulator
	utreexo_delete(prevout_hash, leaf_index, proof, proof_len)
		
	return (amount) 
end



func validate_outputs_loop{range_check_ptr, utreexo_roots: felt*, hash_ptr: HashBuiltin*}(
	context: TransactionValidationContext, output: TxOutput*, total_output_amount, output_index, output_count) -> (total_output_amount):
	alloc_locals
	
	if output_index == output_count:
		return (total_output_amount)
	end

	let (amount) = validate_output(context, [output], output_index)

	return validate_outputs_loop(
		context,
		output + TxOutput.SIZE,
		total_output_amount + amount,
		output_index + 1,
		output_count
	)
end


func validate_output{range_check_ptr, utreexo_roots: felt*, hash_ptr: HashBuiltin*}(
	context: TransactionValidationContext, output: TxOutput, output_index) -> (amount):
	alloc_locals

	let (script_pub_key_len, _) = unsigned_div_rem(output.script_pub_key_size + 3, 4)
	let (local hash) = hash_output(context.txid, output_index, output.amount, output.script_pub_key, script_pub_key_len)

	utreexo_add(hash)
	%{ 

        # print('>> Add hash to utreexo DB', ids.hash) 
        http = urllib3.PoolManager()
        url = 'http://localhost:2121/add/' + hex(ids.hash)
        r = http.request('GET', url)

        # import json
        # response = json.loads(r.data)
        
    %}

	return (output.amount)
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

