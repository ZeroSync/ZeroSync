#
# To run only this test suite use:
# protostar test  --cairo-path=./src target tests/*_block_header*
#

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from tests.utils_for_testing import setup_python_defs
from buffer import init_reader, init_writer, flush_writer
from crypto.sha256d.sha256d import assert_hashes_equal
from block_header import read_block_header, write_block_header, bits_to_target, BLOCK_HEADER_FELT_SIZE, BlockHeaderValidationContext, read_block_header_validation_context, validate_block_header, ChainState

# Test block header serialization
# 
# See also:
# - https://developer.bitcoin.org/reference/block_chain.html#block-headers
#
# Example copied from:
# - https://blockstream.info/block/000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728
# - https://blockstream.info/api/block/000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728/header
@external
func test_serialize_block_header{range_check_ptr}():
    alloc_locals
    setup_python_defs()

    let (block_header_raw) = alloc()
    %{
        from_hex((
            "02000000b6ff0b1b1680a2862a30ca44d346d9e8910d334beb48ca0c00000000"
            "000000009d10aa52ee949386ca9385695f04ede270dda20810decd12bc9b048a"
            "aab3147124d95a5430c31b18fe9f0864"), ids.block_header_raw)
    %}    
    
    let (reader) = init_reader(block_header_raw)
    
    let (block_header) = read_block_header{reader=reader}()


    # Test block version
    assert block_header.version = 0x02
    
    # Test hash of the previous block
    let (prev_block_hash_expected) = alloc()
    %{
        hashes_from_hex(["00000000000000000cca48eb4b330d91e8d946d344ca302a86a280161b0bffb6"], 
            ids.prev_block_hash_expected)
    %}
    assert_hashes_equal(block_header.prev_block_hash, prev_block_hash_expected)

    # TODO: Test more block properties here

    let (block_header_serialized) = alloc()
    let (writer) = init_writer(block_header_serialized)
    write_block_header{writer=writer}(block_header)
    flush_writer(writer)

    # Caution! Check equality properly. If `block_header_raw` is empty then we perform a copy here
    # and the test succeeds even though it should fail!
    memcpy(block_header_raw, block_header_serialized, BLOCK_HEADER_FELT_SIZE) 
    
    return ()
end


# Test a block header validation context
#
# A previous block header is necessary to do this. So we use two subsequent headers here.
# 
# Example block headers
# 
# Block at height 328734:
# - https://blockstream.info/block/000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728
# - https://blockstream.info/api/block/000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728/header
#
# Block at height 328733:
# - https://blockstream.info/block/00000000000000000cca48eb4b330d91e8d946d344ca302a86a280161b0bffb6
# - https://blockstream.info/api/block/00000000000000000cca48eb4b330d91e8d946d344ca302a86a280161b0bffb6/header
@external
func test_read_block_header_validation_context{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    setup_python_defs()

    let (block_header_raw) = alloc()
    %{
        from_hex((
            "02000000b6ff0b1b1680a2862a30ca44d346d9e8910d334beb48ca0c00000000"
            "000000009d10aa52ee949386ca9385695f04ede270dda20810decd12bc9b048a"
            "aab3147124d95a5430c31b18fe9f0864"), ids.block_header_raw)
    %}    
    
    let (reader) = init_reader(block_header_raw)

    # Create a dummy for the previous chain state
    let (prev_block_hash) = alloc()
    %{
        hashes_from_hex([
            "00000000000000000cca48eb4b330d91e8d946d344ca302a86a280161b0bffb6"
        ], ids.prev_block_hash)
    %}

    let (prev_timestamps) = alloc()
    let prev_chain_state = ChainState(
        block_height = 328733,
        total_work = 0,
        best_hash = prev_block_hash,
        difficulty = 0,
        epoch_start_time = 0,
        prev_timestamps
    )
    
    # Read a block header from the byte stream
    # This is our next chain tip
    let (context) = read_block_header_validation_context{reader=reader}(prev_chain_state)

    # Sanity check: block version should be 2
    assert context.block_header.version = 0x02

    # Check if the target was computed correctly
    assert context.target = 0x1bc330000000000000000000000000000000000000000000

    # Check if the block hash is correct
    let (block_hash_expected) = alloc()
    %{
        hashes_from_hex([
            "000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728"
            ], ids.block_hash_expected)
    %} 
    assert_hashes_equal(context.block_hash, block_hash_expected)

    # Try to validate the block header. 
    # This should succeed for valid block headers
    validate_block_header(context)

    return ()
end


@external
func test_bits_to_target{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}():
    alloc_locals
    let bits = 0x181bc330
    let (target) = bits_to_target(bits)
    assert target = 0x1bc330000000000000000000000000000000000000000000
    return ()
end
