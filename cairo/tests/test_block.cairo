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

# Test a simple bitcoin block. (Example block from block height 6425)
# 
# - Block hash: 000000004d15e01d3ffc495df7bb638c2b35c5b5dd0ba405615f513e3393f0c7
# - Block explorer: https://blockstream.info/block/000000004d15e01d3ffc495df7bb638c2b35c5b5dd0ba405615f513e3393f0c7
# - Blockstream API: https://blockstream.info/api/block/000000004d15e01d3ffc495df7bb638c2b35c5b5dd0ba405615f513e3393f0c7
# - Stackoverflow: https://stackoverflow.com/questions/67631407/raw-or-hex-of-a-whole-bitcoin-block
# - Blockchair: https://api.blockchair.com/bitcoin/raw/block/000000004d15e01d3ffc495df7bb638c2b35c5b5dd0ba405615f513e3393f0c7
@external
func test_read_block_validation_context{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    setup_python_defs()

    let (block_raw) = alloc()
    %{

        #from_hex((
        #    "01000000a0d4ea3416518af0b238fef847274fc768cd39d0dc44a0ea5ec0c2dd"
        #    "000000007edfbf7974109f1fd628f17dfefd4915f217e0ec06e0c74e45049d36"
        #    "850abca4bc0eb049ffff001d27d0031e01010000000100000000000000000000"
        #    "00000000000000000000000000000000000000000000ffffffff0804ffff001d"
        #    "024f02ffffffff0100f2052a010000004341048a5294505f44683bbc2be81e0f"
        #    "6a91ac1a197d6050accac393aad3b86b2398387e34fedf0de5d9f185eb3f2c17"
        #    "f3564b9170b9c262aa3ac91f371279beca0cafac00000000"
        #    ), ids.block_raw)

        from_hex((
            "01000000a0d4ea3416518af0b238fef847274fc768cd39d0dc44a0ea5ec0c2dd000000007edfbf7974109f1fd628f17dfefd4915f217e0ec06e0c74e45049d36850abca4bc0eb049ffff001d27d0031e0101000000010000000000000000000000000000000000000000000000000000000000000000ffffffff0804ffff001d024f02ffffffff0100f2052a010000004341048a5294505f44683bbc2be81e0f6a91ac1a197d6050accac393aad3b86b2398387e34fedf0de5d9f185eb3f2c17f3564b9170b9c262aa3ac91f371279beca0cafac00000000"
            ), ids.block_raw)
    %}    
    
    let (reader) = init_reader(block_raw)

    # Create a previous context
    let (local prev_header_context: BlockHeaderValidationContext*) = alloc()
    let (local prev_transactions_context: TransactionValidationContext*) = alloc()
    let (prev_context: BlockValidationContext*) = alloc()
    assert [prev_context] = BlockValidationContext(
        prev_header_context, 
        0, 
        prev_transactions_context
    )

    # Parse the block validation context 
    let (context) = read_block_validation_context{reader=reader}(prev_context)

    return ()
end

