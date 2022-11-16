from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.memset import memset
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_nn
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.registers import get_fp_and_pc
from utils.pow2 import pow2

// byte size
const SIZEOF_UINT32 = 4;
const SIZEOF_UINT64 = 8;
// mask
const UINT32_MASK = 0xFFFFFFFF;
const UINT64_MASK = 0xFFFFFFFFFFFFFFFF;
// shift
const BYTE = 2 ** 8;
const WORD = 2 ** 32;

func min{range_check_ptr}(a, b) -> felt {
    if (is_nn(b - a) == TRUE) {
        return a;
    } else {
        return b;
    }
}

const BYTES_PER_INPUT = 64;
const WORDS_PER_INPUT = 16;
const WORDS_PER_CHUNK = 80;
// most significant bit
const WORDS_MSB = 0x80000000;

func __prepare_chunk{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    chunk_ptr: felt*, data_ptr: felt*, n_bytes, n_words
) {
    if (n_words == 0) {
        return ();
    }
    alloc_locals;
    if (n_bytes == 0) {
        assert [chunk_ptr] = WORDS_MSB;
        memset(chunk_ptr + 1, 0, n_words - 1);
        return ();
    }
    let le_3_bytes = is_nn(SIZEOF_UINT32 - 1 - n_bytes);
    if (le_3_bytes == TRUE) {
        let max_4 = min(n_bytes, SIZEOF_UINT32);
        let max_pow_256_4 = pow2(8 * max_4);
        assert [bitwise_ptr].x = [data_ptr];
        assert [bitwise_ptr].y = (max_pow_256_4 - 1) * WORD / max_pow_256_4;
        let uint32 = [bitwise_ptr].x_and_y;
        let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
        assert [bitwise_ptr].x = uint32;
        assert [bitwise_ptr].y = WORDS_MSB / max_pow_256_4;
        assert [chunk_ptr] = [bitwise_ptr].x_or_y;
        let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
        memset(chunk_ptr + 1, 0, n_words - 1);
        return ();
    }
    assert [bitwise_ptr].x = [data_ptr];
    assert [bitwise_ptr].y = UINT32_MASK;
    assert [chunk_ptr] = [bitwise_ptr].x_and_y;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
    return __prepare_chunk(chunk_ptr + 1, data_ptr + 1, n_bytes - SIZEOF_UINT32, n_words - 1);
}

// n_words max 16
// n_bytes max 64
func sha1_prepare_chunk{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    chunk_ptr: felt*, data_ptr: felt*, n_words, n_bytes, n_bits
) -> felt* {
    alloc_locals;
    let le_14_words = is_nn(WORDS_PER_INPUT - SIZEOF_UINT64 / SIZEOF_UINT32 - n_words);
    if (le_14_words == TRUE) {
        // copy max 56 bytes
        // concat zero bytes
        __prepare_chunk(
            chunk_ptr, data_ptr, n_bytes, WORDS_PER_INPUT - SIZEOF_UINT64 / SIZEOF_UINT32
        );
        // concat bit length
        // NOTE: We limit the bit length to 32 bits here
        assert [chunk_ptr + WORDS_PER_INPUT - SIZEOF_UINT64 / SIZEOF_UINT32 + 0] = 0;
        assert [chunk_ptr + WORDS_PER_INPUT - SIZEOF_UINT64 / SIZEOF_UINT32 + 1] = n_bits;
        return chunk_ptr;
    }
    // copy max 56 bytes
    // append zero bytes
    __prepare_chunk(chunk_ptr, data_ptr, n_bytes, WORDS_PER_INPUT);
    return chunk_ptr;
}

func sha1_message_schedule{bitwise_ptr: BitwiseBuiltin*}(chunk_ptr: felt*) {
    alloc_locals;
    tempvar bitwise_ptr = bitwise_ptr;
    tempvar chunk_ptr = chunk_ptr + WORDS_PER_INPUT;
    tempvar n_words = WORDS_PER_CHUNK - WORDS_PER_INPUT;

    message_schedule_loop:
    // extend the sixteen 32-bit words into eighty 32-bit words
    // Note 3: SHA-0 differs by not having this leftrotate.
    assert bitwise_ptr[0].x = [chunk_ptr - 3];
    assert bitwise_ptr[0].y = [chunk_ptr - 8];
    assert bitwise_ptr[1].x = [chunk_ptr - 14];
    assert bitwise_ptr[1].y = [chunk_ptr - 16];
    assert bitwise_ptr[2].x = bitwise_ptr[0].x_xor_y;
    assert bitwise_ptr[2].y = bitwise_ptr[1].x_xor_y;
    assert bitwise_ptr[3].x = bitwise_ptr[2].x_xor_y + bitwise_ptr[2].x_xor_y * WORD;
    assert bitwise_ptr[3].y = 0x7FFFFFFF80000000;
    let xor_lrot_1 = bitwise_ptr[3].x_and_y / 2 ** 31;
    assert [chunk_ptr] = xor_lrot_1;
    tempvar bitwise_ptr = bitwise_ptr + 4 * BitwiseBuiltin.SIZE;
    tempvar chunk_ptr = chunk_ptr + 1;
    tempvar n_words = n_words - 1;
    jmp message_schedule_loop if n_words != 0;
    return ();
}

func __message_compress{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    a, b, c, d, e, chunk_ptr: felt*, n_words_rem
) -> (felt, felt, felt, felt, felt) {
    if (n_words_rem == 0) {
        return (a, b, c, d, e);
    }
    alloc_locals;
    // compute f and k
    let n = WORDS_PER_CHUNK - n_words_rem;
    let (q, _) = unsigned_div_rem(n, 20);
    // 0 <= n <= 19  <=>  q = 0
    // 20 <= n <= 39  <=>  q = 1
    // 40 <= n <= 59  <=>  q = 2
    // 60 <= n <= 79  <=>  q = 3
    let (__fp__, _) = get_fp_and_pc();
    local k_0 = 0x5a827999;
    local k_1 = 0x6ed9eba1;
    local k_2 = 0x8f1bbcdc;
    local k_3 = 0xca62c1d6;
    let k = [&k_0 + q];
    if (q == 0) {
        // f = (b and c) or ((not b) and d)
        assert bitwise_ptr[0].x = b;
        assert bitwise_ptr[0].y = c;
        assert bitwise_ptr[1].x = UINT64_MASK - b;
        assert bitwise_ptr[1].y = d;
        assert bitwise_ptr[2].x = bitwise_ptr[0].x_and_y;
        assert bitwise_ptr[2].y = bitwise_ptr[1].x_and_y;
        tempvar f = bitwise_ptr[2].x_or_y;
        tempvar n_bitwise_op = 3;
    } else {
        if (q == 2) {
            // f = (b and c) or (b and d) or (c and d)
            assert bitwise_ptr[0].x = b;
            assert bitwise_ptr[0].y = c;
            assert bitwise_ptr[1].x = b;
            assert bitwise_ptr[1].y = d;
            assert bitwise_ptr[2].x = c;
            assert bitwise_ptr[2].y = d;
            assert bitwise_ptr[3].x = bitwise_ptr[0].x_and_y;
            assert bitwise_ptr[3].y = bitwise_ptr[1].x_and_y;
            assert bitwise_ptr[4].x = bitwise_ptr[2].x_and_y;
            assert bitwise_ptr[4].y = bitwise_ptr[3].x_or_y;
            tempvar f = bitwise_ptr[4].x_or_y;
            tempvar n_bitwise_op = 5;
        } else {
            // q == 1 or q == 3
            // f = b xor c xor d
            assert bitwise_ptr[0].x = b;
            assert bitwise_ptr[0].y = c;
            assert bitwise_ptr[1].x = bitwise_ptr[0].x_xor_y;
            assert bitwise_ptr[1].y = d;
            tempvar f = bitwise_ptr[1].x_xor_y;
            tempvar n_bitwise_op = 2;
        }
    }
    let bitwise_ptr = bitwise_ptr + n_bitwise_op * BitwiseBuiltin.SIZE;
    let f = f;
    // a b c d e
    assert bitwise_ptr[0].x = a + a * 2 ** 32;
    assert bitwise_ptr[0].y = 0x07FFFFFFF8000000;
    assert bitwise_ptr[1].x = b + b * 2 ** 32;
    assert bitwise_ptr[1].y = 0x00000003FFFFFFFC;
    let a_lrot_5 = bitwise_ptr[0].x_and_y / 2 ** 27;
    let b_lrot_30 = bitwise_ptr[1].x_and_y / 2 ** 2;
    let bitwise_ptr = bitwise_ptr + 2 * BitwiseBuiltin.SIZE;
    // temp = (a << 5 | a >> 27) + f + e + k + w[i]
    let (temp) = bitwise_and(a_lrot_5 + f + e + k + [chunk_ptr], UINT32_MASK);
    // (a, b, c, d, e) <- (temp, a, (b << 30 | b >> 2), c, d)
    return __message_compress(temp, a, b_lrot_30, c, d, chunk_ptr + 1, n_words_rem - 1);
}

func __sha1{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    h_0,
    h_1,
    h_2,
    h_3,
    h_4,
    n_chunks,
    chunk_ptr: felt*,
    data_ptr: felt*,
    n_words_rem,
    n_bytes_rem,
    n_bits,
) -> felt {
    if (n_chunks == 0) {
        return h_0 * 2 ** 128 + h_1 * 2 ** 96 + h_2 * 2 ** 64 + h_3 * 2 ** 32 + h_4;
    }
    alloc_locals;
    let n_words_max_16 = min(n_words_rem, WORDS_PER_INPUT);
    let n_bytes_max_64 = min(n_bytes_rem, BYTES_PER_INPUT);
    let chunk_ptr = sha1_prepare_chunk(chunk_ptr, data_ptr, n_words_max_16, n_bytes_max_64, n_bits);
    sha1_message_schedule(chunk_ptr);
    // message compress
    let (a, b, c, d, e) = __message_compress(h_0, h_1, h_2, h_3, h_4, chunk_ptr, WORDS_PER_CHUNK);
    // accumulate hash += a b c d e
    assert bitwise_ptr[0].x = h_0 + a;
    assert bitwise_ptr[0].y = UINT32_MASK;
    assert bitwise_ptr[1].x = h_1 + b;
    assert bitwise_ptr[1].y = UINT32_MASK;
    assert bitwise_ptr[2].x = h_2 + c;
    assert bitwise_ptr[2].y = UINT32_MASK;
    assert bitwise_ptr[3].x = h_3 + d;
    assert bitwise_ptr[3].y = UINT32_MASK;
    assert bitwise_ptr[4].x = h_4 + e;
    assert bitwise_ptr[4].y = UINT32_MASK;
    let h_0 = bitwise_ptr[0].x_and_y;
    let h_1 = bitwise_ptr[1].x_and_y;
    let h_2 = bitwise_ptr[2].x_and_y;
    let h_3 = bitwise_ptr[3].x_and_y;
    let h_4 = bitwise_ptr[4].x_and_y;
    let bitwise_ptr = bitwise_ptr + 5 * BitwiseBuiltin.SIZE;
    let n_chunks = n_chunks - 1;
    let chunk_ptr = chunk_ptr + WORDS_PER_CHUNK;
    let data_ptr = data_ptr + n_words_max_16;
    let n_words_rem = n_words_rem - n_words_max_16;
    let n_byte_rem = n_bytes_rem - n_bytes_max_64;
    return __sha1(
        h_0, h_1, h_2, h_3, h_4, n_chunks, chunk_ptr, data_ptr, n_words_rem, n_bytes_rem, n_bits
    );
}

func sha1{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(data_ptr: felt*, n_bytes) -> felt {
    alloc_locals;
    let (chunk_ptr) = alloc();
    let (n_words, _) = unsigned_div_rem(n_bytes + SIZEOF_UINT32 - 1, SIZEOF_UINT32);
    let (n_chunks, _) = unsigned_div_rem(
        n_words + WORDS_PER_INPUT - 1 + SIZEOF_UINT64 / SIZEOF_UINT32, WORDS_PER_INPUT
    );
    return __sha1(
        0x67452301,
        0xEFCDAB89,
        0x98BADCFE,
        0x10325476,
        0xC3D2E1F0,
        n_chunks,
        chunk_ptr,
        data_ptr,
        n_words,
        n_bytes,
        8 * n_bytes,
    );
}
