#
# To run only this test suite use:
# protostar test --cairo-path=./src target src/**/*_sha256*
#
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256

from tests.utils_for_testing import setup_python_defs
from crypto.sha256.sha256 import sha256, _sha256
from crypto.sha256d.sha256d import assert_hashes_equal

@external
func test_sha256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    # Test vectors: https://www.di-mgt.com.au/sha_testvectors.html
    # Test vectors: https://github.com/bitcoin/bitcoin/blob/master/src/test/crypto_tests.cpp

    let felt_size = 1

    # Set input to "abc"
    let (input) = alloc()
    assert input[0] = 0x61626300
    let byte_size = 3
    
    # ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad
    let (hash) = _sha256(felt_size, input, byte_size)
    assert hash[0] = 0xba7816bf
    assert hash[1] = 0x8f01cfea
    assert hash[2] = 0x414140de
    assert hash[3] = 0x5dae2223
    assert hash[4] = 0xb00361a3
    assert hash[5] = 0x96177a9c
    assert hash[6] = 0xb410ff61
    assert hash[7] = 0xf20015ad
    
    return () 
end


# Test a double sha256 input with a long byte string 
# (We use a 259 bytes transaction here)
#
# See also:
#  - Example Transaction: https://blockstream.info/api/tx/b9818f9eb8925f2b5b9aaf3e804306efa1a0682a7173c0b7edb5f2e05cc435bd/hex 
@external
func test_sha256_long_input{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals

    # Use Python to convert hex string into uint32 array
    let (input) = alloc()
    local byte_size
    let (hash_expected) = alloc()

    setup_python_defs()
   %{
    (ids.byte_size, _) = from_hex((
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

    let (hash) = sha256(input, byte_size)

    # assert_hashes_equal(hash_expected, hash)
    return () 
end

@external
func test_sha256_dummy{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    setup_python_defs()
    let (input) = alloc()
    let (expected_output) = alloc()
    local n_bytes : felt
    local input_len : felt

    %{
        test_string = "Hello world"
        import hashlib
        ids.n_bytes, ids.input_len = from_string(test_string, ids.input)
        # Compute expected hash from the python hashlib library.
        expected_hash = hashlib.sha256(test_string.encode("ascii")).hexdigest()
        from_hex(expected_hash, ids.expected_output)
    %}

    let (output) = _sha256(input_len, input, n_bytes)
    assert_hashes_equal(output, expected_output)
    return ()
end


# The bug in the cartridge_gg implementation
@external
func test_sha256_64_bytes{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    setup_python_defs()
    let (input) = alloc()
    let (expected_output) = alloc()
    local n_bytes : felt
    local input_len : felt

    %{
        test_string = "0000111122223333444455556666777788889999aaaabbbbccccddddeeeeffff"
        import hashlib
        ids.n_bytes, ids.input_len = from_string(test_string, ids.input)
        # Compute expected hash from the python hashlib library.
        expected_hash = hashlib.sha256(test_string.encode("ascii")).hexdigest()
        from_hex(expected_hash, ids.expected_output)
    %}

    let (output) = _sha256(input_len, input, n_bytes)
    assert_hashes_equal(output, expected_output)
    return ()
end