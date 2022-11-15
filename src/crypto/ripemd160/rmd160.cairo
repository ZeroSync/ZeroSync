//
// RIPEMD160 implementation as specified at https://homes.esat.kuleuven.be/~bosselae/ripemd160.html
//

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.memcpy import memcpy

from utils.pow2 import pow2
from crypto.ripemd160.utils import (
    MAX_32_BIT,
    FF,
    GG,
    HH,
    II,
    JJ,
    FFF,
    GGG,
    HHH,
    III,
    JJJ,
    uint32_add,
    change_uint32_byte_order_array,
)

const RMD160_INPUT_CHUNK_SIZE_FELTS = 16;
const RMD160_INPUT_CHUNK_SIZE_BYTES = 64;
const RMD160_STATE_SIZE_FELTS = 5;

//
// Computes RMD160 of 'data'. Inputs of arbitrary length are supported.
// To use this function, split the input into words of 32 bits (big endian).
// For example, to compute RMD160('Hello world'), use:
//   input = [1214606444, 1864398703, 1919706112]
// where:
//   1214606444 == int.from_bytes(b'Hell', 'big')
//   1864398703 == int.from_bytes(b'o wo', 'big')
//   1919706112 == int.from_bytes(b'rld\x00', 'big')  # Note the '\x00' pad_input.
//
// chunk layout:
// 0 - 15: Message
// 16 - 20: Input State
// 21 - 25: Output
// Note: This layout is kept in case we want to rewrite to use the sha256 approach.
//
// Output is an array of 5 32-bit words (big endian).
func compute_rmd160{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, rmd160_ptr: felt*}(
    data: felt*, n_bytes: felt, n_felts: felt
) -> felt* {
    alloc_locals;

    // Pad the input data
    let (padded_data: felt*, chunks) = pad_input(data, n_bytes, n_felts);

    // Prepare the first chunk.
    // Copy first chunk's input data.
    memcpy(rmd160_ptr, padded_data, RMD160_INPUT_CHUNK_SIZE_FELTS);
    // Set the initial input state.
    assert [rmd160_ptr + 16] = 0x67452301;
    assert [rmd160_ptr + 17] = 0xefcdab89;
    assert [rmd160_ptr + 18] = 0x98badcfe;
    assert [rmd160_ptr + 19] = 0x10325476;
    assert [rmd160_ptr + 20] = 0xc3d2e1f0;

    rmd160_inner(padded_data, 0, chunks);

    // Change byte order.
    // NOTE: Depending on the use case we might not need to change byte order here.
    let (output: felt*) = alloc();
    change_uint32_byte_order_array(rmd160_ptr, rmd160_ptr + RMD160_STATE_SIZE_FELTS, output);
    // Set `rmd160_ptr` to the next chunk.
    let rmd160_ptr = rmd160_ptr + RMD160_STATE_SIZE_FELTS;
    return output;
}

// Inner loop for rmd160. `rmd160_ptr` points to the start of the block.
func rmd160_inner{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, rmd160_ptr: felt*}(
    data: felt*, n_chunks, total_chunks
) {
    alloc_locals;

    let message = rmd160_ptr;
    let state = rmd160_ptr + RMD160_INPUT_CHUNK_SIZE_FELTS;
    let output = state + RMD160_STATE_SIZE_FELTS;

    // Fills the output part of the chunk layout.
    rmd160_compress(message, state, output);

    if (n_chunks + 1 == total_chunks) {
        // Let rmd160_ptr point to the beginning of the output.
        let rmd160_ptr = output;
        return ();
    }

    // Prepare the next chunk.
    let rmd160_ptr = output + RMD160_STATE_SIZE_FELTS;
    // Copy respective felts of data to next chunk's Message.
    memcpy(
        rmd160_ptr,
        data + (n_chunks + 1) * RMD160_INPUT_CHUNK_SIZE_FELTS,
        RMD160_INPUT_CHUNK_SIZE_FELTS,
    );
    // Copy current output state to next chunk's input state.
    memcpy(rmd160_ptr + RMD160_INPUT_CHUNK_SIZE_FELTS, output, RMD160_STATE_SIZE_FELTS);

    // Call rmd160_inner on the next chunk.
    rmd160_inner{rmd160_ptr=rmd160_ptr}(data, n_chunks + 1, total_chunks);
    return ();
}

// Appends the pad_input '1' bit to the last word of the input and
// adds the resulting word to 'input_ptr'.
// 'n_bytes' is the number of bytes stored in last_word (so it is in the interval [1,4]).
// Returns the number of felts that were appended to 'input_ptr.' - 1.
func append_one_bit{input_ptr: felt*}(last_word, n_bytes) -> felt {
    if (n_bytes == 4) {
        // The current last_word is already full.
        assert input_ptr[0] = last_word;
        assert input_ptr[1] = 0x80000000;
        let input_ptr = input_ptr + 2;
        return 1;
    }

    // Calculate the felt representation of the '1' bit depending on 'n_bytes' stored in 'last_word'.
    let one_bit = pow2(8 * (4 - n_bytes) - 1);
    // Add the pad_input '1' bit to the last word.
    assert [input_ptr] = last_word + one_bit;
    let input_ptr = input_ptr + 1;
    return 0;
}

// Appends 'n' zeroes to 'input_ptr'.
func append_zeroes{input_ptr: felt*}(n) {
    if (n == 0) {
        return ();
    }

    assert input_ptr[0] = 0;
    let input_ptr = input_ptr + 1;
    append_zeroes{input_ptr=input_ptr}(n - 1);
    return ();
}

// Padding of the input array.
//
// 'input' is a word array consisting of n_felts words that contain a total of n_bytes bytes.
func pad_input{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(input: felt*, n_bytes, n_felts) -> (
    word_array: felt*, n_chunks: felt
) {
    alloc_locals;
    let (local input_ptr: felt*) = alloc();
    let input_ptr_start = input_ptr;
    let n_chunks = _pad_input{input_ptr=input_ptr}(input, n_bytes, n_felts);

    // Switch byte order of each word.
    let (padded_input: felt*) = alloc();
    change_uint32_byte_order_array(input_ptr_start, input_ptr, padded_input);

    // Append input length.
    // This should be the same as (https://homes.esat.kuleuven.be/~bosselae/ripemd160/ps/AB-9601/rmd160.c)
    // X[14] = lswlen << 3;
    // X[15] = (lswlen >> 29) | (mswlen << 3);
    let (mswlen, lswlen) = unsigned_div_rem(n_bytes, MAX_32_BIT);
    let (_, lswlen_sll_3) = unsigned_div_rem(lswlen * 2 ** 3, MAX_32_BIT);
    let (_, mswlen_sll_3) = unsigned_div_rem(mswlen * 2 ** 3, MAX_32_BIT);
    let (lswlen_srl_29, _) = unsigned_div_rem(n_bytes, 2 ** 29);
    assert padded_input[n_chunks * RMD160_INPUT_CHUNK_SIZE_FELTS - 2] = lswlen_sll_3;
    assert padded_input[n_chunks * RMD160_INPUT_CHUNK_SIZE_FELTS - 1] = mswlen_sll_3 + lswlen_srl_29;
    return (padded_input, n_chunks);
}

func _pad_input{range_check_ptr, input_ptr: felt*}(input: felt*, n_bytes, n_felts) -> felt {
    alloc_locals;
    // Check if input is empty.
    if (n_felts == 0) {
        // This block is entirely empty and only contains the padding '1' bit.
        assert input_ptr[0] = 0x80000000;
        let input_ptr = input_ptr + 1;
        append_zeroes{input_ptr=input_ptr}(13);
        return 1;
    }

    let last_message_block = is_le(n_bytes, 55);
    if (last_message_block == 1) {
        // The rest of the input data is less than a message block (remaining input is < 448 bits)

        memcpy(input_ptr, input, n_felts - 1);
        // Padding '1'-bit fits into the current block (current mesage block is < 448)
        let input_ptr = input_ptr + n_felts - 1;
        let appended_felts = append_one_bit{input_ptr=input_ptr}(
            input[n_felts - 1], n_bytes - ((n_felts - 1) * 4)
        );
        // Find out how many zeroes have to be appended and append them.
        append_zeroes{input_ptr=input_ptr}(14 - (n_felts + appended_felts));
        return 1;
    }

    let last_data_message_block = is_le(n_bytes, 63);
    if (last_data_message_block == 1) {
        // The rest of the input data is 448 or more but less than 512 bits.
        memcpy(input_ptr, input, n_felts - 1);
        let input_ptr = input_ptr + n_felts - 1;
        let appended_felts = append_one_bit{input_ptr=input_ptr}(
            input[n_felts - 1], n_bytes - ((n_felts - 1) * 4)
        );

        // '1' bit had to be in this message block and the current and next message block are padded with 0
        append_zeroes{input_ptr=input_ptr}(16 - (n_felts + appended_felts));
        append_zeroes{input_ptr=input_ptr}(14);
        return 2;
    }

    // Rest of input is bigger than a message block (remaining input is > 512)
    // completely fill the current message block
    memcpy(input_ptr, input, 16);
    let input_ptr = input_ptr + 16;
    let n_chunks = _pad_input{input_ptr=input_ptr}(input + 16, n_bytes - (4 * 16), n_felts - 16);
    return n_chunks + 1;
}

// The compression function.
// Writes the result into 'output'.
func rmd160_compress{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}(
    data: felt*, state: felt*, output: felt*
) {
    alloc_locals;

    // all element is in [0, 2^32).
    let (_, aa) = unsigned_div_rem([state + 0], MAX_32_BIT);
    let (_, bb) = unsigned_div_rem([state + 1], MAX_32_BIT);
    let (_, cc) = unsigned_div_rem([state + 2], MAX_32_BIT);
    let (_, dd) = unsigned_div_rem([state + 3], MAX_32_BIT);
    let (_, ee) = unsigned_div_rem([state + 4], MAX_32_BIT);
    local aaa = aa;
    local bbb = bb;
    local ccc = cc;
    local ddd = dd;
    local eee = ee;

    // round 1
    let (local aa, local cc) = FF(aa, bb, cc, dd, ee, [data + 0], 11);
    let (local ee, local bb) = FF(ee, aa, bb, cc, dd, [data + 1], 14);
    let (local dd, local aa) = FF(dd, ee, aa, bb, cc, [data + 2], 15);
    let (local cc, local ee) = FF(cc, dd, ee, aa, bb, [data + 3], 12);
    let (local bb, local dd) = FF(bb, cc, dd, ee, aa, [data + 4], 5);
    let (local aa, local cc) = FF(aa, bb, cc, dd, ee, [data + 5], 8);
    let (local ee, local bb) = FF(ee, aa, bb, cc, dd, [data + 6], 7);
    let (local dd, local aa) = FF(dd, ee, aa, bb, cc, [data + 7], 9);
    let (local cc, local ee) = FF(cc, dd, ee, aa, bb, [data + 8], 11);
    let (local bb, local dd) = FF(bb, cc, dd, ee, aa, [data + 9], 13);
    let (local aa, local cc) = FF(aa, bb, cc, dd, ee, [data + 10], 14);
    let (local ee, local bb) = FF(ee, aa, bb, cc, dd, [data + 11], 15);
    let (local dd, local aa) = FF(dd, ee, aa, bb, cc, [data + 12], 6);
    let (local cc, local ee) = FF(cc, dd, ee, aa, bb, [data + 13], 7);
    let (local bb, local dd) = FF(bb, cc, dd, ee, aa, [data + 14], 9);
    let (local aa, local cc) = FF(aa, bb, cc, dd, ee, [data + 15], 8);

    // round 2
    let (local ee, local bb) = GG(ee, aa, bb, cc, dd, [data + 7], 7);
    let (local dd, local aa) = GG(dd, ee, aa, bb, cc, [data + 4], 6);
    let (local cc, local ee) = GG(cc, dd, ee, aa, bb, [data + 13], 8);
    let (local bb, local dd) = GG(bb, cc, dd, ee, aa, [data + 1], 13);
    let (local aa, local cc) = GG(aa, bb, cc, dd, ee, [data + 10], 11);
    let (local ee, local bb) = GG(ee, aa, bb, cc, dd, [data + 6], 9);
    let (local dd, local aa) = GG(dd, ee, aa, bb, cc, [data + 15], 7);
    let (local cc, local ee) = GG(cc, dd, ee, aa, bb, [data + 3], 15);
    let (local bb, local dd) = GG(bb, cc, dd, ee, aa, [data + 12], 7);
    let (local aa, local cc) = GG(aa, bb, cc, dd, ee, [data + 0], 12);
    let (local ee, local bb) = GG(ee, aa, bb, cc, dd, [data + 9], 15);
    let (local dd, local aa) = GG(dd, ee, aa, bb, cc, [data + 5], 9);
    let (local cc, local ee) = GG(cc, dd, ee, aa, bb, [data + 2], 11);
    let (local bb, local dd) = GG(bb, cc, dd, ee, aa, [data + 14], 7);
    let (local aa, local cc) = GG(aa, bb, cc, dd, ee, [data + 11], 13);
    let (local ee, local bb) = GG(ee, aa, bb, cc, dd, [data + 8], 12);

    // round 3
    let (local dd, local aa) = HH(dd, ee, aa, bb, cc, [data + 3], 11);
    let (local cc, local ee) = HH(cc, dd, ee, aa, bb, [data + 10], 13);
    let (local bb, local dd) = HH(bb, cc, dd, ee, aa, [data + 14], 6);
    let (local aa, local cc) = HH(aa, bb, cc, dd, ee, [data + 4], 7);
    let (local ee, local bb) = HH(ee, aa, bb, cc, dd, [data + 9], 14);
    let (local dd, local aa) = HH(dd, ee, aa, bb, cc, [data + 15], 9);
    let (local cc, local ee) = HH(cc, dd, ee, aa, bb, [data + 8], 13);
    let (local bb, local dd) = HH(bb, cc, dd, ee, aa, [data + 1], 15);
    let (local aa, local cc) = HH(aa, bb, cc, dd, ee, [data + 2], 14);
    let (local ee, local bb) = HH(ee, aa, bb, cc, dd, [data + 7], 8);
    let (local dd, local aa) = HH(dd, ee, aa, bb, cc, [data + 0], 13);
    let (local cc, local ee) = HH(cc, dd, ee, aa, bb, [data + 6], 6);
    let (local bb, local dd) = HH(bb, cc, dd, ee, aa, [data + 13], 5);
    let (local aa, local cc) = HH(aa, bb, cc, dd, ee, [data + 11], 12);
    let (local ee, local bb) = HH(ee, aa, bb, cc, dd, [data + 5], 7);
    let (local dd, local aa) = HH(dd, ee, aa, bb, cc, [data + 12], 5);

    // round 4
    let (local cc, local ee) = II(cc, dd, ee, aa, bb, [data + 1], 11);
    let (local bb, local dd) = II(bb, cc, dd, ee, aa, [data + 9], 12);
    let (local aa, local cc) = II(aa, bb, cc, dd, ee, [data + 11], 14);
    let (local ee, local bb) = II(ee, aa, bb, cc, dd, [data + 10], 15);
    let (local dd, local aa) = II(dd, ee, aa, bb, cc, [data + 0], 14);
    let (local cc, local ee) = II(cc, dd, ee, aa, bb, [data + 8], 15);
    let (local bb, local dd) = II(bb, cc, dd, ee, aa, [data + 12], 9);
    let (local aa, local cc) = II(aa, bb, cc, dd, ee, [data + 4], 8);
    let (local ee, local bb) = II(ee, aa, bb, cc, dd, [data + 13], 9);
    let (local dd, local aa) = II(dd, ee, aa, bb, cc, [data + 3], 14);
    let (local cc, local ee) = II(cc, dd, ee, aa, bb, [data + 7], 5);
    let (local bb, local dd) = II(bb, cc, dd, ee, aa, [data + 15], 6);
    let (local aa, local cc) = II(aa, bb, cc, dd, ee, [data + 14], 8);
    let (local ee, local bb) = II(ee, aa, bb, cc, dd, [data + 5], 6);
    let (local dd, local aa) = II(dd, ee, aa, bb, cc, [data + 6], 5);
    let (local cc, local ee) = II(cc, dd, ee, aa, bb, [data + 2], 12);

    // round 5
    let (local bb, local dd) = JJ(bb, cc, dd, ee, aa, [data + 4], 9);
    let (local aa, local cc) = JJ(aa, bb, cc, dd, ee, [data + 0], 15);
    let (local ee, local bb) = JJ(ee, aa, bb, cc, dd, [data + 5], 5);
    let (local dd, local aa) = JJ(dd, ee, aa, bb, cc, [data + 9], 11);
    let (local cc, local ee) = JJ(cc, dd, ee, aa, bb, [data + 7], 6);
    let (local bb, local dd) = JJ(bb, cc, dd, ee, aa, [data + 12], 8);
    let (local aa, local cc) = JJ(aa, bb, cc, dd, ee, [data + 2], 13);
    let (local ee, local bb) = JJ(ee, aa, bb, cc, dd, [data + 10], 12);
    let (local dd, local aa) = JJ(dd, ee, aa, bb, cc, [data + 14], 5);
    let (local cc, local ee) = JJ(cc, dd, ee, aa, bb, [data + 1], 12);
    let (local bb, local dd) = JJ(bb, cc, dd, ee, aa, [data + 3], 13);
    let (local aa, local cc) = JJ(aa, bb, cc, dd, ee, [data + 8], 14);
    let (local ee, local bb) = JJ(ee, aa, bb, cc, dd, [data + 11], 11);
    let (local dd, local aa) = JJ(dd, ee, aa, bb, cc, [data + 6], 8);
    let (local cc, local ee) = JJ(cc, dd, ee, aa, bb, [data + 15], 5);
    let (local bb, local dd) = JJ(bb, cc, dd, ee, aa, [data + 13], 6);

    // parallel round 1
    let (local aaa, local ccc) = JJJ(aaa, bbb, ccc, ddd, eee, [data + 5], 8);
    let (local eee, local bbb) = JJJ(eee, aaa, bbb, ccc, ddd, [data + 14], 9);
    let (local ddd, local aaa) = JJJ(ddd, eee, aaa, bbb, ccc, [data + 7], 9);
    let (local ccc, local eee) = JJJ(ccc, ddd, eee, aaa, bbb, [data + 0], 11);
    let (local bbb, local ddd) = JJJ(bbb, ccc, ddd, eee, aaa, [data + 9], 13);
    let (local aaa, local ccc) = JJJ(aaa, bbb, ccc, ddd, eee, [data + 2], 15);
    let (local eee, local bbb) = JJJ(eee, aaa, bbb, ccc, ddd, [data + 11], 15);
    let (local ddd, local aaa) = JJJ(ddd, eee, aaa, bbb, ccc, [data + 4], 5);
    let (local ccc, local eee) = JJJ(ccc, ddd, eee, aaa, bbb, [data + 13], 7);
    let (local bbb, local ddd) = JJJ(bbb, ccc, ddd, eee, aaa, [data + 6], 7);
    let (local aaa, local ccc) = JJJ(aaa, bbb, ccc, ddd, eee, [data + 15], 8);
    let (local eee, local bbb) = JJJ(eee, aaa, bbb, ccc, ddd, [data + 8], 11);
    let (local ddd, local aaa) = JJJ(ddd, eee, aaa, bbb, ccc, [data + 1], 14);
    let (local ccc, local eee) = JJJ(ccc, ddd, eee, aaa, bbb, [data + 10], 14);
    let (local bbb, local ddd) = JJJ(bbb, ccc, ddd, eee, aaa, [data + 3], 12);
    let (local aaa, local ccc) = JJJ(aaa, bbb, ccc, ddd, eee, [data + 12], 6);

    // parallel round 2
    let (local eee, local bbb) = III(eee, aaa, bbb, ccc, ddd, [data + 6], 9);
    let (local ddd, local aaa) = III(ddd, eee, aaa, bbb, ccc, [data + 11], 13);
    let (local ccc, local eee) = III(ccc, ddd, eee, aaa, bbb, [data + 3], 15);
    let (local bbb, local ddd) = III(bbb, ccc, ddd, eee, aaa, [data + 7], 7);
    let (local aaa, local ccc) = III(aaa, bbb, ccc, ddd, eee, [data + 0], 12);
    let (local eee, local bbb) = III(eee, aaa, bbb, ccc, ddd, [data + 13], 8);
    let (local ddd, local aaa) = III(ddd, eee, aaa, bbb, ccc, [data + 5], 9);
    let (local ccc, local eee) = III(ccc, ddd, eee, aaa, bbb, [data + 10], 11);
    let (local bbb, local ddd) = III(bbb, ccc, ddd, eee, aaa, [data + 14], 7);
    let (local aaa, local ccc) = III(aaa, bbb, ccc, ddd, eee, [data + 15], 7);
    let (local eee, local bbb) = III(eee, aaa, bbb, ccc, ddd, [data + 8], 12);
    let (local ddd, local aaa) = III(ddd, eee, aaa, bbb, ccc, [data + 12], 7);
    let (local ccc, local eee) = III(ccc, ddd, eee, aaa, bbb, [data + 4], 6);
    let (local bbb, local ddd) = III(bbb, ccc, ddd, eee, aaa, [data + 9], 15);
    let (local aaa, local ccc) = III(aaa, bbb, ccc, ddd, eee, [data + 1], 13);
    let (local eee, local bbb) = III(eee, aaa, bbb, ccc, ddd, [data + 2], 11);

    // parallel round 3
    let (local ddd, local aaa) = HHH(ddd, eee, aaa, bbb, ccc, [data + 15], 9);
    let (local ccc, local eee) = HHH(ccc, ddd, eee, aaa, bbb, [data + 5], 7);
    let (local bbb, local ddd) = HHH(bbb, ccc, ddd, eee, aaa, [data + 1], 15);
    let (local aaa, local ccc) = HHH(aaa, bbb, ccc, ddd, eee, [data + 3], 11);
    let (local eee, local bbb) = HHH(eee, aaa, bbb, ccc, ddd, [data + 7], 8);
    let (local ddd, local aaa) = HHH(ddd, eee, aaa, bbb, ccc, [data + 14], 6);
    let (local ccc, local eee) = HHH(ccc, ddd, eee, aaa, bbb, [data + 6], 6);
    let (local bbb, local ddd) = HHH(bbb, ccc, ddd, eee, aaa, [data + 9], 14);
    let (local aaa, local ccc) = HHH(aaa, bbb, ccc, ddd, eee, [data + 11], 12);
    let (local eee, local bbb) = HHH(eee, aaa, bbb, ccc, ddd, [data + 8], 13);
    let (local ddd, local aaa) = HHH(ddd, eee, aaa, bbb, ccc, [data + 12], 5);
    let (local ccc, local eee) = HHH(ccc, ddd, eee, aaa, bbb, [data + 2], 14);
    let (local bbb, local ddd) = HHH(bbb, ccc, ddd, eee, aaa, [data + 10], 13);
    let (local aaa, local ccc) = HHH(aaa, bbb, ccc, ddd, eee, [data + 0], 13);
    let (local eee, local bbb) = HHH(eee, aaa, bbb, ccc, ddd, [data + 4], 7);
    let (local ddd, local aaa) = HHH(ddd, eee, aaa, bbb, ccc, [data + 13], 5);

    // parallel round 4
    let (local ccc, local eee) = GGG(ccc, ddd, eee, aaa, bbb, [data + 8], 15);
    let (local bbb, local ddd) = GGG(bbb, ccc, ddd, eee, aaa, [data + 6], 5);
    let (local aaa, local ccc) = GGG(aaa, bbb, ccc, ddd, eee, [data + 4], 8);
    let (local eee, local bbb) = GGG(eee, aaa, bbb, ccc, ddd, [data + 1], 11);
    let (local ddd, local aaa) = GGG(ddd, eee, aaa, bbb, ccc, [data + 3], 14);
    let (local ccc, local eee) = GGG(ccc, ddd, eee, aaa, bbb, [data + 11], 14);
    let (local bbb, local ddd) = GGG(bbb, ccc, ddd, eee, aaa, [data + 15], 6);
    let (local aaa, local ccc) = GGG(aaa, bbb, ccc, ddd, eee, [data + 0], 14);
    let (local eee, local bbb) = GGG(eee, aaa, bbb, ccc, ddd, [data + 5], 6);
    let (local ddd, local aaa) = GGG(ddd, eee, aaa, bbb, ccc, [data + 12], 9);
    let (local ccc, local eee) = GGG(ccc, ddd, eee, aaa, bbb, [data + 2], 12);
    let (local bbb, local ddd) = GGG(bbb, ccc, ddd, eee, aaa, [data + 13], 9);
    let (local aaa, local ccc) = GGG(aaa, bbb, ccc, ddd, eee, [data + 9], 12);
    let (local eee, local bbb) = GGG(eee, aaa, bbb, ccc, ddd, [data + 7], 5);
    let (local ddd, local aaa) = GGG(ddd, eee, aaa, bbb, ccc, [data + 10], 15);
    let (local ccc, local eee) = GGG(ccc, ddd, eee, aaa, bbb, [data + 14], 8);

    // parallel round 5
    let (local bbb, local ddd) = FFF(bbb, ccc, ddd, eee, aaa, [data + 12], 8);
    let (local aaa, local ccc) = FFF(aaa, bbb, ccc, ddd, eee, [data + 15], 5);
    let (local eee, local bbb) = FFF(eee, aaa, bbb, ccc, ddd, [data + 10], 12);
    let (local ddd, local aaa) = FFF(ddd, eee, aaa, bbb, ccc, [data + 4], 9);
    let (local ccc, local eee) = FFF(ccc, ddd, eee, aaa, bbb, [data + 1], 12);
    let (local bbb, local ddd) = FFF(bbb, ccc, ddd, eee, aaa, [data + 5], 5);
    let (local aaa, local ccc) = FFF(aaa, bbb, ccc, ddd, eee, [data + 8], 14);
    let (local eee, local bbb) = FFF(eee, aaa, bbb, ccc, ddd, [data + 7], 6);
    let (local ddd, local aaa) = FFF(ddd, eee, aaa, bbb, ccc, [data + 6], 8);
    let (local ccc, local eee) = FFF(ccc, ddd, eee, aaa, bbb, [data + 2], 13);
    let (local bbb, local ddd) = FFF(bbb, ccc, ddd, eee, aaa, [data + 13], 6);
    let (local aaa, local ccc) = FFF(aaa, bbb, ccc, ddd, eee, [data + 14], 5);
    let (local eee, local bbb) = FFF(eee, aaa, bbb, ccc, ddd, [data + 0], 15);
    let (local ddd, local aaa) = FFF(ddd, eee, aaa, bbb, ccc, [data + 3], 13);
    let (local ccc, local eee) = FFF(ccc, ddd, eee, aaa, bbb, [data + 9], 11);
    let (local bbb, local ddd) = FFF(bbb, ccc, ddd, eee, aaa, [data + 11], 11);

    // combine results
    let (local res: felt*) = alloc();

    let res0 = uint32_add([state + 1], cc);
    let res0 = uint32_add(res0, ddd);

    let res1 = uint32_add([state + 2], dd);
    let res1 = uint32_add(res1, eee);

    let res2 = uint32_add([state + 3], ee);
    let res2 = uint32_add(res2, aaa);

    let res3 = uint32_add([state + 4], aa);
    let res3 = uint32_add(res3, bbb);

    let res4 = uint32_add([state + 0], bb);
    let res4 = uint32_add(res4, ccc);

    assert output[0] = res0;
    assert output[1] = res1;
    assert output[2] = res2;
    assert output[3] = res3;
    assert output[4] = res4;

    return ();
}
