#
# To run only this test suite use:
# protostar test  --cairo-path=./src target tests/*_buffer*
#

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from src.buffer import flush_writer, init_writer, write_byte, write_bytes4, init_reader, read_byte, read_bytes2, read_bytes3, read_bytes4, read_bytes4_endian, read_bytes


@external
func test_read_bytes{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals

    let (array) = alloc()
    assert array[0] = 0x01020304
    assert array[1] = 0x05060708
    assert array[2] = 0x090a0b0c
    assert array[3] = 0x0d0e0f10
    
    let (reader) = init_reader(array)
    
    let (byte1) = read_byte{reader = reader}()
    let (byte2) = read_byte{reader = reader}()
    let (bytes4) = read_bytes4{reader = reader}()
    let (bytes4_endian) = read_bytes4_endian{reader = reader}()
    
    assert byte1 = 0x01
    assert byte2 = 0x02
    assert bytes4 = 0x03040506
    assert bytes4_endian = 0x0a090807
   
    return ()
end


@external
func test_read_bytes_into_felt{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals

    let (array) = alloc()
    assert array[0] = 0x01020304
    assert array[1] = 0x05060708
    assert array[2] = 0x090a0b0c
    assert array[3] = 0x0d0e0f10
    assert array[4] = 0x11121314
    assert array[5] = 0x15161718
    
    let (reader) = init_reader(array)
    
    let (bytes3) = read_bytes{reader = reader}(3)
    let (bytes5) = read_bytes{reader = reader}(5)
    let (bytes6) = read_bytes{reader = reader}(6)
    let (bytes7) = read_bytes{reader = reader}(7)

    assert bytes3[0] = 0x010203

    assert bytes5[0] = 0x04050607
    assert bytes5[1] = 0x08

    assert bytes6[0] = 0x090a0b0c
    assert bytes6[1] = 0x0d0e

    assert bytes7[0] = 0x0f101112
    assert bytes7[1] = 0x131415
   
    return ()
end


@external
func test_read_2_3_4_bytes{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals

    let (array) = alloc()
    assert array[0] = 0x01020304
    assert array[1] = 0x05060708
    assert array[2] = 0x090a0b0c
    assert array[3] = 0x0d0e0f10
    assert array[4] = 0x11121314
    assert array[5] = 0x15161718
    
    let (reader) = init_reader(array)
    
    let (bytes2) = read_bytes2{reader = reader}()
    let (bytes3) = read_bytes3{reader = reader}()
    let (bytes4) = read_bytes4{reader = reader}()

    assert bytes2 = 0x0102
    assert bytes3 = 0x030405
    assert bytes4 = 0x06070809
   
    return ()
end

@external
func test_writer{range_check_ptr}():
    alloc_locals
    let (array) = alloc()
    let (writer) = init_writer(array)
    write_byte{writer = writer}(0x01)
    write_bytes4{writer = writer}(0x02030405)
    write_bytes4{writer = writer}(0x06070809)
    flush_writer(writer)
    
    assert array[0] = 0x01020304
    assert array[1] = 0x05060708
    assert array[2] = 0x09000000
    return ()
end
