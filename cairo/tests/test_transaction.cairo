%lang starknet

from starkware.cairo.common.alloc import alloc
from buffer import init_reader, init_writer, flush_writer
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from tests.utils_for_testing import setup_python_defs

from transaction import read_transaction

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

	let (transaction) = read_transaction{reader=reader}()

	assert transaction.version = 0x01
	
	assert transaction.outputs[0].value =   300000
	assert transaction.outputs[1].value = 11883137

	return ()
end