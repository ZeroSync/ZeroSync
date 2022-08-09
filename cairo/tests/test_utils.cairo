#
# To run only this test suite use:
# protostar test  --cairo-path=./src target tests/*_utils*
#
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256

from src.utils import compute_double_sha256,_compute_double_sha256, to_uint256, array_to_uint256, assert_hashes_equal, write_hashes, HASH_LEN
from src.sha256.sha256 import compute_sha256

@external
func test_compute_sha256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    # Test vectors: https://www.di-mgt.com.au/sha_testvectors.html
    # Test vectors: https://github.com/bitcoin/bitcoin/blob/master/src/test/crypto_tests.cpp

    let input_len = 1

    # Set input to "abc"
    let (input) = alloc()
    assert input[0] = 0x61626300
    let n_bytes = 3
    
    # ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad
    let (hash) = compute_sha256(input_len, input, n_bytes)
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
    let input_len = 1

    # Set input to "abc"
    let (input) = alloc()
    assert input[0] = 0x61626300
    let n_bytes = 3
    
    let (hash) = _compute_double_sha256(input_len, input, n_bytes)
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
func test_compute_double_sha256_uint256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    let input_len = 11

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
    let n_bytes = 43 
    
    let (hash) = compute_double_sha256(input_len, input, n_bytes)
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


@external
func test_write_hashes{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():

    let (leaves) = alloc()
    assert leaves[0] = 0x82501c11
    assert leaves[1] = 0x78fa0b22
    assert leaves[2] = 0x2c1f3d47
    assert leaves[3] = 0x4ec726b8
    assert leaves[4] = 0x32013f0a
    assert leaves[5] = 0x532b44bb
    assert leaves[6] = 0x620cce86
    assert leaves[7] = 0x24a5feb1

    write_hashes(0xb1fea52486ce0c62bb442b530a3f0132,0xb826c74e473d1f2c220bfa78111c5082, leaves, index = 1)
    write_hashes(0xb1fea52486ce0c62bb442b530a3f0132,0xb826c74e473d1f2c220bfa78111c5082, leaves, index = 2)

    assert_hashes_equal(leaves, leaves + HASH_LEN)
    assert_hashes_equal(leaves + HASH_LEN, leaves + HASH_LEN * 2)
    return ()
end