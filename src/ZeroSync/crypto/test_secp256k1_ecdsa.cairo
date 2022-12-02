%lang starknet

from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from crypto.secp256k1_ecdsa import verify_ecdsa_secp256k1, decode_der_signature
from utils.python_utils import setup_python_defs

@external
func test_ecsda_secp256k1{range_check_ptr}() {
    let point_x = Uint256(0xcfd5e9ad6175dec240d9f76e20b48b41, 0xbff381888b165f92dd33d09ff2cde2d4);
    let point_y = Uint256(0x2e36f7acc2d711d8fb6fbbf53986b57f, 0xe4be2a8547d802dc42041b95be5934e3);
    let r = Uint256(0x770f9700f1ae6c77fee73f3ac9be1217, 0xeee3e6f50c576c07d7e4afc302c486b0);
    let s = Uint256(0xcc3509cf420a4b46d3c5e24cda81f22, 0x541e10c21560da25ada4c259efe25609);
    let msg_hash = Uint256(0xbfc5faa0e178a23ca66202c8c2a72277, 0xca1ad489ab60ea581e6c119cc39d94dd);
    verify_ecdsa_secp256k1(point_x, point_y, msg_hash, r, s);
    return ();
}

// - https://github.com/bitcoin/bitcoin/blob/3ce40e64d4ae9419658555fd1fb250b93f52684a/src/test/data/script_tests.json#L707
// - https://github.com/bitcoin/bitcoin/blob/3ce40e64d4ae9419658555fd1fb250b93f52684a/src/test/data/script_tests.json#L1258
@external
func test_decode_der_signature{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {

    alloc_locals;

    setup_python_defs();

    let (local der_signature: felt*) = alloc();

    %{ from_hex("3044022044dc17b0887c161bb67ba9635bf758735bdde503e4b0a0987f587f14a4e1143d022009a215772d49a85dae40d8ca03955af26ad3978a0ff965faa12915e9586249a501", ids.der_signature) %}

    let (sig_r, sig_s) = decode_der_signature(der_signature);

    assert 0x5bdde503e4b0a0987f587f14a4e1143d = sig_r.low;
    assert 0x44dc17b0887c161bb67ba9635bf75873 = sig_r.high;

    assert 0x6ad3978a0ff965faa12915e9586249a5 = sig_s.low;
    assert 0x09a215772d49a85dae40d8ca03955af2 = sig_s.high;

    return ();
}