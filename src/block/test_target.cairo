%lang starknet

from block_header import bits_to_target, target_to_bits

@external
func test_bits_to_target_works1{range_check_ptr}() {
    let bits = 0x181bc330;
    let expected_target = 0x1bc330000000000000000000000000000000000000000000;
    let (result) = bits_to_target(bits);
    assert result  = expected_target;
    return ();
}

@external
func test_bits_to_target_works2{range_check_ptr}() {
    let bits = 0x05009234;
    let expected_target = 0x92340000;
    let (result) = bits_to_target(bits);
    assert result  = expected_target;
    return ();
}

@external
func test_bits_to_target_works3{range_check_ptr}() {
    let bits = 0x04123456;
    let expected_target = 0x12345600;
    let (result) = bits_to_target(bits);
    assert result  = expected_target;
    return ();
}

@external
func test_bits_to_target_works_with_negative{range_check_ptr}() {
    let bits = 0x04923456;
    let expected_target = -0x12345600;
    let (result) = bits_to_target(bits);
    assert result  = expected_target;
    return ();
}
