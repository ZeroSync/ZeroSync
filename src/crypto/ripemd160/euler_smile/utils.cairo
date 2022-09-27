from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.bitwise import bitwise_and, bitwise_or, bitwise_xor
from starkware.cairo.common.math import assert_nn_le, unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from pow2 import pow2

const MAX_32_BIT = 2 ** 32;
const MAX_BYTE = 2 ** 8;

func uint8_div{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x, y) -> (z: felt) {
    let (z, _) = unsigned_div_rem(x, y);
    let (_, z) = unsigned_div_rem(z, MAX_BYTE);
    return (z=z);
}

func uint32_add{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x, y) -> (z: felt) {
    let (_, z) = unsigned_div_rem(x + y, MAX_32_BIT);
    return (z=z);
}

func uint32_mul{range_check_ptr}(x, y) -> (z: felt) {
    let (_, z) = unsigned_div_rem(x * y, MAX_32_BIT);
    return (z=z);
}

func uint32_and{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x, y) -> (z: felt) {
    let (z) = bitwise_and(x, y);
    let (_, z) = unsigned_div_rem(z, MAX_32_BIT);
    return (z=z);
}

func uint32_or{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x, y) -> (z: felt) {
    let (z) = bitwise_or(x, y);
    let (_, z) = unsigned_div_rem(z, MAX_32_BIT);
    return (z=z);
}

func uint32_not{range_check_ptr}(x: felt) -> (not_x: felt) {
    let not_x = MAX_32_BIT - 1 - x;
    let (_, not_x) = unsigned_div_rem(not_x, MAX_32_BIT);
    return (not_x=not_x);
}

func uint32_xor{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x, y) -> (z: felt) {
    let (z) = bitwise_xor(x, y);
    let (_, z) = unsigned_div_rem(z, MAX_32_BIT);
    return (z=z);
}

// collect four bytes into one word.
func BYTES_TO_WORD{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x: felt*) -> (res: felt) {
    let (factor_3) = pow2(24);
    let (factor_2) = pow2(16);
    let (factor_1) = pow2(8);
    let (l1) = uint32_mul([x + 3], factor_3);
    let (l2) = uint32_mul([x + 2], factor_2);
    let (l3) = uint32_mul([x + 1], factor_1);
    let (l1_or_l2) = uint32_or(l1, l2);
    let (l1_or_l2_or_l3) = uint32_or(l1_or_l2, l3);
    let (res) = uint32_or(l1_or_l2_or_l3, [x]);
    return (res=res);
}

// ROL(x, n) cyclically rotates x over n bits to the left
// x must be mod of an unsigned 32 bits type and 0 <= n < 32.
func ROL{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x, n) -> (res: felt) {
    assert_nn_le(x, 2 ** 32 - 1);
    assert_nn_le(n, 31);

    let (factor_n) = pow2(n);
    let (factor_diff) = pow2(32 - n);
    let (x_left_shift) = uint32_mul(x, factor_n);
    let (x_right_shift, _) = unsigned_div_rem(x, factor_diff);
    let (res) = uint32_or(x_left_shift, x_right_shift);
    return (res=res);
}

// the five basic functions F(), G(), H(), I(), J().
func F{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x, y, z) -> (res: felt) {
    let (x_xor_y) = uint32_xor(x, y);
    let (res) = uint32_xor(x_xor_y, z);
    return (res=res);
}

func G{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x, y, z) -> (res: felt) {
    let (x_and_y) = uint32_and(x, y);
    let (not_x) = uint32_not(x);
    let (not_x_and_z) = uint32_and(not_x, z);
    let (res) = uint32_or(x_and_y, not_x_and_z);
    return (res=res);
}

func H{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x, y, z) -> (res: felt) {
    let (not_y) = uint32_not(y);
    let (x_or_not_y) = uint32_or(x, not_y);
    let (res) = uint32_xor(x_or_not_y, z);
    return (res=res);
}

func I{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x, y, z) -> (res: felt) {
    let (x_and_z) = uint32_and(x, z);
    let (not_z) = uint32_not(z);
    let (y_and_not_z) = uint32_and(y, not_z);
    let (res) = uint32_or(x_and_z, y_and_not_z);
    return (res=res);
}

func J{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x, y, z) -> (res: felt) {
    let (not_z) = uint32_not(z);
    let (y_or_not_z) = uint32_or(y, not_z);
    let (res) = uint32_xor(x, y_or_not_z);
    return (res=res);
}

// the ten basic operations FF() through JJJ().
func ROLASE{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a, s, e) -> (res: felt) {
    let (rol_a_s) = ROL(a, s);
    let (res) = uint32_add(rol_a_s, e);
    return (res=res);
}

func FF{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a, b, c, d, e, x, s) -> (
    res1: felt, res2: felt
) {
    let (f_bcd) = F(b, c, d);
    let (a) = uint32_add(a, f_bcd);
    let (a) = uint32_add(a, x);
    let (res1) = ROLASE(a, s, e);
    let (res2) = ROL(c, 10);
    return (res1=res1, res2=res2);
}

func GG{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a, b, c, d, e, x, s) -> (
    res1: felt, res2: felt
) {
    let (g_bcd) = G(b, c, d);
    let (a) = uint32_add(a, g_bcd);
    let (a) = uint32_add(a, x);
    let (a) = uint32_add(a, 0x5a827999);
    let (res1) = ROLASE(a, s, e);
    let (res2) = ROL(c, 10);
    return (res1=res1, res2=res2);
}

func HH{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a, b, c, d, e, x, s) -> (
    res1: felt, res2: felt
) {
    let (h_bcd) = H(b, c, d);
    let (a) = uint32_add(a, h_bcd);
    let (a) = uint32_add(a, x);
    let (a) = uint32_add(a, 0x6ed9eba1);
    let (res1) = ROLASE(a, s, e);
    let (res2) = ROL(c, 10);
    return (res1=res1, res2=res2);
}

func II{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a, b, c, d, e, x, s) -> (
    res1: felt, res2: felt
) {
    let (i_bcd) = I(b, c, d);
    let (a) = uint32_add(a, i_bcd);
    let (a) = uint32_add(a, x);
    let (a) = uint32_add(a, 0x8f1bbcdc);
    let (res1) = ROLASE(a, s, e);
    let (res2) = ROL(c, 10);
    return (res1=res1, res2=res2);
}

func JJ{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a, b, c, d, e, x, s) -> (
    res1: felt, res2: felt
) {
    let (j_bcd) = J(b, c, d);
    let (a) = uint32_add(a, j_bcd);
    let (a) = uint32_add(a, x);
    let (a) = uint32_add(a, 0xa953fd4e);
    let (res1) = ROLASE(a, s, e);
    let (res2) = ROL(c, 10);
    return (res1=res1, res2=res2);
}

func FFF{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a, b, c, d, e, x, s) -> (
    res1: felt, res2: felt
) {
    let (res1, res2) = FF(a, b, c, d, e, x, s);
    return (res1=res1, res2=res2);
}

func GGG{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a, b, c, d, e, x, s) -> (
    res1: felt, res2: felt
) {
    let (g_bcd) = G(b, c, d);
    let (a) = uint32_add(a, g_bcd);
    let (a) = uint32_add(a, x);
    let (a) = uint32_add(a, 0x7a6d76e9);
    let (res1) = ROLASE(a, s, e);
    let (res2) = ROL(c, 10);
    return (res1=res1, res2=res2);
}

func HHH{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a, b, c, d, e, x, s) -> (
    res1: felt, res2: felt
) {
    let (h_bcd) = H(b, c, d);
    let (a) = uint32_add(a, h_bcd);
    let (a) = uint32_add(a, x);
    let (a) = uint32_add(a, 0x6d703ef3);
    let (res1) = ROLASE(a, s, e);
    let (res2) = ROL(c, 10);
    return (res1=res1, res2=res2);
}

func III{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a, b, c, d, e, x, s) -> (
    res1: felt, res2: felt
) {
    let (i_bcd) = I(b, c, d);
    let (a) = uint32_add(a, i_bcd);
    let (a) = uint32_add(a, x);
    let (a) = uint32_add(a, 0x5c4dd124);
    let (res1) = ROLASE(a, s, e);
    let (res2) = ROL(c, 10);
    return (res1=res1, res2=res2);
}

func JJJ{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a, b, c, d, e, x, s) -> (
    res1: felt, res2: felt
) {
    let (j_bcd) = J(b, c, d);
    let (a) = uint32_add(a, j_bcd);
    let (a) = uint32_add(a, x);
    let (a) = uint32_add(a, 0x50a28be6);
    let (res1) = ROLASE(a, s, e);
    let (res2) = ROL(c, 10);
    return (res1=res1, res2=res2);
}
