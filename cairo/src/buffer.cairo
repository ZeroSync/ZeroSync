# Serialization Library
# Functions for reading and writing byte buffers
# 
# Inspired by https://github.com/mimblewimble/grin/blob/master/core/src/ser.rs
#
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.pow import pow
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

struct Reader: 
    member pointer : felt*
    member offset : felt
end

func init_reader(array: felt*) -> (reader : Reader):
    let reader = Reader(array, 0)
    return (reader)
end 

func read_bytes{reader: Reader, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    length:felt) -> (result: felt*):
    alloc_locals

    let (result) = alloc()
    let (len_div_4, len_mod_4) = unsigned_div_rem(length, 4)
    _read_4_bytes_into_array_loop(result, len_div_4)
    _read_n_bytes_into_felt_loop(result + len_div_4, 0, len_mod_4)

    return (result)
end

func _read_4_bytes_into_array_loop{reader: Reader, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    output: felt*, loop_counter):
    if loop_counter == 0:
        return ()
    end
    _read_n_bytes_into_felt_loop(output, 0, 4)
    _read_4_bytes_into_array_loop(output + 1, loop_counter-1)
    return ()
end

func _read_n_bytes_into_felt_loop{reader: Reader, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    output: felt*, value, loop_counter):
    if loop_counter == 0:
        assert [output] = value
        return ()
    end
    let (byte) = read_byte()
    _read_n_bytes_into_felt_loop(output, value * 2**8 + byte, loop_counter-1)
    return ()
end

func read_bytes4{reader: Reader, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}() -> (result: felt):
    alloc_locals
    let (result) = alloc()
    _read_n_bytes_into_felt_loop(result, 0, 4)
    return ([result])
end

func read_bytes3{reader: Reader, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}() -> (result: felt):
    alloc_locals
    let (result) = alloc()
    _read_n_bytes_into_felt_loop(result, 0, 3)
    return ([result])
end

func read_bytes2{reader: Reader, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}() -> (result: felt):
    alloc_locals
    let (result) = alloc()
    _read_n_bytes_into_felt_loop(result, 0, 2)
    return ([result])
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

func read_bytes4_endian{reader: Reader, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}() -> (result: felt):
    alloc_locals
    let (uint8_0) = read_byte()
    let (uint8_1) = read_byte()
    let (uint8_2) = read_byte()
    let (uint8_3) = read_byte()
    return (uint8_3 * 2**24 + uint8_2 * 2**16 + uint8_1 * 2**8 + uint8_0)
end 

func read_bytes8_endian{reader: Reader, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}() -> (result: felt):
    alloc_locals
    let (uint32_0) = read_bytes4_endian()
    let (uint32_1) = read_bytes4_endian()
    return (uint32_1 * 2**32 + uint32_0)
end

struct Writer:
    member pointer : felt*
    member offset : felt
    member temp : felt 
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

