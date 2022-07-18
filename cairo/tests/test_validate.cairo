%lang starknet

from starkware.cairo.common.alloc import alloc

from src.validate import assertHashesEqual

@external
func test_assertHashesEqual():
    let (hash_a) = alloc()
    let (hash_b) = alloc()

    assert hash_a[0] = 0x00
    assert hash_a[1] = 0x01
    assert hash_a[2] = 0x02
    assert hash_a[3] = 0x03
    assert hash_a[4] = 0x04
    assert hash_a[5] = 0x05
    assert hash_a[6] = 0x06
    assert hash_a[7] = 0x07

    assert hash_b[0] = 0x01
    assert hash_b[1] = 0x01
    assert hash_b[2] = 0x02
    assert hash_b[3] = 0x03
    assert hash_b[4] = 0x04
    assert hash_b[5] = 0x05
    assert hash_b[6] = 0x06
    assert hash_b[7] = 0x07
    %{ expect_revert() %}
    assertHashesEqual(hash_a, hash_b)
    return ()
end
