# Serialization Library
# Functions for reading and writing byte buffers
# 
# Inspired by https://github.com/mimblewimble/grin/blob/master/core/src/ser.rs
#
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.pow import pow
from starkware.cairo.common.math import unsigned_div_rem

struct Reader: 
    member pointer : felt*
    member offset : felt
    member payload : felt
end

func init_reader(array: felt*) -> (reader : Reader):
    # Read the first element into payload
    let reader = Reader(array, 0, 0)
    return (reader)
end 

func read_byte{reader: Reader, range_check_ptr}() -> (byte: felt):
    if reader.offset == 0:
        let (byte, payload) = unsigned_div_rem([reader.pointer], 2**24)
        tempvar reader = Reader(reader.pointer + 1, 3, payload * 2**8)
        return (byte)
    else: 
        let (byte, payload) = unsigned_div_rem(reader.payload, 2**24)
        tempvar reader = Reader(reader.pointer, reader.offset - 1, payload * 2**8)
        return (byte)
    end
end

func read_bytes{reader: Reader, range_check_ptr}(
    length:felt) -> (result: felt*):
    alloc_locals

    let (result) = alloc()
    let (len_div_4, len_mod_4) = unsigned_div_rem(length, 4)
    _read_4_byte_chunks_into_array(result, len_div_4)
    _read_n_bytes_into_felt(result + len_div_4, 0, len_mod_4)

    return (result)
end

func _read_4_byte_chunks_into_array{reader: Reader, range_check_ptr}(
    output: felt*, loop_counter):
    if loop_counter == 0:
        return ()
    end
    _read_n_bytes_into_felt(output, 0, 4)
    _read_4_byte_chunks_into_array(output + 1, loop_counter-1)
    return ()
end

func _read_n_bytes_into_felt{reader: Reader, range_check_ptr}(
    output: felt*, value, loop_counter):
    if loop_counter == 0:
        assert [output] = value
        return ()
    end
    let (byte) = read_byte()
    _read_n_bytes_into_felt(output, value * 2**8 + byte, loop_counter-1)
    return ()
end

func read_4_bytes{reader: Reader, range_check_ptr}() -> (result: felt):
    alloc_locals
    let (result) = alloc()
    _read_n_bytes_into_felt(result, 0, 4)
    return ([result])
end

func read_3_bytes{reader: Reader, range_check_ptr}() -> (result: felt):
    alloc_locals
    let (result) = alloc()
    _read_n_bytes_into_felt(result, 0, 3)
    return ([result])
end

func read_2_bytes{reader: Reader, range_check_ptr}() -> (result: felt):
    alloc_locals
    let (result) = alloc()
    _read_n_bytes_into_felt(result, 0, 2)
    return ([result])
end 



func read_4_bytes_endian{reader: Reader, range_check_ptr}() -> (result: felt):
    alloc_locals
    let (uint8_0) = read_byte()
    let (uint8_1) = read_byte()
    let (uint8_2) = read_byte()
    let (uint8_3) = read_byte()
    return (uint8_3 * 2**24 + uint8_2 * 2**16 + uint8_1 * 2**8 + uint8_0)
end 

func read_8_bytes_endian{reader: Reader, range_check_ptr}() -> (result: felt):
    alloc_locals
    let (uint32_0) = read_4_bytes_endian()
    let (uint32_1) = read_4_bytes_endian()
    return (uint32_1 * 2**32 + uint32_0)
end

func read_hash{reader: Reader, range_check_ptr}(
    ) -> (result: felt*):
    return read_bytes(32)
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
func flush_writer{range_check_ptr}( writer: Writer): 
    # Write what's left in our writer 
    # Then fill up the uint with zeros
    let (base) = pow(2**8, 4 - writer.offset)
    assert [writer.pointer] = writer.temp * base
    return ()
end

func write_byte{writer: Writer}(source):
    alloc_locals
    
    let value =  writer.temp * 2**8 + source
    
    let offset = writer.offset + 1
    if offset == 4:
        assert [writer.pointer] = value
        tempvar writer = Writer(writer.pointer + 1, 0, 0)
    else: 
        tempvar writer = Writer(writer.pointer, offset, value)
    end
    
    return ()
end

func write_4_bytes{writer: Writer, range_check_ptr}(source):
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


func write_4_bytes_endian{writer: Writer, range_check_ptr}(source):
    alloc_locals
    let (uint24,  uint8_0) = unsigned_div_rem(source,  2**8)
    let (uint16,  uint8_1) = unsigned_div_rem(uint24,  2**8)
    let (uint8_3, uint8_2) = unsigned_div_rem(uint16,  2**8)
    write_byte(uint8_0)
    write_byte(uint8_1)
    write_byte(uint8_2)
    write_byte(uint8_3)
    return ()
end


func write_hash{ writer: Writer, range_check_ptr}(source: felt*):
    write_4_bytes(source[0])
    write_4_bytes(source[1])
    write_4_bytes(source[2])
    write_4_bytes(source[3])
    write_4_bytes(source[4])
    write_4_bytes(source[5])
    write_4_bytes(source[6])
    write_4_bytes(source[7])
    return ()
end
