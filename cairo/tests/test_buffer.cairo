#
# To run only this test suite use:
# protostar test  --cairo-path=./src target tests/*_buffer*
#

%lang starknet

from starkware.cairo.common.alloc import alloc
from src.buffer import flush_writer, init_writer, write_uint8, write_uint32_endian, init_reader, read_uint8, read_uint16, read_uint32, read_uint64, read_varint, read_bytes_endian, read_uint32_endian


@external
func test_read_uint8{range_check_ptr}():
    alloc_locals

    let (array) = alloc()
    assert array[0] = 0x01020304
    assert array[1] = 0x05000000
    
    let (reader) = init_reader(array)
    
    let (uint8_1) = read_uint8{reader=reader}()
    assert uint8_1 = 0x01

    let (uint8_2) = read_uint8{reader=reader}()
    assert uint8_2 = 0x02

    let (uint8_3) = read_uint8{reader=reader}()
    assert uint8_3 = 0x03

    let (uint8_4) = read_uint8{reader=reader}()
    assert uint8_4 = 0x04

    let (uint8_5) = read_uint8{reader=reader}()
    assert uint8_5 = 0x05
    
    return ()
end

@external
func test_read_uint16{range_check_ptr}():
    alloc_locals

    let (array) = alloc()
    assert array[0] = 0x01020304
    
    let (reader) = init_reader(array)
    
    let (uint16) = read_uint16{reader=reader}()
    assert uint16 = 0x0201
    
    return ()
end

@external
func test_read_uint32{range_check_ptr}():
    alloc_locals

    let (array) = alloc()
    assert array[0] = 0x01020304
    
    let (reader) = init_reader(array)
    
    let (uint32) = read_uint32{reader=reader}()
    assert uint32 = 0x04030201
    
    return ()
end

@external
func test_read_uint64{range_check_ptr}():
    alloc_locals

    let (array) = alloc()
    assert array[0] = 0x00e40b54
    assert array[1] = 0x02000000
    
    let (reader) = init_reader(array)
    
    let (uint64) = read_uint64{reader=reader}()
    assert uint64 = 10000000000
    
    return ()
end

@external
func test_read_varint{range_check_ptr}():
    alloc_locals

    let (array) = alloc()
    assert array[0] = 0x01fd0102
    assert array[1] = 0xfe010203
    assert array[2] = 0x04ff0102
    assert array[3] = 0x03040506
    assert array[4] = 0x07080000
    
    let (reader) = init_reader(array)
    
    let (varint8) = read_varint{reader=reader}()
    assert varint8 = 0x01
    
    let (varint16) = read_varint{reader=reader}()
    assert varint16 = 0x0201

    let (varint32) = read_varint{reader=reader}()
    assert varint32 = 0x04030201

    let (varint64) = read_varint{reader=reader}()
    assert varint64 = 0x0807060504030201
    
    return ()
end



@external
func test_read_bytes{range_check_ptr}():
    alloc_locals

    let (array) = alloc()
    assert array[0] = 0x01020304
    assert array[1] = 0x05060708
    assert array[2] = 0x090a0b0c
    
    let (reader) = init_reader(array)
    
    let (unit8_1) = read_uint8{reader=reader}()
    let (unit8_2) = read_uint8{reader=reader}()
    let (uint32) = read_uint32_endian{reader=reader}()
    let (uint32_endian) = read_uint32{reader=reader}()
    let (uint16) = read_uint16{reader=reader}()  # read the complete buffer until the last byte

    assert unit8_1 = 0x01
    assert unit8_2 = 0x02
    assert uint32 = 0x03040506
    assert uint32_endian = 0x0a090807
    assert uint16 = 0x0c0b

    return ()
end


@external
func test_read_bytes_into_felt{range_check_ptr}():
    alloc_locals

    let (array) = alloc()
    assert array[0] = 0x01020304
    assert array[1] = 0x05060708
    assert array[2] = 0x090a0b0c
    assert array[3] = 0x0d0e0f10
    assert array[4] = 0x11121314
    assert array[5] = 0x15161718
    
    let (reader) = init_reader(array)
    
    let (bytes3) = read_bytes_endian{reader=reader}(3)
    let (bytes5) = read_bytes_endian{reader=reader}(5)
    let (bytes6) = read_bytes_endian{reader=reader}(6)
    let (bytes7) = read_bytes_endian{reader=reader}(7)

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
func test_read_2_4_8_bytes{range_check_ptr}():
    alloc_locals

    let (array) = alloc()
    assert array[0] = 0x01020304
    assert array[1] = 0x050600e4
    assert array[2] = 0x0b540200
    assert array[3] = 0x00000000
    
    let (reader) = init_reader(array)
    
    let (uint16) = read_uint16{reader=reader}()
    assert uint16 = 0x0201
    
    let (uint32) = read_uint32{reader=reader}()
    assert uint32 = 0x06050403

    let (uint64) = read_uint64{reader=reader}()
    assert uint64 = 10000000000 

    return ()
end

@external
func test_writer{range_check_ptr}():
    alloc_locals
    let (array) = alloc()
    let (writer) = init_writer(array)
    write_uint8{writer=writer}(0x01)
    write_uint32_endian{writer=writer}(0x02030405)
    write_uint32_endian{writer=writer}(0x06070809)
    flush_writer(writer)
    
    assert array[0] = 0x01020304
    assert array[1] = 0x05060708
    assert array[2] = 0x09000000
    return ()
end
