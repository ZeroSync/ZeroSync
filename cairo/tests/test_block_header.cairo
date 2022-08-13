#
# To run only this test suite use:
# protostar test  --cairo-path=./src target tests/*_block_header*
#

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from tests.utils_for_testing import setup_hashes
from buffer import init_reader, init_writer, flush_writer
from utils import assert_hashes_equal
from block_header import read_block_header, write_block_header, bits_to_target, FELT_SIZE_OF_BLOCK_HEADER, BlockHeaderValidationContext, read_block_header_validation_context

@external
func test_serialize_block_header{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    # Block Header example 
    # Copied from:
    # https://developer.bitcoin.org/reference/block_chain.html#block-headers
    # https://blockstream.info/block/000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728
    alloc_locals
    setup_hashes()

    let (array) = alloc()
    # TODO: retrieve the header from python
    assert array[0]  = 0x02000000
    assert array[1]  = 0xb6ff0b1b
    assert array[2]  = 0x1680a286
    assert array[3]  = 0x2a30ca44
    assert array[4]  = 0xd346d9e8
    assert array[5]  = 0x910d334b
    assert array[6]  = 0xeb48ca0c
    assert array[7]  = 0x00000000
    assert array[8]  = 0x00000000
    assert array[9]  = 0x9d10aa52
    assert array[10] = 0xee949386
    assert array[11] = 0xca938569
    assert array[12] = 0x5f04ede2
    assert array[13] = 0x70dda208
    assert array[14] = 0x10decd12
    assert array[15] = 0xbc9b048a
    assert array[16] = 0xaab31471
    assert array[17] = 0x24d95a54
    assert array[18] = 0x30c31b18
    assert array[19] = 0xfe9f0864
    
    let (reader) = init_reader(array)
    let (block_header) = read_block_header{reader=reader}()

    # Test block version
    assert block_header.version = 0x02
    
    # Test hash of the previous block
    let (prev_block_hash_expected) = alloc()
    %{
        write_hashes(["00000000000000000cca48eb4b330d91e8d946d344ca302a86a280161b0bffb6"], 
            ids.prev_block_hash_expected)
    %}
    assert_hashes_equal(block_header.prev_block_hash, prev_block_hash_expected)

    # TODO: Test more block properties

    let (block_header_serialized) = alloc()
    let (writer) = init_writer(block_header_serialized)
    write_block_header{writer=writer}(block_header)
    flush_writer(writer)

    # Caution! Check equality properly. If `array` is empty then we perform a copy here
    # and the test succeeds even though it should fail!
    memcpy(array, block_header_serialized, FELT_SIZE_OF_BLOCK_HEADER) 
    

    return ()
end


@external
func test_read_block_header_validation_context{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    # Block Header example 
    # Copied from:
    # https://developer.bitcoin.org/reference/block_chain.html#block-headers
    # https://blockstream.info/block/000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728
    alloc_locals
    setup_hashes()

    let (array) = alloc()
    # TODO: retrieve the header from python
    assert array[0]  = 0x02000000
    assert array[1]  = 0xb6ff0b1b
    assert array[2]  = 0x1680a286
    assert array[3]  = 0x2a30ca44
    assert array[4]  = 0xd346d9e8
    assert array[5]  = 0x910d334b
    assert array[6]  = 0xeb48ca0c
    assert array[7]  = 0x00000000
    assert array[8]  = 0x00000000
    assert array[9]  = 0x9d10aa52
    assert array[10] = 0xee949386
    assert array[11] = 0xca938569
    assert array[12] = 0x5f04ede2
    assert array[13] = 0x70dda208
    assert array[14] = 0x10decd12
    assert array[15] = 0xbc9b048a
    assert array[16] = 0xaab31471
    assert array[17] = 0x24d95a54
    assert array[18] = 0x30c31b18
    assert array[19] = 0xfe9f0864
    
    
    let (reader) = init_reader(array)
    
    let (local prev_context : BlockHeaderValidationContext*) = alloc()
    let (validation_context) = read_block_header_validation_context{reader=reader}(prev_context)

    assert validation_context.block_header.version = 0x02

    let (block_hash_expected) = alloc()
    %{
        write_hashes(["000000000000000009a11b3972c8e532fe964de937c9e0096b43814e67af3728"], 
            ids.block_hash_expected)
    %}
    assert_hashes_equal(validation_context.block_hash, block_hash_expected)


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
