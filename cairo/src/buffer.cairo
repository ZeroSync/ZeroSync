from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.pow import pow
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

struct Reader: 
    member pointer : felt*
    member offset : felt
end

func read_bytes{reader: Reader, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    length:felt) -> (result: felt*):
    alloc_locals

    let (result) = alloc()
    let (len_div_4, len_mod_4) = unsigned_div_rem(length, 4)
    _read_4_bytes_loop(result, len_div_4)
    
    _read_up_to_3_bytes_loop(result + len_div_4, 0, len_mod_4)

    return (result)
end

func _read_4_bytes_loop{reader: Reader, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    output: felt*, loop_counter):
    alloc_locals
    if loop_counter == 0:
        return ()
    end
    let (uint32) = read_bytes4()
    assert [output] = uint32
    _read_4_bytes_loop(output + 1, loop_counter-1)
    return ()
end

func _read_up_to_3_bytes_loop{reader: Reader, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    output: felt*, value, loop_counter):
    alloc_locals
    if loop_counter == 0:
        assert [output] = value
        return ()
    end
    let (byte) = read_byte()
    _read_up_to_3_bytes_loop(output, value * 2**8 + byte, loop_counter-1)
    return ()
end


func read_bytes4_endian{reader: Reader, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}() -> (result: felt):
    alloc_locals
    let (byte0) = read_byte()
    let (byte1) = read_byte()
    let (byte2) = read_byte()
    let (byte3) = read_byte()
    return (byte0 + byte1 * 2**8 + byte2 * 2**16 + byte3 * 2**24)
end 

func read_bytes4{reader: Reader, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}() -> (result: felt):
    alloc_locals
    let (byte3) = read_byte()
    let (byte2) = read_byte()
    let (byte1) = read_byte()
    let (byte0) = read_byte()
    return (byte0 + byte1 * 2**8 + byte2 * 2**16 + byte3 * 2**24)
end

func read_bytes3{reader: Reader, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}() -> (result: felt):
    alloc_locals
    let (byte2) = read_byte()
    let (byte1) = read_byte()
    let (byte0) = read_byte()
    return (byte0 + byte1 * 2**8 + byte2 * 2**16)
end

func read_bytes2{reader: Reader, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}() -> (result: felt):
    alloc_locals
    let (byte1) = read_byte()
    let (byte0) = read_byte()
    return (byte0 + byte1 * 2**8)
end 

func read_byte{reader: Reader, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}() -> (byte: felt):
    let (tmp1) = pow(2**8, 3 - reader.offset)
    let (tmp2) = bitwise_and([reader.pointer], 0xff * tmp1) 
    let byte = tmp2 / tmp1

    let offset = reader.offset + 1
    if offset == 4:
        tempvar reader = Reader(reader.pointer + 1, 0)
    else: 
        tempvar reader = Reader(reader.pointer, offset)
    end

    return (byte)
end

func init_reader(array: felt*) -> (reader : Reader):
    let reader = Reader(array, 0)
    return (reader)
end 


struct Writer:
    member pointer : felt*
    member offset : felt
    member temp : felt 
end

func write_byte{writer: Writer, range_check_ptr}(source):
    alloc_locals
    
    let (masked_value) = pow(2**8, 3 - writer.offset)
    let value = writer.temp + masked_value * source
    
    let offset = writer.offset + 1
    if offset == 4:
        assert [writer.pointer] = value
        tempvar writer = Writer(writer.pointer + 1, 0, 0)
    else: 
        tempvar writer = Writer(writer.pointer, offset, value)
    end
    
    return ()
end

func write_bytes4{writer: Writer, range_check_ptr}(source):
    alloc_locals
    let (uint24,  uint8_3) = unsigned_div_rem(source,  2**8)
    let (uint16,  uint8_2) = unsigned_div_rem(uint24,  2**8)
    let (uint8_0, uint8_1) = unsigned_div_rem(uint16,  2**8)
    write_byte(uint8_0)
    write_byte(uint8_1)
    write_byte(uint8_2)
    write_byte(uint8_3)
    return ()
end

func init_writer(array: felt*) -> (writer : Writer):
    let writer = Writer(array, 0, 0)
    return (writer)
end 

# Any unwritten data in the writer's temporary memory is written to the writer.
func flush_writer( writer: Writer ):
    assert [writer.pointer] = writer.temp
    return ()
end