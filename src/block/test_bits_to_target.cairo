// This is a auto generated test
%lang starknet
from block_header import bits_to_target, target_to_bits
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
@external
func test_bits_to_target_small_works1{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    let bits = 0x01003456;
    let expected_target = 0x00;
    let (result) = bits_to_target(bits);
    assert result = expected_target;
    return ();
}

@external
func test_bits_to_target_small_works2{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    let bits = 0x01123456;
    let expected_target = 0x12;
    let (result) = bits_to_target(bits);
    assert result = expected_target;
    return ();
}

@external
func test_bits_to_target_small_works3{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    let bits = 0x02008000;
    let expected_target = 0x80;
    let (result) = bits_to_target(bits);
    assert result = expected_target;
    return ();
}

@external
func test_bits_to_target_small_works4{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    let bits = 0x181bc330;
    let expected_target = 0x1bc330000000000000000000000000000000000000000000;
    let (result) = bits_to_target(bits);
    assert result = expected_target;
    return ();
}

@external
func test_bits_to_target_small_works5{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    let bits = 0x05009234;
    let expected_target = 0x92340000;
    let (result) = bits_to_target(bits);
    assert result = expected_target;
    return ();
}

@external
func test_bits_to_target_small_works6{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    let bits = 0x04123456;
    let expected_target = 0x12345600;
    let (result) = bits_to_target(bits);
    assert result = expected_target;
    return ();
}

@external
func test_bits_to_target_small_works7{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    let bits = 0x1d00ffff;
    let expected_target = 0x00000000ffff0000000000000000000000000000000000000000000000000000;
    let (result) = bits_to_target(bits);
    assert result = expected_target;
    return ();
}

@external
func test_bits_to_target_small_works8{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    let bits = 0x1c0d3142;
    let expected_target = 0x000000000d314200000000000000000000000000000000000000000000000000;
    let (result) = bits_to_target(bits);
    assert result = expected_target;
    return ();
}

@external
func test_bits_to_target_small_works9{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    let bits = 0x1707a429;
    let expected_target = 0x00000000000000000007a4290000000000000000000000000000000000000000;
    let (result) = bits_to_target(bits);
    assert result = expected_target;
    return ();
}

