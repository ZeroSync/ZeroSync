#
# To run only this test suite use:
# protostar test  --cairo-path=./src target tests/*_utils*
#
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256

from tests.utils_for_testing import setup_python_defs
from src.utils import compute_double_sha256, _compute_double_sha256, __compute_double_sha256, to_uint256, array_to_uint256, assert_hashes_equal, HASH_FELT_SIZE
from src.sha256.sha256 import compute_sha256

@external
func test_compute_sha256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    # Test vectors: https://www.di-mgt.com.au/sha_testvectors.html
    # Test vectors: https://github.com/bitcoin/bitcoin/blob/master/src/test/crypto_tests.cpp

    let felt_size = 1

    # Set input to "abc"
    let (input) = alloc()
    assert input[0] = 0x61626300
    let byte_size = 3
    
    # ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad
    let (hash) = compute_sha256(felt_size, input, byte_size)
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


@external
func test_compute_double_sha256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    let felt_size = 1

    # Set input to "abc"
    let (input) = alloc()
    assert input[0] = 0x61626300
    let byte_size = 3
    
    let (hash) = _compute_double_sha256(felt_size, input, byte_size)
    # 8cb9012517c817fead650287d61bdd9c68803b6bf9c64133dcab3e65b5a50cb9
    assert hash[0] = 0x4f8b42c2
    assert hash[1] = 0x2dd3729b
    assert hash[2] = 0x519ba6f6
    assert hash[3] = 0x8d2da7cc
    assert hash[4] = 0x5b2d606d
    assert hash[5] = 0x05daed5a
    assert hash[6] = 0xd5128cc0
    assert hash[7] = 0x3e6c6358

    return () 
end

@external
func test__compute_double_sha256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    # Set input to a long byte string
    let (input) = alloc()

    # Use Python to convert hex string into uint32 array
    setup_python_defs()
   %{
    from_hex((
        "0100000001352a68f58c6e69fa632a1bf77566cf83a7515fc9ecd251fa37f410"
        "460d07fb0c010000008c493046022100e30fea4f598a32ea10cd56118552090c"
        "be79f0b1a0c63a4921d2399c9ec14ffc022100ef00f238218864a909db55be9e"
        "2e464ccdd0c42d645957ea80fa92441e90b4c6014104b01cf49815496b5ef83a"
        "bd1a3891996233f0047ada682d56687dd58feb39e969409ce70be398cf73634f"
        "f9d1aae79ac2be2b1348ce622dddb974ad790b4106deffffffff02e093040000"
        "0000001976a914a18cc6dd0e38dea210390a2403622ffc09dae88688ac8152b5"
        "00000000001976a914d73441c86ea086121991877e204516f1861c194188ac00"
        "000000"), ids.input)
    %}
    let byte_size = 259

    # TODO: FIXME
    # let (hash) = __compute_double_sha256(input, byte_size)

    return () 
end

@external
func test_compute_double_sha256_uint256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    let felt_size = 11

    # Set input to "The quick brown fox jumps over the lazy dog"
    let (input) = alloc()
    assert input[0]  = 0x54686520
    assert input[1]  = 0x71756963
    assert input[2]  = 0x6b206272
    assert input[3]  = 0x6f776e20
    assert input[4]  = 0x666f7820
    assert input[5]  = 0x6a756d70
    assert input[6]  = 0x73206f76
    assert input[7]  = 0x65722074
    assert input[8]  = 0x6865206c
    assert input[9]  = 0x617a7920
    assert input[10] = 0x646f6700
    let byte_size = 43 
    
    let (hash) = compute_double_sha256(felt_size, input, byte_size)
    assert hash.low  = 0x6d37795021e544d82b41850edf7aabab
    assert hash.high = 0x9a0ebe274e54a519840c4666f35b3937
    return () 
end

@external
func test_array_to_uint256{range_check_ptr}():
    let (input) = alloc()
    # 4f8b42c22dd3729b519ba6f68d2da7cc5b2d606d05daed5ad5128cc03e6c6358
    # hash_from_hex(0x4f8b42c22dd3729b519ba6f68d2da, 0x7cc5b2d606d05daed5ad5128cc03e6c6358)
    assert input[0] = 0x4f8b42c2
    assert input[1] = 0x2dd3729b
    assert input[2] = 0x519ba6f6
    assert input[3] = 0x8d2da7cc
    assert input[4] = 0x5b2d606d
    assert input[5] = 0x05daed5a
    assert input[6] = 0xd5128cc0
    assert input[7] = 0x3e6c6358

    let (output) = array_to_uint256(input)
    assert output.low  = 0x4f8b42c22dd3729b519ba6f68d2da7cc
    assert output.high = 0x5b2d606d05daed5ad5128cc03e6c6358
    return ()
end


@external
func test_to_uint256{range_check_ptr}():
    let input = 2 ** 251 - 1
    let (output) = to_uint256(input)
    assert output.low = 0xffffffffffffffffffffffffffffffff
    assert output.high = 0x7ffffffffffffffffffffffffffffff
    return ()
end
