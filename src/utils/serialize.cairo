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
from starkware.cairo.common.math import assert_not_zero, assert_le, assert_le_felt
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256

from utils.endianness import byteswap16, byteswap32

// The base for byte-wise shifts via multiplication and integer division
const BYTE = 2 ** 8;
const UINT16 = 2 ** 16;
const UINT32 = 2 ** 32;
const UINT64 = 2 ** 64;
const UINT128 = 2 ** 128;

// The byte sizes of Uint8, Uint16, Uint32, and Uint64
const UINT8_SIZE = 1;
const UINT16_SIZE = 2;
const UINT32_SIZE = 4;
const UINT64_SIZE = 8;
const UINT128_SIZE = 16;
const UINT256_SIZE = 32;


struct Reader {
	cur: felt,
	buf: felt,
	ptr: felt*,
}

func init_reader(ptr: felt*) -> Reader {
	let reader = Reader(1, 0, ptr);
	return reader;
}

// Read a byte from the reader
func read_uint8{reader: Reader, bitwise_ptr: BitwiseBuiltin*}() -> felt {
	alloc_locals;
	if (reader.cur == 1) {
        // The Reader is empty, so we read from the head, return the first byte,
        // and copy the remaining three bytes into the Reader's payload.
		// Ensure only lowest bits set
		assert [bitwise_ptr].x = [reader.ptr];
		assert [bitwise_ptr].y = 0xFFFFFFFF;
		tempvar reader_tmp = Reader(UINT32, [bitwise_ptr].x_and_y, reader.ptr + 1);
		tempvar bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
	} else {
        // The Reader is not empty. So we read the first byte from its payload
        // and continue with the remaining bytes.
		tempvar reader_tmp = reader;
		tempvar bitwise_ptr = bitwise_ptr;
	}
	let cur = reader_tmp.cur / BYTE;
	assert [bitwise_ptr].x = reader_tmp.buf;
	assert [bitwise_ptr].y = reader_tmp.cur - cur;
	let res = [bitwise_ptr].x_and_y / cur;
	let buf = reader_tmp.buf - [bitwise_ptr].x_and_y;
	let reader = Reader(cur, buf, reader_tmp.ptr);
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
	return res;
}

//  Read 16-bit integer from our usual 32-bit reader
func read_uint16{reader: Reader, bitwise_ptr: BitwiseBuiltin*}() -> felt {
	alloc_locals;
	let uint16_endian = read_uint16_endian();
	let uint16 = byteswap16(uint16_endian);
	return uint16;
}

// Read 32-bit integer from our usual 32-bit reader
func read_uint32{reader: Reader, bitwise_ptr: BitwiseBuiltin*}() -> felt {
	alloc_locals;
	let uint32_endian = read_uint32_endian();
	let uint32 = byteswap32(uint32_endian);
	return uint32;
}

// Read 64-bit integer from our usual 32-bit reader
func read_uint64{reader: Reader, bitwise_ptr: BitwiseBuiltin*}() -> felt {
	alloc_locals;
	let uint32_lo = read_uint32();
	let uint32_hi = read_uint32();
	return uint32_lo + uint32_hi * UINT32;
}

// Read 128-bit integer from our usual 32-bit reader
func read_uint128{reader: Reader, bitwise_ptr: BitwiseBuiltin*}() -> felt {
	alloc_locals;
	let uint64_lo = read_uint64();
	let uint64_hi = read_uint64();
	return uint64_lo + uint64_hi * UINT64;
}

// Read 256-bit integer from our usual 32-bit reader
func read_felt{reader: Reader, bitwise_ptr: BitwiseBuiltin*}() -> felt {
	alloc_locals;
	let uint128_lo = read_uint128();
	let uint128_hi = read_uint128();
	assert_le_felt(0x0400000000000008800000000000000000000000000000000000000000000000);
	return uint128_lo + uint128_hi * UINT128;
}

// Reads a VarInt from the buffer and returns a pair
// of the varint that was read and its byte size.
//
// See also:
// - https://developer.bitcoin.org/reference/transactions.html#compactsize-unsigned-integers
// - https://github.com/bitcoin/bitcoin/blob/9ba73758c908ce0c49f1bd9727ea496958e24d54/src/serialize.h#L275
//
func read_varint{reader: Reader, bitwise_ptr: BitwiseBuiltin*}() -> (value: felt, byte_size: felt) {
    alloc_locals;

    // Read the first byte
    let first_byte = read_uint8();

    // Now check how many more bytes we have to read

    if (first_byte == 0xff) {
        // This varint has 8 more bytes
        let uint32_lo = read_uint32();
        let uint32_hi = read_uint32();
        // Ensure that `uint64 > 0xFFFFFFFF`
        with_attr error_message("Expected canonical encoding") {
			assert_not_zero(uint32_hi);
        }
        return (uint32_lo + uint32_hi * UINT32, UINT8_SIZE + UINT64_SIZE);
    }

    if (first_byte == 0xfe) {
        // This varint has 4 more bytes
        let uint16_lo = read_uint16();
        let uint16_hi = read_uint16();
        // Ensure that `uint32 > 0xFFFF`
		with_attr error_message("Expected canonical encoding") {
			assert_not_zero(uint16_hi);
		}
        return (uint16_lo + uint16_hi * UINT16, UINT8_SIZE + UINT32_SIZE);
    }

    if (first_byte == 0xfd) {
        // This varint has 2 more bytes
        let uint8_lo = read_uint8();
        let uint8_hi = read_uint8();
        // Ensure that `uint16 > 252` which is equivalent to `uint16 + 3 > 255`
		if ((uint8_lo - 253) * (uint8_lo - 254) * (uint8_lo - 255) == 0) {
			with_attr error_message("Expected canonical encoding") {
				assert_not_zero(uint8_hi);
			}
		}
        return (uint8_lo + uint8_hi * BYTE, UINT8_SIZE + UINT16_SIZE);
    }

    // This varint is only 1 byte
    return (first_byte, UINT8_SIZE);
}

func read_uint16_endian{reader: Reader, bitwise_ptr: BitwiseBuiltin*}() -> felt {
	alloc_locals;
	if ((reader.cur - 0x100) * (reader.cur - 1) == 0) {
		// Ensure only lowest bits set
		assert [bitwise_ptr].x = [reader.ptr];
		assert [bitwise_ptr].y = 0xFFFFFFFF;
		let buf = [bitwise_ptr].x_and_y + reader.buf * UINT32;
		let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
		assert [bitwise_ptr].x = buf;
		assert [bitwise_ptr].y = 0xFFFF0000 * reader.cur;
		let uint16_endian = [bitwise_ptr].x_and_y / UINT16 / reader.cur;
		let reader = Reader(reader.cur * UINT16, buf - [bitwise_ptr].x_and_y, reader.ptr + 1);
		let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
		return uint16_endian;
	}
	let cur = reader.cur / UINT16;
	assert [bitwise_ptr].x = reader.buf;
	assert [bitwise_ptr].y = reader.cur - reader.cur / UINT16;
	let uint16_endian = [bitwise_ptr].x_and_y * UINT16 / reader.cur;
	let reader = Reader(reader.cur / UINT16, reader.buf - [bitwise_ptr].x_and_y, reader.ptr);
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
	return uint16_endian;
}

func read_uint32_endian{reader: Reader, bitwise_ptr: BitwiseBuiltin*}() -> felt {
	alloc_locals;
	// Ensure only lowest bits set
	assert [bitwise_ptr].x = [reader.ptr];
	assert [bitwise_ptr].y = 0xFFFFFFFF;
	local buf_64 = reader.buf * UINT32 + [bitwise_ptr].x_and_y;
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
	assert [bitwise_ptr].x = buf_64;
	assert [bitwise_ptr].y = 0xFFFFFFFF * reader.cur;
	let uint32_endian = [bitwise_ptr].x_and_y / reader.cur;
	let reader = Reader(reader.cur, buf_64 - [bitwise_ptr].x_and_y, reader.ptr + 1);
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
    return uint32_endian;
}

func read_uint64_endian{reader: Reader, bitwise_ptr: BitwiseBuiltin*}() -> felt {
    alloc_locals;
    let hi = read_uint32_endian();
    let lo = read_uint32_endian();
    return 2**32 * hi + lo;
}

func read_uint128_endian{reader: Reader, bitwise_ptr: BitwiseBuiltin*}() -> felt {
    alloc_locals;
    let hi = read_uint64_endian();
    let lo = read_uint64_endian();
    return 2**64 * hi + lo;
}

func read_uint256_endian{reader: Reader, bitwise_ptr: BitwiseBuiltin*}() -> Uint256 {
    alloc_locals;
    let hi = read_uint128_endian();
    let lo = read_uint128_endian();
    let uint256 = Uint256(lo, hi);
    return uint256;
}

// Read an array of 32-bit integers from our usual 32-bit reader
func read_bytes{reader: Reader, bitwise_ptr: BitwiseBuiltin*}(size) -> felt* {
	alloc_locals;
	let (ptr) = alloc();
	let writer: Writer = init_writer(ptr);

	assert [bitwise_ptr].x = size;
	assert [bitwise_ptr].y = 0xFFFFFFFC;
	let n_words = [bitwise_ptr].x_and_y / UINT32_SIZE;
	let n_bytes = size - [bitwise_ptr].x_and_y;
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
	
	with writer, reader {
		read_write_words(n_words);
		read_write_bytes(n_bytes);
	}
	
	let buf_endian = byteswap32(writer.buf);
	let writer = Writer(writer.cur, buf_endian, writer.ptr);

	flush_writer(writer);
	return ptr;
}

func read_bytes_endian{reader: Reader, bitwise_ptr: BitwiseBuiltin*}(size) -> felt* {
	alloc_locals;
	let (ptr) = alloc();
	let writer: Writer = init_writer(ptr);

	assert [bitwise_ptr].x = size;
	assert [bitwise_ptr].y = 0xFFFFFFFC;
	let n_words = [bitwise_ptr].x_and_y / UINT32_SIZE;
	let n_bytes = size - [bitwise_ptr].x_and_y;
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;

	with writer, reader {
		read_write_words_endian(n_words);
		read_write_bytes(n_bytes);
	}

	flush_writer(writer);
	return ptr;
}

func read_hash{reader: Reader, bitwise_ptr: BitwiseBuiltin*}() -> felt* {
    return read_bytes_endian(UINT256_SIZE);
}

// Peek the first byte from a reader without increasing the reader's cursor
func peek_uint8{reader: Reader, bitwise_ptr: BitwiseBuiltin*}() -> felt {
	if (reader.cur == 1) {
		assert [bitwise_ptr].x = [reader.ptr];
		assert [bitwise_ptr].y = 0xFF000000;
		let uint8 = [bitwise_ptr].x_and_y / 2 ** 24;
		let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
		return uint8;
	}
	assert [bitwise_ptr].x = reader.buf;
	assert [bitwise_ptr].y = reader.cur - reader.cur / 2 ** 8;
	let uint8 = [bitwise_ptr].x_and_y * 2 ** 8 / reader.cur;
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
	return uint8;
}

// Peek the next two bytes from a reader without increasing the reader's cursor
func peek_uint16{bitwise_ptr: BitwiseBuiltin*}(reader: Reader) -> felt {
    let uint16 = read_uint16{reader = reader}();
    return uint16;
}

struct Writer {
	cur: felt,
	buf: felt,
	ptr: felt*,
}

func init_writer(ptr: felt*) -> Writer {
	let writer = Writer(UINT32, 0, ptr);
	return writer;
}

// Any unwritten data in the writer's temporary memory is written to the writer.
// NOTE: Once you flushed continue writing will cause an error
func flush_writer(writer: Writer) {
	if (writer.cur == UINT32) {
		return ();
	}
	assert [writer.ptr] = writer.buf;
	return ();
}

// Write one byte
func write_uint8{writer: Writer}(byte: felt) {
	alloc_locals;
	local cur: felt;
	local buf: felt;
	local ptr: felt*;
	if (writer.cur == BYTE) {
		assert [writer.ptr] = writer.buf + byte;
		assert cur = UINT32;
		assert buf = 0;
		assert ptr = writer.ptr + 1;
	} else {
		assert cur = writer.cur / BYTE;
		assert buf = writer.buf + byte * cur;
		assert ptr = writer.ptr;
	}
	let writer = Writer(cur, buf, ptr);
	return ();
}

// Write 16-bit integer
func write_uint16{writer: Writer, bitwise_ptr: BitwiseBuiltin*}(value: felt) {
	alloc_locals;
	let value_endian = byteswap16(value);
	write_uint16_endian(value_endian);
	return ();
}

// Write 32-bit integer
func write_uint32{writer: Writer, bitwise_ptr: BitwiseBuiltin*}(value: felt) {
	alloc_locals;
	let value_endian = byteswap32(value);
	write_uint32_endian(value_endian);
	return ();
}

// Write 64-bit integer
func write_uint64{writer: Writer, bitwise_ptr: BitwiseBuiltin*}(value: felt) {
	alloc_locals;
	assert [bitwise_ptr].x = value;
	assert [bitwise_ptr].y = 0xFFFFFFFF;
	let uint32_lo = [bitwise_ptr].x_and_y;
	let uint32_hi = (value - [bitwise_ptr].x_and_y) / UINT32;
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
	write_uint32(uint32_lo);
	write_uint32(uint32_hi);
	return ();
}

// Write a varint into the buffer.
func write_varint{writer: Writer, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(source: felt) {
    alloc_locals;

	assert [bitwise_ptr].x = source;
	assert [bitwise_ptr].y = 0xFF;
	let source_as_uint8 = [bitwise_ptr].x_and_y;
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
    if (source == source_as_uint8) {
		// This varint is only 1 byte.
		write_uint8(source);
        return ();
    }

	assert [bitwise_ptr].x = source;
	assert [bitwise_ptr].y = 0xFFFF;
	let source_as_uint16 = [bitwise_ptr].x_and_y;
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
    if (source == source_as_uint16) {
        // This varint has 2 more bytes after the leading byte.
        write_uint8(0xfd);
        write_uint16(source);
        return ();
    }

	assert [bitwise_ptr].x = source;
	assert [bitwise_ptr].y = 0xFFFFFFFF;
	let source_as_uint32 = [bitwise_ptr].x_and_y;
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
    if (source == source_as_uint32) {
        // This varint has 4 more bytes after the leading byte.
        write_uint8(0xfe);
        write_uint32(source);
        return ();
    }

    // Ensure source is a maximum of 8 bytes.
	with_attr error_message("ERROR: write_varint source exceeded the maximum of 8 bytes.") {
		assert [bitwise_ptr].x = source;
		assert [bitwise_ptr].y = 0xFFFFFFFFFFFFFFFF;
		assert [bitwise_ptr].x_and_y = source;
    }
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;

    // This varint has 8 more bytes after the leading byte.
    write_uint8(0xff);
    write_uint64(source);
    return ();
}

func write_uint16_endian{writer: Writer, bitwise_ptr: BitwiseBuiltin*}(value: felt) {
	alloc_locals;
	if((writer.cur - 0x10000) * (writer.cur - 0x100) == 0) {
		let buf = value + writer.buf * UINT16 / writer.cur;
		assert [bitwise_ptr].x = buf;
		assert [bitwise_ptr].y = 0xFFFFFFFF * UINT16 / writer.cur;
		assert [writer.ptr] = [bitwise_ptr].x_and_y * writer.cur / UINT16;
		let writer = Writer(writer.cur * UINT16, buf - [bitwise_ptr].x_and_y, writer.ptr + 1);
		let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
		return ();
	}	
	let writer = Writer(writer.cur / UINT16, value * writer.cur / UINT16 + writer.buf, writer.ptr);
	return ();
}

func write_uint32_endian{writer: Writer, bitwise_ptr: BitwiseBuiltin*}(source) {
	alloc_locals;
	assert [bitwise_ptr].x = writer.buf * UINT32 / writer.cur + source;
	assert [bitwise_ptr].y = 0xFFFFFFFF * UINT32 / writer.cur;
	assert [writer.ptr] = [bitwise_ptr].x_and_y * writer.cur / UINT32;
	let diff = source - [bitwise_ptr].x_and_y;
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
	let writer = Writer(writer.cur, writer.buf * UINT32 + diff * writer.cur, writer.ptr + 1);
	return ();
}

func write_hash{writer: Writer, bitwise_ptr: BitwiseBuiltin*}(source: felt*) {
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
func byte_size_to_felt_size{bitwise_ptr: BitwiseBuiltin*}(byte_size) -> felt {
    // Compute `unsigned_div_rem(byte_size + 3, 4)` using `BitwiseBuiltin*`
    assert [bitwise_ptr].x = byte_size + (UINT32_SIZE - 1);
    assert [bitwise_ptr].y = 0xFFFFFFFF - (UINT32_SIZE - 1);
	let word_size = [bitwise_ptr].x_and_y / UINT32_SIZE;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
    return word_size;
}

func read_write_words{writer: Writer, reader: Reader, bitwise_ptr: BitwiseBuiltin*}(n_words) {
	if (n_words == 0) {
		return ();
	}
	alloc_locals;
	assert [bitwise_ptr].x = [reader.ptr];
	assert [bitwise_ptr].y = 0xFFFFFFFF;
	local buf_64 = reader.buf * UINT32 + [bitwise_ptr].x_and_y;
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
	assert [bitwise_ptr].x = buf_64;
	assert [bitwise_ptr].y = 0xFFFFFFFF * reader.cur;
	let word_endian = [bitwise_ptr].x_and_y / reader.cur;
	let reader = Reader(reader.cur, buf_64 - [bitwise_ptr].x_and_y, reader.ptr + 1);
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
	let word = byteswap32(word_endian);
	assert [bitwise_ptr].x = writer.buf * UINT32 / writer.cur + word;
	assert [bitwise_ptr].y = 0xFFFFFFFF * UINT32 / writer.cur;
	assert [writer.ptr] = [bitwise_ptr].x_and_y * writer.cur / UINT32;
	let diff = word - [bitwise_ptr].x_and_y;
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
	let writer = Writer(writer.cur, writer.buf * UINT32 + diff * writer.cur, writer.ptr + 1);	
	read_write_words(n_words - 1);
	return ();
}

func read_write_words_endian{writer: Writer, reader: Reader, bitwise_ptr: BitwiseBuiltin*}(n_words) {
	if (n_words == 0) {
		return ();
	}
	alloc_locals;
	assert [bitwise_ptr].x = [reader.ptr];
	assert [bitwise_ptr].y = 0xFFFFFFFF;
	local buf_64 = reader.buf * UINT32 + [bitwise_ptr].x_and_y;
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
	assert [bitwise_ptr].x = buf_64;
	assert [bitwise_ptr].y = 0xFFFFFFFF * reader.cur;
	let word_endian = [bitwise_ptr].x_and_y / reader.cur;
	let reader = Reader(reader.cur, buf_64 - [bitwise_ptr].x_and_y, reader.ptr + 1);
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
	assert [bitwise_ptr].x = writer.buf * UINT32 / writer.cur + word_endian;
	assert [bitwise_ptr].y = 0xFFFFFFFF * UINT32 / writer.cur;
	assert [writer.ptr] = [bitwise_ptr].x_and_y * writer.cur / UINT32;
	let diff = word_endian - [bitwise_ptr].x_and_y;
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
	let writer = Writer(writer.cur, writer.buf * UINT32 + diff * writer.cur, writer.ptr + 1);	
	read_write_words_endian(n_words - 1);
	return ();
}

func read_write_bytes{writer: Writer, reader: Reader, bitwise_ptr: BitwiseBuiltin*}(n_bytes) {
	if (n_bytes == 0) {
		return ();
	}
	alloc_locals;
	if (reader.cur == 1) {
		// Ensure only lowest bits set
		assert [bitwise_ptr].x = [reader.ptr];
		assert [bitwise_ptr].y = 0xFFFFFFFF;
		tempvar reader_tmp = Reader(UINT32, [bitwise_ptr].x_and_y, reader.ptr + 1);
		tempvar bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
	} else {
		tempvar reader_tmp = reader;
		tempvar bitwise_ptr = bitwise_ptr;
	}
	assert [bitwise_ptr].x = reader_tmp.buf;
	assert [bitwise_ptr].y = reader_tmp.cur - reader_tmp.cur / BYTE;
	let byte = [bitwise_ptr].x_and_y / (reader_tmp.cur / BYTE);
	let buf = reader_tmp.buf - [bitwise_ptr].x_and_y;
	let reader = Reader(reader_tmp.cur / BYTE, buf, reader_tmp.ptr);
	let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
	if (writer.cur == BYTE) {
		assert [writer.ptr] = writer.buf + byte;
		tempvar writer = Writer(UINT32, 0, writer.ptr + 1);
	} else {
		tempvar writer = Writer(writer.cur / BYTE, writer.buf + byte * writer.cur / BYTE, writer.ptr);
	}
	read_write_bytes(n_bytes - 1);
	return ();
}
