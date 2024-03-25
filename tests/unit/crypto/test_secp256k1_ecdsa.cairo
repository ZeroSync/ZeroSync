//
// To run only this test suite use:
// protostar test --cairo-path=./src target tests/unit/crypto/*_secp256k1_ecdsa*
// 

%lang starknet

from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_secp.bigint import BigInt3, uint256_to_bigint, bigint_to_uint256
from starkware.cairo.common.cairo_secp.ec import EcPoint

from crypto.secp256k1_ecdsa import verify_ecdsa_secp256k1, read_public_key, read_der_signature

from utils.python_utils import setup_python_defs

from utils.serialize import Reader, init_reader

@external
func test_ecsda_secp256k1{range_check_ptr}() {

    let (x_as_bigint3) = uint256_to_bigint(Uint256(0xcfd5e9ad6175dec240d9f76e20b48b41, 0xbff381888b165f92dd33d09ff2cde2d4));
    let (y_as_bigint3) = uint256_to_bigint(Uint256(0x2e36f7acc2d711d8fb6fbbf53986b57f, 0xe4be2a8547d802dc42041b95be5934e3));

    let pt = EcPoint(x_as_bigint3, y_as_bigint3);

    let (r) = uint256_to_bigint( Uint256(0x770f9700f1ae6c77fee73f3ac9be1217, 0xeee3e6f50c576c07d7e4afc302c486b0) );
    let (s) = uint256_to_bigint( Uint256(0xcc3509cf420a4b46d3c5e24cda81f22, 0x541e10c21560da25ada4c259efe25609) );
    let (z) = uint256_to_bigint( Uint256(0xbfc5faa0e178a23ca66202c8c2a72277, 0xca1ad489ab60ea581e6c119cc39d94dd) );
    verify_ecdsa_secp256k1(pt, z, r, s);
    return ();
}

@external
func test_read_public_key{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    
    alloc_locals;

    setup_python_defs();

    let (local public_key: felt*) = alloc();

    %{ from_hex("0479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8", ids.public_key) %}

    let reader = init_reader(public_key);

    with reader {
        let pt = read_public_key(0x41);
    }

    let (local x_as_uint256) = bigint_to_uint256(pt.x);
    let (local y_as_uint256) = bigint_to_uint256(pt.y);

    assert 0x79be667ef9dcbbac55a06295ce870b07 = x_as_uint256.high;
    assert 0x483ada7726a3c4655da4fbfc0e1108a8 = y_as_uint256.high;
    assert 0x029bfcdb2dce28d959f2815b16f81798 = x_as_uint256.low;
    assert 0xfd17b448a68554199c47d08ffb10d4b8 = y_as_uint256.low;

    return ();
}

// - https://github.com/bitcoin/bitcoin/blob/3ce40e64d4ae9419658555fd1fb250b93f52684a/src/test/data/script_tests.json#L707
// - https://github.com/bitcoin/bitcoin/blob/3ce40e64d4ae9419658555fd1fb250b93f52684a/src/test/data/script_tests.json#L1258
@external
func test_read_der_signature{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {

    alloc_locals;

    setup_python_defs();

    let (local der_signature: felt*) = alloc();

    %{ from_hex("3044022044dc17b0887c161bb67ba9635bf758735bdde503e4b0a0987f587f14a4e1143d022009a215772d49a85dae40d8ca03955af26ad3978a0ff965faa12915e9586249a501", ids.der_signature) %}

    let reader = init_reader(der_signature);

    with reader {
        let (sig_r, sig_s) = read_der_signature();
    }

    let (r) = uint256_to_bigint( Uint256(0x5bdde503e4b0a0987f587f14a4e1143d,
                                         0x44dc17b0887c161bb67ba9635bf75873) );
    assert r.d0 = sig_r.d0;
    assert r.d1 = sig_r.d1;
    assert r.d2 = sig_r.d2;
    
    let (s) = uint256_to_bigint( Uint256(0x6ad3978a0ff965faa12915e9586249a5,
                                         0x09a215772d49a85dae40d8ca03955af2) );
    assert s.d0 = sig_s.d0;
    assert s.d1 = sig_s.d1;
    assert s.d2 = sig_s.d2;

    return ();
}


@external
func test_read_00_padding_der_signature{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {

    alloc_locals;

    setup_python_defs();

    let (local der_signature: felt*) = alloc();

    %{ from_hex("3044022100b961b021dae244cee853f6facf07a78331f974eb75854c57415750594379f8a9021f2ba06a8262d4b6875fbaa74a4179fd7cdfacd4274d657c870177db6e9fe425", ids.der_signature) %}

    let reader = init_reader(der_signature);

    with reader {
        let (sig_r, sig_s) = read_der_signature();
    }

    let (r) = uint256_to_bigint( Uint256(0x31f974eb75854c57415750594379f8a9,
                                         0xb961b021dae244cee853f6facf07a783) );
    assert r.d0 = sig_r.d0;
    assert r.d1 = sig_r.d1;
    assert r.d2 = sig_r.d2;

    let (s) = uint256_to_bigint( Uint256(0x7cdfacd4274d657c870177db6e9fe425,
                                         0x2ba06a8262d4b6875fbaa74a4179fd) );
    assert s.d0 = sig_s.d0;
    assert s.d1 = sig_s.d1;
    assert s.d2 = sig_s.d2;

    return ();
}
