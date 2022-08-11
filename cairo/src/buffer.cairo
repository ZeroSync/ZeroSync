from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.pow import pow
from starkware.cairo.common.math import unsigned_div_rem

struct Buffer:
    member pointer : felt*
    member offset : felt
    member temp : felt 
end

func write_byte{buffer: Buffer, range_check_ptr}(source):
    alloc_locals
    
    let (masked_value) = pow(2**8, 3 - buffer.offset)
    let value = buffer.temp + masked_value * source
    
    let offset = buffer.offset + 1
    if offset == 4:
        assert [buffer.pointer] = value
        tempvar buffer = Buffer(buffer.pointer + 1, 0, 0)
    else: 
        tempvar buffer = Buffer(buffer.pointer, offset, value)
    end
    
    return ()
end

func write_bytes4{buffer: Buffer, range_check_ptr}(source):
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

func init_buffer(array: felt*) -> (buffer : Buffer):
    let buffer = Buffer(array, 0, 0)
    return (buffer)
end 

func flush_buffer( buffer: Buffer ):
    assert [buffer.pointer] = buffer.temp
    return ()
end