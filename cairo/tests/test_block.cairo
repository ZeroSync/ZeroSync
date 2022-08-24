#
# To run only this test suite use:
# protostar test  --cairo-path=./src target tests/*_block.cairo
#

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from utils_for_testing import setup_python_defs
from transaction import TransactionValidationContext
from block_header import ChainState
from block import BlockValidationContext, State, read_block_validation_context, validate_and_apply_block

from buffer import init_reader
from tests.test_block_header import dummy_prev_timestamps

# Test a simple Bitcoin block with only a single transaction.
#
# Example: Block at height 6425
# 
# - Block hash: 000000004d15e01d3ffc495df7bb638c2b35c5b5dd0ba405615f513e3393f0c7
# - Block explorer: https://blockstream.info/block/000000004d15e01d3ffc495df7bb638c2b35c5b5dd0ba405615f513e3393f0c7
# - Stackoverflow: https://stackoverflow.com/questions/67631407/raw-or-hex-of-a-whole-bitcoin-block
# - Blockchair: https://api.blockchair.com/bitcoin/raw/block/000000004d15e01d3ffc495df7bb638c2b35c5b5dd0ba405615f513e3393f0c7
@external
func test_read_block_validation_context{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    setup_python_defs()

    let (block_raw) = alloc()
    %{

        from_hex((
            "01000000a0d4ea3416518af0b238fef847274fc768cd39d0dc44a0ea5ec0c2dd"
            "000000007edfbf7974109f1fd628f17dfefd4915f217e0ec06e0c74e45049d36"
            "850abca4bc0eb049ffff001d27d0031e01010000000100000000000000000000"
            "00000000000000000000000000000000000000000000ffffffff0804ffff001d"
            "024f02ffffffff0100f2052a010000004341048a5294505f44683bbc2be81e0f"
            "6a91ac1a197d6050accac393aad3b86b2398387e34fedf0de5d9f185eb3f2c17"
            "f3564b9170b9c262aa3ac91f371279beca0cafac00000000"
            ), ids.block_raw)
    %}    
    

    # Create a dummy for the previous chain state
    let (reader) = init_reader(block_raw)
    let (prev_block_hash) = alloc()
    %{
        hashes_from_hex([
            "00000000ddc2c05eeaa044dcd039cd68c74f2747f8fe38b2f08a511634ead4a0"
        ], ids.prev_block_hash)
    %}

    let (prev_timestamps) = dummy_prev_timestamps()

    let prev_chain_state = ChainState(
        block_height = 328733,
        total_work = 0,
        best_hash = prev_block_hash,
        difficulty = 0,
        epoch_start_time = 0,
        prev_timestamps
    )
    let (prev_state_root) = alloc()

    let prev_state = State(
        prev_chain_state,
        prev_state_root
    )

    # Parse the block validation context 
    let (context) = read_block_validation_context{reader=reader}(prev_state)

    validate_and_apply_block(context)
    return ()
end

# Test a Bitcoin block with 5 transactions.
#
# Example: Block at height 100000
# 
# - Block hash: 000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506
# - Block explorer: https://blockstream.info/block/000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506
# - Stackoverflow: https://stackoverflow.com/questions/67631407/raw-or-hex-of-a-whole-bitcoin-block
# - Blockchair: https://api.blockchair.com/bitcoin/raw/block/000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506
@external
func test_read_block_with_5_transactions{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    setup_python_defs()

    let (block_raw) = alloc()
    %{

        from_hex((
            "0100000050120119172a610421a6c3011dd330d9df07b63616c2cc1f1cd00200000000006657a9252aacd5c0b2940996ecff952228c3067cc38d4885efb5a4ac"
            "4247e9f337221b4d4c86041b0f2b57100401000000010000000000000000000000000000000000000000000000000000000000000000ffffffff08044c86041b"
            "020602ffffffff0100f2052a010000004341041b0e8c2567c12536aa13357b79a073dc4444acb83c4ec7a0e2f99dd7457516c5817242da796924ca4e99947d08"
            "7fedf9ce467cb9f7c6287078f801df276fdf84ac000000000100000001032e38e9c0a84c6046d687d10556dcacc41d275ec55fc00779ac88fdf357a187000000"
            "008c493046022100c352d3dd993a981beba4a63ad15c209275ca9470abfcd57da93b58e4eb5dce82022100840792bc1f456062819f15d33ee7055cf7b5ee1af1"
            "ebcc6028d9cdb1c3af7748014104f46db5e9d61a9dc27b8d64ad23e7383a4e6ca164593c2527c038c0857eb67ee8e825dca65046b82c9331586c82e0fd1f633f"
            "25f87c161bc6f8a630121df2b3d3ffffffff0200e32321000000001976a914c398efa9c392ba6013c5e04ee729755ef7f58b3288ac000fe208010000001976a9"
            "14948c765a6914d43f2a7ac177da2c2f6b52de3d7c88ac000000000100000001c33ebff2a709f13d9f9a7569ab16a32786af7d7e2de09265e41c61d078294ecf"
            "010000008a4730440220032d30df5ee6f57fa46cddb5eb8d0d9fe8de6b342d27942ae90a3231e0ba333e02203deee8060fdc70230a7f5b4ad7d7bc3e628cbe21"
            "9a886b84269eaeb81e26b4fe014104ae31c31bf91278d99b8377a35bbce5b27d9fff15456839e919453fc7b3f721f0ba403ff96c9deeb680e5fd341c0fc3a7b9"
            "0da4631ee39560639db462e9cb850fffffffff0240420f00000000001976a914b0dcbf97eabf4404e31d952477ce822dadbe7e1088acc060d211000000001976"
            "a9146b1281eec25ab4e1e0793ff4e08ab1abb3409cd988ac0000000001000000010b6072b386d4a773235237f64c1126ac3b240c84b917a3909ba1c43ded5f51"
            "f4000000008c493046022100bb1ad26df930a51cce110cf44f7a48c3c561fd977500b1ae5d6b6fd13d0b3f4a022100c5b42951acedff14abba2736fd574bdb46"
            "5f3e6f8da12e2c5303954aca7f78f3014104a7135bfe824c97ecc01ec7d7e336185c81e2aa2c41ab175407c09484ce9694b44953fcb751206564a9c24dd094d4"
            "2fdbfdd5aad3e063ce6af4cfaaea4ea14fbbffffffff0140420f00000000001976a91439aa3d569e06a1d7926dc4be1193c99bf2eb9ee088ac00000000"
            ), ids.block_raw)
    %}    
    
    let (reader) = init_reader(block_raw)

    # Create a dummy for the previous chain state
    # Block 99999: https://blockstream.info/block/000000000002d01c1fccc21636b607dfd930d31d01c3a62104612a1719011250
    let (prev_block_hash) = alloc()
    %{
        hashes_from_hex([
            "000000000002d01c1fccc21636b607dfd930d31d01c3a62104612a1719011250"
        ], ids.prev_block_hash)
    %}

    let (prev_timestamps) = dummy_prev_timestamps()
    
    let prev_chain_state = ChainState(
        block_height = 99999,
        total_work = 0,
        best_hash = prev_block_hash,
        difficulty = 0,
        epoch_start_time = 0,
        prev_timestamps
    )

    let (prev_state_root) = alloc()

    let prev_state = State(
        prev_chain_state,
        prev_state_root
    )

    # Parse the block validation context using the previous state
    let (context) = read_block_validation_context{reader=reader}(prev_state)

    # Sanity Check 
    # The second output of the second transaction should be 44.44 BTC
    let transaction = context.transaction_contexts[1].transaction
    assert transaction.outputs[1].amount = 4444 * 10**6
    
    # Validate the block
    validate_and_apply_block(context)

    return ()
end

