#
# To run only this test suite use:
# protostar test  --cairo-path=./src target tests/*_buffer*
#

%lang starknet

from starkware.cairo.common.alloc import alloc
from src.buffer import flush_buffer, init_buffer, write_byte, write_bytes4

@external
func test_buffer{range_check_ptr}():
    alloc_locals
    let (array) = alloc()
    let (buffer) = init_buffer(array)
    write_byte{buffer = buffer}(0x01)
    write_bytes4{buffer = buffer}(0x02030405)
    write_bytes4{buffer = buffer}(0x06070809)
    flush_buffer(buffer)
    
    assert array[0] = 0x01020304
    assert array[1] = 0x05060708
    assert array[2] = 0x09000000
    return ()
end
