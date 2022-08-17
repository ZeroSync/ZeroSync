#
# To run only this test suite use:
# protostar test  --cairo-path=./src target tests/*_block.cairo
#

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from tests.utils_for_testing import setup_python_defs
from transaction import TransactionValidationContext
from block_header import BlockHeaderValidationContext
from block import BlockValidationContext, read_block_validation_context

from buffer import init_reader

@external
func test_read_block_validation_context{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
	alloc_locals
    setup_python_defs()

    let (block_raw) = alloc()
    %{
        from_hex((
            "02000000b6ff0b1b1680a2862a30ca44d346d9e8910d334beb48ca0c00000000"
            "000000009d10aa52ee949386ca9385695f04ede270dda20810decd12bc9b048a"
            "aab3147124d95a5430c31b18fe9f0864"), ids.block_raw)
    %}    
    
    let (reader) = init_reader(block_raw)

    let (local prev_header_context: BlockHeaderValidationContext*) = alloc()
    let (local prev_transactions_context: TransactionValidationContext*) = alloc()

    let (prev_context: BlockValidationContext*) = alloc()
    assert [prev_context] = BlockValidationContext(prev_header_context, prev_transactions_context)
    let (context) = read_block_validation_context{reader=reader}(prev_context)

    return ()
end
