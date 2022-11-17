//
// To run only this test suite use:
// protostar test --cairo-path=./src target src/**/*_hash256*
//
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256
from crypto.sha256 import finalize_sha256

from utils.python_utils import setup_python_defs
from crypto.hash_utils import assert_hashes_equal
from crypto.hash256 import _compute_double_sha256, hash256

@external
func test_compute_double_sha256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    // Set input to "abc"
    let (input) = alloc();
    assert input[0] = 0x61626300;
    let byte_size = 3;

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;
    with sha256_ptr {
        let hash = hash256(input, byte_size);
    }
    // 8cb9012517c817fead650287d61bdd9c68803b6bf9c64133dcab3e65b5a50cb9
    assert hash[0] = 0x4f8b42c2;
    assert hash[1] = 0x2dd3729b;
    assert hash[2] = 0x519ba6f6;
    assert hash[3] = 0x8d2da7cc;
    assert hash[4] = 0x5b2d606d;
    assert hash[5] = 0x05daed5a;
    assert hash[6] = 0xd5128cc0;
    assert hash[7] = 0x3e6c6358;

    // finalize sha256_ptr
    finalize_sha256(sha256_ptr_start, sha256_ptr);

    return ();
}

// Test a double sha256 input with a long byte string
// (We use a 259 bytes transaction here)
//
// See also:
//  - Example transaction: https://blockstream.info/api/tx/b9818f9eb8925f2b5b9aaf3e804306efa1a0682a7173c0b7edb5f2e05cc435bd/hex
@external
func test_hash256_long_input{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    // Use Python to convert hex string into uint32 array
    let (input) = alloc();
    local byte_size;
    let (hash_expected) = alloc();

    setup_python_defs();
    %{
        ids.byte_size, _ = from_hex((
            "0100000001352a68f58c6e69fa632a1bf77566cf83a7515fc9ecd251fa37f410"
            "460d07fb0c010000008c493046022100e30fea4f598a32ea10cd56118552090c"
            "be79f0b1a0c63a4921d2399c9ec14ffc022100ef00f238218864a909db55be9e"
            "2e464ccdd0c42d645957ea80fa92441e90b4c6014104b01cf49815496b5ef83a"
            "bd1a3891996233f0047ada682d56687dd58feb39e969409ce70be398cf73634f"
            "f9d1aae79ac2be2b1348ce622dddb974ad790b4106deffffffff02e093040000"
            "0000001976a914a18cc6dd0e38dea210390a2403622ffc09dae88688ac8152b5"
            "00000000001976a914d73441c86ea086121991877e204516f1861c194188ac00"
            "000000"), ids.input)

        hashes_from_hex([
            "b9818f9eb8925f2b5b9aaf3e804306efa1a0682a7173c0b7edb5f2e05cc435bd"
            ], ids.hash_expected)
    %}

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;
    with sha256_ptr {
        let hash = hash256(input, byte_size);
    }

    assert_hashes_equal(hash_expected, hash);
    // finalize sha256_ptr
    finalize_sha256(sha256_ptr_start, sha256_ptr);
    return ();
}

// Test a double sha256 input with a long byte string
// (We use a 259 bytes transaction here)
//
// See also:
//  - Example transaction: https://blockstream.info/api/tx/b9818f9eb8925f2b5b9aaf3e804306efa1a0682a7173c0b7edb5f2e05cc435bd/hex
@external
func test_hash256_long_input_2{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    // Use Python to convert hex string into uint32 array
    let (input) = alloc();
    local byte_size;
    let (hash_expected) = alloc();

    setup_python_defs();
    %{
        ids.byte_size, _ = from_hex((
            "0100000001000000000000000000000000000000000000000000000000000000"
            "0000000000ffffffff0804ffff001d024f02ffffffff0100f2052a0100000043"
            "41048a5294505f44683bbc2be81e0f6a91ac1a197d6050accac393aad3b86b23"
            "98387e34fedf0de5d9f185eb3f2c17f3564b9170b9c262aa3ac91f371279beca"
            "0cafac00000000"), ids.input)

        hashes_from_hex([
            "a4bc0a85369d04454ec7e006ece017f21549fdfe7df128d61f9f107479bfdf7e"
            ], ids.hash_expected)
    %}

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    let sha256_ptr_start = sha256_ptr;
    with sha256_ptr {
        let hash = hash256(input, 135);
    }

    assert_hashes_equal(hash_expected, hash);
    // finalize sha256_ptr
    finalize_sha256(sha256_ptr_start, sha256_ptr);
    return ();
}
