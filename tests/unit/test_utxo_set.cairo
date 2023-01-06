//
// To run only this test suite use:
// protostar test --cairo-path=./src target tests/unit/*_utxo_set*
//
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from utils.python_utils import setup_python_defs

from utxo_set.utreexo import utreexo_init
from utxo_set.utxo_set import utxo_set_insert, utxo_set_extract
from tests.unit.block.utxo_dummies.utils import reset_bridge_node

// https://blockstream.info/tx/a4bc0a85369d04454ec7e006ece017f21549fdfe7df128d61f9f107479bfdf7e
@external
func test_utxo_set{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, pedersen_ptr: HashBuiltin*}() {
    alloc_locals;
    setup_python_defs();
    reset_bridge_node();
    let utreexo_roots = utreexo_init();

    let (txid) = alloc();
    %{
        hashes_from_hex([
            "a4bc0a85369d04454ec7e006ece017f21549fdfe7df128d61f9f107479bfdf7e"
        ], ids.txid)
    %}
    let vout = 0;
    let amount = 50 * 10 ** 8;  // 50 BTC
    let (script_pub_key) = alloc();
    local script_pub_key_size;
    %{
        byte_size, _ = from_hex(
            "41048a5294505f44683bbc2be81e0f6a91ac1a197d6050accac393aad3b86b2398387e34fedf0de5d9f185eb3f2c17f3564b9170b9c262aa3ac91f371279beca0cafac"
        , ids.script_pub_key)
        ids.script_pub_key_size = byte_size
    %}
    utxo_set_insert{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(
        txid, vout, amount, script_pub_key, script_pub_key_size
    );

    let (out_amount, out_script_pub_key, out_script_pub_key_len) = utxo_set_extract{
        hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots
    }(txid, vout);

    assert amount = out_amount;

    // assert script_pub_key_size = out_script_pub_key_len

    return ();
}
