// Serialization and Validation of a Bitcoin Transaction
//
// See also:
// - Bitcoin Core: https://developer.bitcoin.org/reference/transactions.html#raw-transaction-format
// - Example transactions of all types: https://github.com/coins/research/blob/master/bitcoin-tx.md

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.math import assert_le

from crypto.hash256 import hash256
from crypto.hash_utils import HASH_FELT_SIZE

from utils.serialize import (
    init_reader,
    Reader,
    read_uint8,
    read_uint16,
    read_uint32,
    read_uint64,
    read_varint,
    read_hash,
    read_bytes_endian,
    peek_uint8,
    Writer,
    write_uint32,
    write_varint,
    UINT32_SIZE,
    UINT64_SIZE,
)
from block.block_header import BlockHeaderValidationContext

from utxo_set.utxo_set import utxo_set_insert, utxo_set_extract

// Definition of a Bitcoin transaction
//
// See also:
// - https://developer.bitcoin.org/reference/transactions.html#raw-transaction-format
//
struct Transaction {
    version: felt,
    input_count: felt,
    inputs: TxInput*,
    output_count: felt,
    outputs: TxOutput*,
    locktime: felt,
}

// A transaction input
struct TxInput {
    txid: felt*,
    vout: felt,
    script_sig_size: felt,
    script_sig: felt*,
    sequence: felt,
}

// A transaction output
struct TxOutput {
    amount: felt,
    script_pub_key_size: felt,
    script_pub_key: felt*,
}

// Read a Transaction from a buffer
func read_transaction{reader: Reader, bitwise_ptr: BitwiseBuiltin*}() -> (
    transaction: Transaction, byte_size: felt
) {
    alloc_locals;
    let version = read_uint32();

    // Parse the SegWit flag
    let is_not_segwit = peek_uint8();
    if (is_not_segwit == 0) {
        // This is a SegWit transaction
        // Read the 2 bytes of "marker" and "flag"
        let flag = read_uint16();
        // Validate that they are set correctly
        with_attr error_message("Flag should be 0x0100 but it is {flag}.") {
            assert 0x0100 = flag;
        }
    }

    let input_count = read_varint();
    let inputs = read_inputs(input_count.value);
    let output_count = read_varint();
    let outputs = read_outputs(output_count.value);
    let locktime = read_uint32();

    // Compute the byte size of the transaction
    return (
        Transaction(
        version,
        input_count.value,
        inputs.inputs,
        output_count.value,
        outputs.outputs,
        locktime
        ),
        UINT32_SIZE +
        input_count.byte_size +
        inputs.byte_size +
        output_count.byte_size +
        outputs.byte_size +
        UINT32_SIZE,
    );
}

// Read transaction inputs from a buffer
func read_inputs{reader: Reader, bitwise_ptr: BitwiseBuiltin*}(input_count) -> (
    inputs: TxInput*, byte_size: felt
) {
    alloc_locals;
    let (inputs: TxInput*) = alloc();
    let byte_size = _read_inputs_loop(inputs, input_count);
    return (inputs, byte_size);
}

// LOOP: Read transaction inputs from a buffer
func _read_inputs_loop{reader: Reader, bitwise_ptr: BitwiseBuiltin*}(
    inputs: TxInput*, loop_counter
) -> felt {
    alloc_locals;
    if (loop_counter == 0) {
        return 0;
    }
    let input = read_input();
    with_attr error_message("Inputs do not match.") {
        assert [inputs] = input.input;
    }
    let byte_size_accu = _read_inputs_loop(inputs + TxInput.SIZE, loop_counter - 1);
    return byte_size_accu + input.byte_size;
}

// Read a transaction input from a buffer
func read_input{reader: Reader, bitwise_ptr: BitwiseBuiltin*}() -> (
    input: TxInput, byte_size: felt
) {
    alloc_locals;
    let txid = read_hash();
    let vout = read_uint32();
    let script_sig_size = read_varint();
    let script_sig = read_bytes_endian(script_sig_size.value);
    let sequence = read_uint32();
    // Compute the input's byte size
    return (
        TxInput(
        txid,
        vout,
        script_sig_size.value,
        script_sig,
        sequence
        ),
        UINT32_SIZE * HASH_FELT_SIZE +
        UINT32_SIZE +
        script_sig_size.byte_size +
        script_sig_size.value +
        UINT32_SIZE,
    );
}

// Read outputs from a buffer
func read_outputs{reader: Reader, bitwise_ptr: BitwiseBuiltin*}(output_count) -> (
    outputs: TxOutput*, byte_size: felt
) {
    alloc_locals;
    let outputs: TxOutput* = alloc();
    let byte_size = _read_outputs_loop(outputs, output_count);
    return (outputs, byte_size);
}

// LOOP: Read transaction outputs
func _read_outputs_loop{reader: Reader, bitwise_ptr: BitwiseBuiltin*}(
    outputs: TxOutput*, loop_counter
) -> felt {
    alloc_locals;
    if (loop_counter == 0) {
        return 0;
    }
    let (output, byte_size) = read_output();
    with_attr error_message("Outputs do not match.") {
        assert [outputs] = output;
    }
    let byte_size_accu = _read_outputs_loop(outputs + TxOutput.SIZE, loop_counter - 1);
    return byte_size_accu + byte_size;
}

// Read an output from a buffer
// Compute the output's byte size
func read_output{reader: Reader, bitwise_ptr: BitwiseBuiltin*}() -> (
    output: TxOutput, byte_size: felt
) {
    alloc_locals;
    let amount = read_uint64();
    let script_pub_key_size = read_varint();
    let script_pub_key = read_bytes_endian(script_pub_key_size.value);
    return (
        TxOutput(
        amount,
        script_pub_key_size.value,
        script_pub_key
        ),
        UINT64_SIZE +
        script_pub_key_size.byte_size +
        script_pub_key_size.value,
    );
}

// The validation context for transactions
struct TransactionValidationContext {
    transaction: Transaction,
    transaction_size: felt,
    txid: felt*,
    // member is_segwit: felt
    // member witnesses: felt**
}

func fetch_transaction(block_height, tx_index) -> felt* {
    let (raw_transaction) = alloc();

    %{
        import urllib3
        import json
        http = urllib3.PoolManager()

        url = 'https://blockstream.info/api/block-height/' + str(ids.block_height)
        r = http.request('GET', url)
        block_hash = str(r.data, 'utf-8')

        url = f'https://blockstream.info/api/block/{block_hash}/txid/' + str(ids.tx_index)
        r = http.request('GET', url)
        txid = r.data.decode('utf-8')

        url = f"https://blockstream.info/api/tx/{txid}/hex"
        r = http.request('GET', url)
        tx_hex = r.data.decode('utf-8')
        
        if r.status != 200:
            print("ERROR: Fetch_transaction received a bad answer from the API: ", r.status, r.data.decode('utf-8'))
            exit(-1)
        from_hex(tx_hex, ids.raw_transaction)
    %}
    return raw_transaction;
}

// Read a transaction from a buffer and set its validation context
func read_transaction_validation_context{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, sha256_ptr: felt*
}(block_height, transaction_index) -> TransactionValidationContext {
    alloc_locals;

    let transaction_raw = fetch_transaction(block_height, transaction_index);
    let reader = init_reader(transaction_raw);
    let (transaction, byte_size) = read_transaction{reader=reader}();
    let txid = hash256(transaction_raw, byte_size);

    let ctx = TransactionValidationContext(transaction, byte_size, txid);
    return ctx;
}

// Validate all properties of a transaction, apply it to the current state
// and return the resulting next state root
func validate_and_apply_transaction{range_check_ptr, utreexo_roots: felt*, hash_ptr: HashBuiltin*}(
    context: TransactionValidationContext, header_context: BlockHeaderValidationContext
) -> felt {
    alloc_locals;

    let total_input_amount = validate_and_apply_inputs_loop(
        context, context.transaction.inputs, 0, context.transaction.input_count
    );

    let total_output_amount = validate_outputs_loop(
        context, context.transaction.outputs, 0, 0, context.transaction.output_count
    );

    with_attr error_message("The total output amount is greater than the input one.") {
        assert_le(total_output_amount, total_input_amount);
    }
    let tx_fee = total_input_amount - total_output_amount;

    return tx_fee;
}

func validate_and_apply_inputs_loop{range_check_ptr, utreexo_roots: felt*, hash_ptr: HashBuiltin*}(
    context: TransactionValidationContext, input: TxInput*, total_input_amount, loop_counter
) -> felt {
    alloc_locals;

    if (loop_counter == 0) {
        return total_input_amount;
    }

    let amount = validate_and_apply_input([input]);

    return validate_and_apply_inputs_loop(
        context, input + TxInput.SIZE, total_input_amount + amount, loop_counter - 1
    );
}

func validate_and_apply_input{range_check_ptr, utreexo_roots: felt*, hash_ptr: HashBuiltin*}(
    input: TxInput
) -> felt {
    let (amount, script_pub_key, script_pub_key_len) = utxo_set_extract(input.txid, input.vout);

    // TODO: validate the Bitcoin Script

    return amount;
}

func validate_outputs_loop{range_check_ptr, utreexo_roots: felt*, hash_ptr: HashBuiltin*}(
    context: TransactionValidationContext,
    output: TxOutput*,
    total_output_amount,
    output_index,
    output_count,
) -> felt {
    alloc_locals;

    if (output_index == output_count) {
        return total_output_amount;
    }

    let amount = validate_output(context, [output], output_index);

    return validate_outputs_loop(
        context,
        output + TxOutput.SIZE,
        total_output_amount + amount,
        output_index + 1,
        output_count,
    );
}

func validate_output{range_check_ptr, utreexo_roots: felt*, hash_ptr: HashBuiltin*}(
    context: TransactionValidationContext, output: TxOutput, output_index
) -> felt {
    alloc_locals;

    utxo_set_insert(
        context.txid, output_index, output.amount, output.script_pub_key, output.script_pub_key_size
    );

    return output.amount;
}

// Write a transaction into a Writer
//
// There are multiple different types of writing:
// 	- TXID:    Serialize for hashing the transaction id (that might mean to ignore the segwit flag)
// 	- wTXID:   Serialize for hashing the witness transaction id (add the segwit data)
// 	- sighash: Serialize for hashing with a given signature hash flag
// 			   (tweak the inputs, outputs, and the script accordingly)
//
// See also:
// - https://developer.bitcoin.org/devguide/transactions.html#signature-hash-types
//
func write_transaction{writer: Writer, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(transaction: Transaction) {
    alloc_locals;
    write_uint32(transaction.version);

    write_varint(transaction.input_count);
    // write_inputs(transaction.inputs)

    write_varint(transaction.output_count);
    // write_outputs(transaction)
    write_uint32(transaction.locktime);
    return ();
}

// Sketch of an idea to make the writer carry meta data

// The different types of Writers
const IS_TXID = 1;
const IS_WTXID = 2;
const IS_SIGHASH = 3;

struct TypedWriter {
    // This writer's type
    type: felt,
    // This writer's meta data (gets casted according to type)
    // Nullpointer if the type of this Writer has no meta data
    meta: felt*,
}

// - https://developer.bitcoin.org/devguide/transactions.html#signature-hash-types
// func hash_with_sighash_flag(transaction: Transaction, sighash: felt) -> felt* {
// TODO: implement hash_with_sighash_flag
// return ()
// }
