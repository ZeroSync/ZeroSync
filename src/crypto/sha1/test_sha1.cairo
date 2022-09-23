#
# To run only this test suite use:
# protostar test --cairo-path=./src target src/**/*_sha1*
#
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from python_utils import setup_python_defs
from crypto.sha1.sha1 import sha1, _sha1

@external
func test_sha1{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    # Test vectors: https://www.di-mgt.com.au/sha_testvectors.html
    # Test vectors: https://github.com/bitcoin/bitcoin/blob/master/src/test/crypto_tests.cpp

    let felt_size = 1

    # Set input to "abc"
    let (input) = alloc()
    assert input[0] = 0x61626300
    let byte_size = 3

    # a9993e364706816aba3e25717850c26c9cd0d89d
    let (hash) = _sha1(felt_size, input, byte_size)
    assert hash[0] = 0xa9993e36
    assert hash[1] = 0x4706816a
    assert hash[2] = 0xba3e2571
    assert hash[3] = 0x7850c26c
    assert hash[4] = 0x9cd0d89d

    return ()
end
