// Serialization Library for Reading and Writing Byte Streams
//
// A byte stream is represented as an array of uint32 because
// the sha256 hash function works on 32-bit words, and feeding
// byte streams into the sha256 function is our main reason for
// serializing any block data.
//
// See also:
// - https://github.com/mimblewimble/grin/blob/master/core/src/ser.rs

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.pow import pow
from starkware.cairo.common.math import unsigned_div_rem, assert_le
from starkware.cairo.common.math_cmp import is_le

// The base for byte-wise shifts via multiplication and integer division
const BYTE = 2 ** 8;

// The byte sizes of Uint8, Uint16, Uint32, and Uint64
const UINT8_SIZE = 1;
const UINT16_SIZE = 2;
const UINT32_SIZE = 4;
const UINT64_SIZE = 8;

struct Reader {
    head: felt*,
    offset: felt,
    payload: felt,
}

func init_reader(array: felt*) -> (reader: Reader) {
    return (Reader(array, 0, 0),);
}

// Read a byte from the reader
func read_uint8{reader: Reader, range_check_ptr}() -> (byte: felt) {
    if (reader.offset == 0) {
        // The Reader is empty, so we read from the head, return the first byte,
        // and copy the remaining three bytes into the Reader's payload.
        let (byte, payload) = unsigned_div_rem([reader.head], BYTE ** 3);
        // TODO: Check for overflows. What if `byte` > 255 here?
        // assert_le(byte, BYTE - 1)
        let reader = Reader(reader.head + 1, UINT32_SIZE - 1, payload * BYTE);
        return (byte,);
    } else {
        // The Reader is not empty. So we read the first byte from its payload
        // and continue with the remaining bytes.
        let (byte, payload) = unsigned_div_rem(reader.payload, BYTE ** 3);
        let reader = Reader(reader.head, reader.offset - 1, payload * BYTE);
        return (byte,);
    }
}

func _read_n_bytes_into_felt{reader: Reader, range_check_ptr}(
    output: felt*, value, base, loop_counter
) {
    if (loop_counter == 0) {
        assert [output] = value;
        return ();
    }
    let (byte) = read_uint8();
    _read_n_bytes_into_felt(output, byte * base + value, base * BYTE, loop_counter - 1);
    return ();
}

func read_uint16{reader: Reader, range_check_ptr}() -> (result: felt) {
    alloc_locals;
    let (result) = alloc();
    _read_n_bytes_into_felt(result, 0, 1, UINT16_SIZE);
    return ([result],);
}

func read_uint32{reader: Reader, range_check_ptr}() -> (result: felt) {
    alloc_locals;
    let (result) = alloc();
    _read_n_bytes_into_felt(result, 0, 1, UINT32_SIZE);
    return ([result],);
}

func read_uint64{reader: Reader, range_check_ptr}() -> (result: felt) {
    alloc_locals;
    let (result) = alloc();
    _read_n_bytes_into_felt(result, 0, 1, UINT64_SIZE);
    return ([result],);
}

// Reads a VarInt from the buffer and returns a pair
// of the varint that was read and its byte size.
//
// See also:
// - https://developer.bitcoin.org/reference/transactions.html#compactsize-unsigned-integers
// - https://github.com/bitcoin/bitcoin/blob/9ba73758c908ce0c49f1bd9727ea496958e24d54/src/serialize.h#L275
//
func read_varint{reader: Reader, range_check_ptr}() -> (value: felt, byte_size: felt) {
    // Read the first byte
    let (first_byte) = read_uint8();

    // Now check how many more bytes we have to read

    if (first_byte == 0xff) {
        // This varint has 8 more bytes
        let (uint64) = read_uint64();
        with_attr error_message("Non-canonical read_varint"){
            assert_le(0x100000000, uint64);
        }
        return (uint64, UINT8_SIZE + UINT64_SIZE);
    }

    if (first_byte == 0xfe) {
        // This varint has 4 more bytes
        let (uint32) = read_uint32();
        with_attr error_message("Non-canonical read_varint"){
            assert_le(0x10000, uint32);
        }
        return (uint32, UINT8_SIZE + UINT32_SIZE);
    }

    if (first_byte == 0xfd) {
        // This varint has 2 more bytes
        let (uint16) = read_uint16();
        with_attr error_message("Non-canonical read_varint"){
            assert_le(253, uint16);
        }
        return (uint16, UINT8_SIZE + UINT16_SIZE);
    }

    // This varint is only 1 byte
    return (first_byte, UINT8_SIZE);
}

func _read_into_uint32_array{reader: Reader, range_check_ptr}(output: felt*, loop_counter) {
    if (loop_counter == 0) {
        return ();
    }
    _read_n_bytes_into_felt(output, 0, 1, UINT32_SIZE);
    _read_into_uint32_array(output + 1, loop_counter - 1);
    return ();
}

func read_bytes{reader: Reader, range_check_ptr}(length: felt) -> (result: felt*) {
    alloc_locals;

    let (result) = alloc();
    let (len_div_4, len_mod_4) = unsigned_div_rem(length, UINT32_SIZE);
    // Read as many 4-byte chunks as possible into the array
    _read_into_uint32_array(result, len_div_4);
    // Read up to three more bytes
    _read_n_bytes_into_felt(result + len_div_4, 0, 1, len_mod_4);
    return (result,);
}

func read_bytes_endian{reader: Reader, range_check_ptr}(length: felt) -> (result: felt*) {
    alloc_locals;

    let (result) = alloc();
    let (len_div_4, len_mod_4) = unsigned_div_rem(length, UINT32_SIZE);
    _read_into_uint32_array_endian(result, len_div_4);

    _read_n_bytes_into_felt_endian(result + len_div_4, 0, BYTE ** 3, len_mod_4);
    return (result,);
}

func _read_into_uint32_array_endian{reader: Reader, range_check_ptr}(output: felt*, loop_counter) {
    if (loop_counter == 0) {
        return ();
    }
    _read_n_bytes_into_felt_endian(output, 0, BYTE ** 3, UINT32_SIZE);
    _read_into_uint32_array_endian(output + 1, loop_counter - 1);
    return ();
}

func _read_n_bytes_into_felt_endian{reader: Reader, range_check_ptr}(
    output: felt*, value, base, loop_counter
) {
    if (loop_counter == 0) {
        assert [output] = value;
        return ();
    }
    let (byte) = read_uint8();
    _read_n_bytes_into_felt_endian(output, value + byte * base, base / BYTE, loop_counter - 1);
    return ();
}

func read_hash{reader: Reader, range_check_ptr}() -> (result: felt*) {
    return read_bytes_endian(32);
}

// Peek the first byte from a reader without increasing the reader's cursor
func peek_uint8{reader: Reader, range_check_ptr}() -> (byte: felt) {
    if (reader.offset == 0) {
        // The Reader's payload is empty, so we read from the head
        let (first_byte, _) = unsigned_div_rem([reader.head], BYTE ** 3);
        return (first_byte,);
    } else {
        // The Reader is not empty, so we read the first byte from its payload
        let (first_byte, _) = unsigned_div_rem(reader.payload, BYTE ** 3);
        return (first_byte,);
    }
}

struct Writer {
    head: felt*,
    offset: felt,
    payload: felt,
}

func init_writer(array: felt*) -> (writer: Writer) {
    return (Writer(array, 0, 0),);
}

// Any unwritten data in the writer's temporary memory is written to the writer.
func flush_writer{range_check_ptr}(writer: Writer) {
    // Write what's left in our writer
    // Then fill up the uint32 with trailing zeros
    let (base) = pow(BYTE, UINT32_SIZE - writer.offset);
    assert [writer.head] = writer.payload * base;
    return ();
}

func write_uint8{writer: Writer}(source) {
    alloc_locals;

    let value = writer.payload * BYTE + source;

    let offset = writer.offset + 1;
    if (offset == UINT32_SIZE) {
        assert [writer.head] = value;
        tempvar writer = Writer(writer.head + 1, 0, 0);
    } else {
        tempvar writer = Writer(writer.head, offset, value);
    }
    return ();
}

func write_uint16{writer: Writer, range_check_ptr}(source) {
    alloc_locals;
    let (uint8_1, uint8_0) = unsigned_div_rem(source, BYTE);
    write_uint8(uint8_0);
    write_uint8(uint8_1);
    return ();
}

func write_uint32{writer: Writer, range_check_ptr}(source) {
    alloc_locals;
    let (uint24, uint8_0) = unsigned_div_rem(source, BYTE);
    let (uint16, uint8_1) = unsigned_div_rem(uint24, BYTE);
    let (uint8_3, uint8_2) = unsigned_div_rem(uint16, BYTE);
    write_uint8(uint8_0);
    write_uint8(uint8_1);
    write_uint8(uint8_2);
    write_uint8(uint8_3);
    return ();
}

func write_uint64{writer: Writer, range_check_ptr}(source: felt) {
    alloc_locals;
    let (uint56, uint8_0) = unsigned_div_rem(source, BYTE);
    let (uint48, uint8_1) = unsigned_div_rem(uint56, BYTE);
    let (uint40, uint8_2) = unsigned_div_rem(uint48, BYTE);
    let (uint32, uint8_3) = unsigned_div_rem(uint40, BYTE);
    let (uint24, uint8_4) = unsigned_div_rem(uint32, BYTE);
    let (uint16, uint8_5) = unsigned_div_rem(uint24, BYTE);
    let (uint8_7, uint8_6) = unsigned_div_rem(uint16, BYTE);
    write_uint8(uint8_0);
    write_uint8(uint8_1);
    write_uint8(uint8_2);
    write_uint8(uint8_3);
    write_uint8(uint8_4);
    write_uint8(uint8_5);
    write_uint8(uint8_6);
    write_uint8(uint8_7);
    return ();
}

// Write a varint into the buffer.
func write_varint{writer: Writer, range_check_ptr}(source: felt) {
    alloc_locals;

    // Ensure source is a maximum of 8 bytes.
    with_attr error_message("ERROR: write_varint source exceeded the maximum of 8 bytes.") {
        // TODO: it seems like this error_message is never printed at all. Can we remove it?
        assert_le(source, BYTE ** 8 - 1);
    }

    let source_is_8_bytes = is_le(BYTE ** 4, source);
    if (source_is_8_bytes == 1) {
        // This varint has 8 more bytes after the leading byte.
        write_uint8(0xff);
        write_uint64(source);
        return ();
    }

    let source_is_4_bytes = is_le(BYTE ** 2, source);
    if (source_is_4_bytes == 1) {
        // This varint has 4 more bytes after the leading byte.
        write_uint8(0xfe);
        write_uint32(source);
        return ();
    }

    let source_is_2_bytes = is_le(BYTE, source);
    if (source_is_2_bytes == 1) {
        // This varint has 2 more bytes after the leading byte.
        write_uint8(0xfd);
        write_uint16(source);
        return ();
    }

    // This varint is only 1 byte.
    write_uint8(source);
    return ();
}

func write_uint32_endian{writer: Writer, range_check_ptr}(source) {
    alloc_locals;
    let (uint24, uint8_3) = unsigned_div_rem(source, BYTE);
    let (uint16, uint8_2) = unsigned_div_rem(uint24, BYTE);
    let (uint8_0, uint8_1) = unsigned_div_rem(uint16, BYTE);
    write_uint8(uint8_0);
    write_uint8(uint8_1);
    write_uint8(uint8_2);
    write_uint8(uint8_3);
    return ();
}

func write_hash{writer: Writer, range_check_ptr}(source: felt*) {
    write_uint32_endian(source[0]);
    write_uint32_endian(source[1]);
    write_uint32_endian(source[2]);
    write_uint32_endian(source[3]);
    write_uint32_endian(source[4]);
    write_uint32_endian(source[5]);
    write_uint32_endian(source[6]);
    write_uint32_endian(source[7]);
    return ();
}

// Return the number of UINT32 felt chunks required to store byte_size bytes.
func byte_size_to_felt_size{range_check_ptr}(byte_size) -> (felt_size: felt) {
    let (size_div_4, size_mod_4) = unsigned_div_rem(byte_size, UINT32_SIZE);
    if (size_mod_4 == 0) {
        return (size_div_4,);
    } else {
        return (size_div_4 + 1,);
    }
}
