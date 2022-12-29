from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.common.math import assert_le, assert_not_equal, assert_not_zero, unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memset import memset

from starkware.cairo.common.cairo_secp.signature import get_point_from_x
from starkware.cairo.common.cairo_secp.bigint import BigInt3, uint256_to_bigint
from starkware.cairo.common.cairo_secp.ec import EcPoint, ec_add, ec_mul
from starkware.cairo.common.cairo_secp.signature import (
    validate_signature_entry,
    get_generator_point,
    div_mod_n,
)
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from crypto.hash_utils import copy_hash, HASH_FELT_SIZE
from utils.serialize import Reader, init_reader, read_uint8, read_bytes_endian, peek_uint8, peek_uint16, read_uint256_endian

// Verifies a Secp256k1 ECDSA signature.
// Soundness assumptions:
// * public_key_pt is on the curve.
// * All the limbs of public_key_pt.x, public_key_pt.y, msg_hash are in the range [0, 3 * BASE).
func verify_ecdsa_secp256k1{range_check_ptr}(pt: EcPoint, z: BigInt3, r: BigInt3, s: BigInt3) {
    alloc_locals;

    with_attr error_message("Signature out of range.") {
        validate_signature_entry(r);
        validate_signature_entry(s);
    }
    let (gen_pt: EcPoint) = get_generator_point();
    // Compute u1 and u2.
    let (u1: BigInt3) = div_mod_n(z, s);
    let (u2: BigInt3) = div_mod_n(r, s);
    // The following assert also implies that res is not the zero point.
    with_attr error_message("Invalid signature.") {
        let (gen_u1: EcPoint) = ec_mul(gen_pt, u1);
        let (pub_u2: EcPoint) = ec_mul(pt, u2);
        let (res) = ec_add(gen_u1, pub_u2);
        assert r = res.x;
    }
    return ();
}

func read_bigint{reader: Reader, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() -> BigInt3 {
    alloc_locals;
    let uint256 = read_uint256_endian();
    let (bigint) = uint256_to_bigint(uint256);
    return bigint;
}

// - https://en.bitcoin.it/wiki/Elliptic_Curve_Digital_Signature_Algorithm
func read_public_key{reader: Reader, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(n_bytes) -> EcPoint {
    alloc_locals;
    let prefix = read_uint8();
    if (n_bytes == 0x41) {
        // with explicit y-coord
        with_attr error_message("public_key with 65 bytes need 0x04 prefix") {
            assert 0x04 = prefix;
        }
        let x = read_bigint();
        let y = read_bigint();
        let point = EcPoint(x, y);
        return point;
    }
    // implicit y-coord from sign
    with_attr error_message("sign of elliptic curve y-coord must be 2 or 3") {
        assert (prefix - 0x02) * (prefix - 0x03) = 0;
    }
    with_attr error_message("expected 33 bytes public_key here") {
        assert 0x21 = n_bytes;
    }
    let x = read_bigint();
    let (pt) = get_point_from_x(x, prefix);
    return pt;
}

// - https://github.com/bitcoin/bitcoin/blob/c06cda3e48e9826043ebc5790a7bb505bfbf368c/src/secp256k1/src/ecdsa_impl.h
// - https://github.com/bitcoin-core/secp256k1/blob/1e5d50fa93d71d751b95eec6a80f6732879a0071/src/scalar_8x32_impl.h#L95

// TODO: implement DER encoding for ECDSA signatures
// DER Signatur schwitzt nie.
func read_der_signature{reader: Reader, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() -> (r_sig: BigInt3, s_sig: BigInt3) {
    alloc_locals;

    let byte = read_uint8();
    // The encoding doesn't start with a constructed sequence (X.690-0207 8.9.1).
    assert 0x30 = byte;

    let rlen = secp256k1_der_read_len();

    let r_sig = secp256k1_der_parse_integer(rlen);
    let s_sig = secp256k1_der_parse_integer(rlen);

    return (r_sig, s_sig);

}

// - https://github.com/bitcoin-core/secp256k1/blob/74c34e727bd68d8665e15446e50731006f178aa0/src/ecdsa_impl.h#L49
func secp256k1_der_read_len{reader: Reader, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() -> felt {

    alloc_locals;

    let b1 = read_uint8();
    
    // X.690-0207 8.1.3.5.c the value 0xFF shall not be used.
    assert_not_equal(b1, 0xFF);

    // Indefinite length is not allowed in DER.
    assert_not_equal(b1, 0x80);

    // X.690-0207 8.1.3.4 short form length octets
    assert [bitwise_ptr].x = b1;
    assert [bitwise_ptr].y = 0x80;
    let b1_and_0x80 = [bitwise_ptr].x_and_y;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
    if (b1_and_0x80 == 0x00) {
        return b1;
    }

    // X.690-207 8.1.3.5 long form length octets
    assert [bitwise_ptr].x = b1;
    assert [bitwise_ptr].y = 0x7F;
    // lenleft is at least 1
    let lenleft = [bitwise_ptr].x_and_y;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;

    let byte = peek_uint8();
    // Not the shortest possible length encoding.
    assert_not_zero(byte);

    tempvar len = 0;
    tempvar reader = reader;
    tempvar lenleft = lenleft;
    tempvar bitwise_ptr = bitwise_ptr;
    lenleft_loop:
        let byte = read_uint8();
        tempvar len = len * 256 + byte;
        tempvar reader = reader;
        tempvar lenleft = lenleft - 1;
        tempvar bitwise_ptr = bitwise_ptr;
    jmp lenleft_loop if lenleft != 0;

    // Not the shortest possible length encoding.
    assert_le(128, len);

    return len;
}

// - https://github.com/bitcoin-core/secp256k1/blob/74c34e727bd68d8665e15446e50731006f178aa0/src/ecdsa_impl.h#L102
func secp256k1_der_parse_integer{reader: Reader, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    siglen
) -> BigInt3 {

    alloc_locals;

    assert_not_zero(siglen);

    let sighdr = read_uint8();
    // Not a primitive integer (X.690-0207 8.3.1).
    assert 0x02 = sighdr;

    let rlen = secp256k1_der_read_len();
    
    let byte = peek_uint8();
    
    let uint16 = peek_uint16(reader);

    if (byte == 0x00) {
        // Excessive 0x00 padding.
        assert [bitwise_ptr].x = uint16;
        assert [bitwise_ptr].y = 0xFF80;
        assert 0x0000 = [bitwise_ptr].x_and_y;
        tempvar bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
    } else {
        tempvar bitwise_ptr = bitwise_ptr;
    }
    let bitwise_ptr = bitwise_ptr;

    if (byte == 0xFF) {
        // Excessive 0xFF padding.
        assert [bitwise_ptr].x = uint16;
        assert [bitwise_ptr].y = 0xFF80;
        assert 0xFF80 = [bitwise_ptr].x_and_y;
        tempvar bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;
    } else {
        tempvar bitwise_ptr = bitwise_ptr;
    }
    let bitwise_ptr = bitwise_ptr;

    // Negative.
    assert [bitwise_ptr].x = byte;
    assert [bitwise_ptr].y = 0x80;
    assert 0x00 = [bitwise_ptr].x_and_y;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;

    // There is at most one leading zero byte:
    // if there were two leading zero bytes, we would have failed and returned 0
    // because of excessive 0x00 padding already.
    if (byte == 0) {
        read_uint8();
        // Skip leading zero byte
        let byte = peek_uint8();
        tempvar bitwise_ptr = bitwise_ptr;
        tempvar reader = reader;
        tempvar rlen = rlen - 1;
    } else {
        tempvar bitwise_ptr = bitwise_ptr;
        tempvar reader = reader;
        tempvar rlen = rlen;
    }
    let bitwise_ptr = bitwise_ptr;
    let reader = reader;
    let rlen = rlen;

    // may return zero instead assert
    let is_rlen_le_32 = is_le(rlen, 32);
    if(is_rlen_le_32 == FALSE) {
        let zero: BigInt3 = BigInt3(0, 0, 0);
        return zero; // overflow
    }

    // read_bytes(32 - rlen);
    let scalar_b32: felt* = secp256k1_scalar_set_b32(rlen);

    // Convert felt* to Uint256
    local scalar_uint256: Uint256 = Uint256(
        scalar_b32[0] + 2**32 * scalar_b32[1] + 2**64 * scalar_b32[2] + 2**96 * scalar_b32[3],
        scalar_b32[4] + 2**32 * scalar_b32[5] + 2**64 * scalar_b32[6] + 2**96 * scalar_b32[7]
    );

    const BASE = 2 ** 86; // starkware.cairo.common.cairo_secp.constants
    const RC_BOUND = 2 ** 128; // starkware.cairo.common.math_cmp

    // Converts a Uint256 instance into a BigInt3.
    // Assuming x is a valid Uint256 (its two limbs are below 2 ** 128), the resulting number will have
    //   limbs in the range [0, BASE).
    // x: Uint256
    const D1_HIGH_BOUND = BASE ** 2 / RC_BOUND;
    const D1_LOW_BOUND = RC_BOUND / BASE;
    let (d1_low, d0) = unsigned_div_rem(scalar_uint256.low, BASE);
    let (d2, d1_high) = unsigned_div_rem(scalar_uint256.high, D1_HIGH_BOUND);
    let d1 = d1_high * D1_LOW_BOUND + d1_low;
    let res = BigInt3(d0=d0, d1=d1, d2=d2);

    return res; // scalar_uint256
}

// - https://github.com/bitcoin-core/secp256k1/blob/master/src/scalar_8x32_impl.h#L167
func secp256k1_scalar_set_b32{reader: Reader, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    rlen
) -> felt* {
    alloc_locals;
    let b32: felt* = read_bytes_endian(rlen);
    let (n_words, _) = unsigned_div_rem(rlen + 4 - 1, 4);
    memset(b32 + n_words, 0x00000000, 8 - n_words);
    let (secp256k1_scalar) = alloc();
    assert [secp256k1_scalar + 0] = [b32 + 7];
    assert [secp256k1_scalar + 1] = [b32 + 6];
    assert [secp256k1_scalar + 2] = [b32 + 5];
    assert [secp256k1_scalar + 3] = [b32 + 4];
    assert [secp256k1_scalar + 4] = [b32 + 3];
    assert [secp256k1_scalar + 5] = [b32 + 2];
    assert [secp256k1_scalar + 6] = [b32 + 1];
    assert [secp256k1_scalar + 7] = [b32 + 0];
    let overflow = secp256k1_scalar_check_overflow(secp256k1_scalar);
    let secp256k1_uint256 = secp256k1_scalar_reduce(secp256k1_scalar, overflow);
    return secp256k1_uint256;
}

// Limbs of the secp256k1 order.
const SECP256K1_N_0 = 0xD0364141;
const SECP256K1_N_1 = 0xBFD25E8C;
const SECP256K1_N_2 = 0xAF48A03B;
const SECP256K1_N_3 = 0xBAAEDCE6;
const SECP256K1_N_4 = 0xFFFFFFFE;
const SECP256K1_N_5 = 0xFFFFFFFF;
const SECP256K1_N_6 = 0xFFFFFFFF;
const SECP256K1_N_7 = 0xFFFFFFFF;


// - https://github.com/bitcoin-core/secp256k1/blob/master/src/scalar_8x32_impl.h#L77
func secp256k1_scalar_check_overflow{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    secp256k1_scalar: felt*
) -> felt {
    let lt_7 = is_le([secp256k1_scalar + 7], SECP256K1_N_7 + 1);
    let lt_6 = is_le([secp256k1_scalar + 6], SECP256K1_N_6 + 1);
    let lt_5 = is_le([secp256k1_scalar + 5], SECP256K1_N_5 + 1);
    let lt_4 = is_le([secp256k1_scalar + 4], SECP256K1_N_4 + 1);
    if (lt_7 + lt_6 + lt_5 + lt_4 == FALSE) {
        tempvar no = FALSE;
    } else {
        tempvar no = TRUE;
    }
    let gt_4 = is_le(SECP256K1_N_4, [secp256k1_scalar + 4] + 1);
    let yes = gt_4 * (TRUE - no);
    let lt_3 = is_le([secp256k1_scalar + 3], SECP256K1_N_3 + 1);
    if (no + lt_3 * (TRUE - yes) == FALSE) {
        tempvar no = FALSE;
    } else {
        tempvar no = TRUE;
    }
    let gt_3 = is_le(SECP256K1_N_3, [secp256k1_scalar + 3] + 1);
    if (yes + gt_3 * (TRUE - no) == FALSE) {
        tempvar yes = FALSE;
    } else {
        tempvar yes = TRUE;
    }
    let lt_2 = is_le([secp256k1_scalar + 2], SECP256K1_N_2 + 1);
    if (no + lt_2 * (TRUE - yes) == FALSE) {
        tempvar no = FALSE;
    } else {
        tempvar no = TRUE;
    }
    let gt_2 = is_le(SECP256K1_N_2, [secp256k1_scalar + 2] + 1);
    if (yes + gt_2 * (TRUE - no) == FALSE) {
        tempvar yes = FALSE;
    } else {
        tempvar yes = TRUE;
    }
    let lt_1 = is_le([secp256k1_scalar + 1], SECP256K1_N_1 + 1);
    if (no + lt_1 * (TRUE - yes) == FALSE) {
        tempvar no = FALSE;
    } else {
        tempvar no = TRUE;
    }
    let gt_1 = is_le(SECP256K1_N_1, [secp256k1_scalar + 1] + 1);
    if (yes + gt_1 * (TRUE - no) == FALSE) {
        tempvar yes = FALSE;
    } else {
        tempvar yes = TRUE;
    }
    let le_0 = is_le(SECP256K1_N_0, [secp256k1_scalar + 0]);
    if (yes + le_0 * (TRUE - no) == FALSE) {
        return FALSE;
    } else {
        return TRUE;
    }
}

// Limbs of 2^256 minus the secp256k1 order.
const SECP256K1_N_C_0 = 0xFFFFFFFF - SECP256K1_N_0 + 1;
const SECP256K1_N_C_1 = 0xFFFFFFFF - SECP256K1_N_1;
const SECP256K1_N_C_2 = 0xFFFFFFFF - SECP256K1_N_2;
const SECP256K1_N_C_3 = 0xFFFFFFFF - SECP256K1_N_3;
const SECP256K1_N_C_4 = 1;

// - https://github.com/bitcoin-core/secp256k1/blob/master/src/scalar_8x32_impl.h#L95
func secp256k1_scalar_reduce{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    secp256k1_in: felt*, overflow
) -> felt* {
    assert_le(overflow, 1);



    let (secp256k1_out) = alloc();
    assert bitwise_ptr[0].x = secp256k1_in[0] + overflow * SECP256K1_N_C_0;
    assert bitwise_ptr[0].y = 0xFFFFFFFF;
    assert bitwise_ptr[1].x = bitwise_ptr[0].x_and_y * 0x100000000 + secp256k1_in[1] + overflow * SECP256K1_N_C_1;
    assert bitwise_ptr[1].y = 0xFFFFFFFF;
    assert bitwise_ptr[2].x = bitwise_ptr[1].x_and_y * 0x100000000 + secp256k1_in[2] + overflow * SECP256K1_N_C_2;
    assert bitwise_ptr[2].y = 0xFFFFFFFF;
    assert bitwise_ptr[3].x = bitwise_ptr[2].x_and_y * 0x100000000 + secp256k1_in[3] + overflow * SECP256K1_N_C_3;
    assert bitwise_ptr[3].y = 0xFFFFFFFF;
    assert bitwise_ptr[4].x = bitwise_ptr[3].x_and_y * 0x100000000 + secp256k1_in[4] + overflow * SECP256K1_N_C_4;
    assert bitwise_ptr[4].y = 0xFFFFFFFF;
    assert bitwise_ptr[5].x = bitwise_ptr[4].x_and_y * 0x100000000 + secp256k1_in[5];
    assert bitwise_ptr[5].y = 0xFFFFFFFF;
    assert bitwise_ptr[6].x = bitwise_ptr[5].x_and_y * 0x100000000 + secp256k1_in[6];
    assert bitwise_ptr[6].y = 0xFFFFFFFF;
    assert bitwise_ptr[7].x = bitwise_ptr[6].x_and_y * 0x100000000 + secp256k1_in[7];
    assert bitwise_ptr[7].y = 0xFFFFFFFF;
    assert [secp256k1_out + 0] = bitwise_ptr[0].x_and_y;
    assert [secp256k1_out + 1] = bitwise_ptr[1].x_and_y;
    assert [secp256k1_out + 2] = bitwise_ptr[2].x_and_y;
    assert [secp256k1_out + 3] = bitwise_ptr[3].x_and_y;
    assert [secp256k1_out + 4] = bitwise_ptr[4].x_and_y;
    assert [secp256k1_out + 5] = bitwise_ptr[5].x_and_y;
    assert [secp256k1_out + 6] = bitwise_ptr[6].x_and_y;
    assert [secp256k1_out + 7] = bitwise_ptr[7].x_and_y;
    let bitwise_ptr = bitwise_ptr + 8 * BitwiseBuiltin.SIZE;
    return secp256k1_out;
}