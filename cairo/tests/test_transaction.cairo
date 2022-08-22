%lang starknet

from starkware.cairo.common.alloc import alloc
from buffer import init_reader, init_writer, flush_writer, read_uint8
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from crypto.sha256d.sha256d import assert_hashes_equal
from utils_for_testing import setup_python_defs

from transaction import read_transaction, read_transaction_validation_context

# Transaction example 
#
# See also
# - https://blockstream.info/tx/b9818f9eb8925f2b5b9aaf3e804306efa1a0682a7173c0b7edb5f2e05cc435bd
# - https://blockstream.info/api/tx/b9818f9eb8925f2b5b9aaf3e804306efa1a0682a7173c0b7edb5f2e05cc435bd/hex
@external
func test_read_transaction{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}():
	alloc_locals
	setup_python_defs()

	let (transaction_raw) = alloc()

	# Use Python to convert hex string into uint32 array
   %{
    from_hex((
        "0100000001352a68f58c6e69fa632a1bf77566cf83a7515fc9ecd251fa37f410"
        "460d07fb0c010000008c493046022100e30fea4f598a32ea10cd56118552090c"
        "be79f0b1a0c63a4921d2399c9ec14ffc022100ef00f238218864a909db55be9e"
        "2e464ccdd0c42d645957ea80fa92441e90b4c6014104b01cf49815496b5ef83a"
        "bd1a3891996233f0047ada682d56687dd58feb39e969409ce70be398cf73634f"
        "f9d1aae79ac2be2b1348ce622dddb974ad790b4106deffffffff02e093040000"
        "0000001976a914a18cc6dd0e38dea210390a2403622ffc09dae88688ac8152b5"
        "00000000001976a914d73441c86ea086121991877e204516f1861c194188ac00"
        "000000"), ids.transaction_raw)
    %}

	let (reader) = init_reader(transaction_raw)

	let (transaction, byte_size) = read_transaction{reader=reader}()

	assert transaction.version = 0x01
	
	assert transaction.outputs[0].amount =   300000
	assert transaction.outputs[1].amount = 11883137

	assert byte_size = 259
	return ()
end



# SegWit Transaction example 
#
# See also
# - https://blockstream.info/testnet/tx/45c1edba17b831b919f9539d2d3d2e7107da7b661673e10ffb65446fc1781335?expand
# - https://blockstream.info/testnet/api/tx/45c1edba17b831b919f9539d2d3d2e7107da7b661673e10ffb65446fc1781335/hex
@external
func test_read_segwit_transaction{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}():
	alloc_locals
	setup_python_defs()

	let (transaction_raw) = alloc()

	# Use Python to convert hex string into uint32 array
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

	let (reader) = init_reader(transaction_raw)

	let (transaction, byte_size) = read_transaction{reader=reader}()

	assert transaction.version = 0x02
	
	assert transaction.outputs[0].amount = 295
	assert transaction.outputs[1].amount = 45422

	# assert byte_size = 259
	return ()
end


@external
func test_read_transaction_validation_context{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}():
	alloc_locals
	setup_python_defs()

	let (transaction_raw) = alloc()
	let (txid_expected) = alloc()

	# Use Python to convert hex string into uint32 array
   %{
    from_hex((
        "0100000001352a68f58c6e69fa632a1bf77566cf83a7515fc9ecd251fa37f410"
        "460d07fb0c010000008c493046022100e30fea4f598a32ea10cd56118552090c"
        "be79f0b1a0c63a4921d2399c9ec14ffc022100ef00f238218864a909db55be9e"
        "2e464ccdd0c42d645957ea80fa92441e90b4c6014104b01cf49815496b5ef83a"
        "bd1a3891996233f0047ada682d56687dd58feb39e969409ce70be398cf73634f"
        "f9d1aae79ac2be2b1348ce622dddb974ad790b4106deffffffff02e093040000"
        "0000001976a914a18cc6dd0e38dea210390a2403622ffc09dae88688ac8152b5"
        "00000000001976a914d73441c86ea086121991877e204516f1861c194188ac00"
        "000000"), ids.transaction_raw)

    hashes_from_hex([
    	"b9818f9eb8925f2b5b9aaf3e804306efa1a0682a7173c0b7edb5f2e05cc435bd"
    	], ids.txid_expected)
    %}

	let (reader) = init_reader(transaction_raw)

	let (context) = read_transaction_validation_context{reader=reader}()

	assert context.transaction.version = 0x01
	
	assert context.transaction.outputs[0].amount =   300000
	assert context.transaction.outputs[1].amount = 11883137

	assert context.transaction_size = 259

	assert_hashes_equal(context.txid, txid_expected)
	return ()
end


# Read transaction from buffer with an offset
#
# See also
# - https://blockstream.info/tx/a4bc0a85369d04454ec7e006ece017f21549fdfe7df128d61f9f107479bfdf7e
# - https://blockstream.info/api/tx/a4bc0a85369d04454ec7e006ece017f21549fdfe7df128d61f9f107479bfdf7e/hex
@external
func test_read_transaction_with_offset{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}():
	alloc_locals
	setup_python_defs()

	let (transaction_raw) = alloc()
	let (txid_expected) = alloc()

	# Use Python to convert hex string into uint32 array
   %{
    from_hex((
        "010100000001000000000000000000000000000000000000000000000000000000"
        "0000000000ffffffff0804ffff001d024f02ffffffff0100f2052a0100000043"
        "41048a5294505f44683bbc2be81e0f6a91ac1a197d6050accac393aad3b86b23"
        "98387e34fedf0de5d9f185eb3f2c17f3564b9170b9c262aa3ac91f371279beca"
        "0cafac00000000"), ids.transaction_raw)

    hashes_from_hex([
    	"a4bc0a85369d04454ec7e006ece017f21549fdfe7df128d61f9f107479bfdf7e"
    	], ids.txid_expected)
    %}

	let (reader) = init_reader(transaction_raw)

	# Create some offset
	read_uint8{reader=reader}()

	let (context) = read_transaction_validation_context{reader=reader}()

	assert context.transaction.version = 0x01
	
	assert context.transaction.outputs[0].amount = 50 * 10**8 # 50 BTC

	assert context.transaction_size = 135

	assert_hashes_equal(context.txid, txid_expected)
	return ()
end