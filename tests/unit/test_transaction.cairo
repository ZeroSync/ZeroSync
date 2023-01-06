//
// To run only this test suite use:
// protostar test --cairo-path=./src target tests/unit/*_transaction*
//

%lang starknet

from starkware.cairo.common.alloc import alloc
from utils.serialize import init_reader, init_writer, flush_writer, read_uint8
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.memcpy import memcpy
from crypto.hash_utils import assert_hashes_equal
from utils.python_utils import setup_python_defs

from transaction.transaction import read_transaction, read_transaction_validation_context

// Transaction example
//
// See also
// - https://blockstream.info/tx/b9818f9eb8925f2b5b9aaf3e804306efa1a0682a7173c0b7edb5f2e05cc435bd
// - https://blockstream.info/api/tx/b9818f9eb8925f2b5b9aaf3e804306efa1a0682a7173c0b7edb5f2e05cc435bd/hex
@external
func test_read_transaction{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();

    let (transaction_raw) = alloc();

    // Use Python to convert hex string into uint32 array
    %{
        from_hex(
            "0100000001352a68f58c6e69fa632a1bf77566cf83a7515fc9ecd251fa37f410"
            "460d07fb0c010000008c493046022100e30fea4f598a32ea10cd56118552090c"
            "be79f0b1a0c63a4921d2399c9ec14ffc022100ef00f238218864a909db55be9e"
            "2e464ccdd0c42d645957ea80fa92441e90b4c6014104b01cf49815496b5ef83a"
            "bd1a3891996233f0047ada682d56687dd58feb39e969409ce70be398cf73634f"
            "f9d1aae79ac2be2b1348ce622dddb974ad790b4106deffffffff02e093040000"
            "0000001976a914a18cc6dd0e38dea210390a2403622ffc09dae88688ac8152b5"
            "00000000001976a914d73441c86ea086121991877e204516f1861c194188ac00"
            "000000", ids.transaction_raw)
    %}

    let reader = init_reader(transaction_raw);

    let (transaction, byte_size) = read_transaction{reader=reader}();

    assert 0x01 = transaction.version;

    assert 300000 = transaction.outputs[0].amount;
    assert 11883137 = transaction.outputs[1].amount;

    assert 259 = byte_size;

    let (expected_script_pub_key) = alloc();
    local expected_script_pub_key_len;
    local expected_script_pub_key_size;
    %{
        byte_size, felt_size = from_hex("76a914a18cc6dd0e38dea210390a2403622ffc09dae88688ac", ids.expected_script_pub_key)
        ids.expected_script_pub_key_len = felt_size
        ids.expected_script_pub_key_size = byte_size
    %}

    assert 0x19 = transaction.outputs[0].script_pub_key_size;

    memcpy(
        expected_script_pub_key, transaction.outputs[0].script_pub_key, expected_script_pub_key_len
    );
    return ();
}

// SegWit Transaction example
//
// See also
// - https://blockstream.info/testnet/tx/45c1edba17b831b919f9539d2d3d2e7107da7b661673e10ffb65446fc1781335?expand
// - https://blockstream.info/testnet/api/tx/45c1edba17b831b919f9539d2d3d2e7107da7b661673e10ffb65446fc1781335/hex
@external
func test_read_segwit_transaction{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();

    let (transaction_raw) = alloc();

    // Use Python to convert hex string into uint32 array
    %{
        from_hex((
            "02000000000101193c8e971011dad3a886b8f88b05614ce38930b2b00ae9e34f"
            "a9b3e0371093990100000000ffffffff0327010000000000001600145d6787fb"
            "4d4bf624d7d30edc1832253f80ed45aa6eb1000000000000160014519a06346d"
            "e75727fb060af1fc0615922efb2e050000000000000000066a04000004b00247"
            "3044022012d52c4451c549cf14dec197a1b3546e8fdbe87239ed82cfa98d0f43"
            "358c101a0220046405b23a5e3e5a3765a11ace75ea1498ef28ac2bdf5adf2160"
            "498521914f6c012103f2a2ae66e6f49f62f011be8c34e498d3b615b06990590e"
            "3f5d68e866ecec219500000000"), ids.transaction_raw)
    %}

    let reader = init_reader(transaction_raw);

    let (transaction, byte_size) = read_transaction{reader=reader}();

    assert 0x02 = transaction.version;

    assert 295 = transaction.outputs[0].amount;
    assert 45422 = transaction.outputs[1].amount;

    // assert byte_size = 259
    return ();
}

@external
func test_read_transaction_validation_context{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();

    let (txid_expected) = alloc();

    // Use Python to convert hex string into uint32 array
    %{
        hashes_from_hex([
        	"b9818f9eb8925f2b5b9aaf3e804306efa1a0682a7173c0b7edb5f2e05cc435bd"
        	], ids.txid_expected)
    %}

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    with sha256_ptr {
        let context = read_transaction_validation_context(328734, 1);
    }
    assert 0x01 = context.transaction.version;

    assert 300000 = context.transaction.outputs[0].amount;
    assert 11883137 = context.transaction.outputs[1].amount;

    assert 259 = context.transaction_size;

    assert_hashes_equal(context.txid, txid_expected);

    return ();
}
