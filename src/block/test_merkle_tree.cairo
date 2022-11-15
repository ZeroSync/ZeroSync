// Note that Bitcoin Core and most block explorers swap the endianess when displaying a hash
// So, we have to reverse the byte order to compute the merkle tree

//
// To run only this test suite use:
// protostar test --cairo-path=./src target src/block/test_merkle_tree.cairo
//
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from crypto.hash_utils import assert_hashes_equal
from block.merkle_tree import compute_merkle_root
from utils.python_utils import setup_python_defs

// Simple test case (2 TXs)
// Test case from https://medium.com/coinmonks/how-to-manually-verify-the-merkle-root-of-a-bitcoin-block-command-line-7881397d4db1
@external
func test_compute_merkle_root{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    // Call setup_python_defs at least once to make sure the python functions for the next hint are defined
    setup_python_defs();
    let (leaves) = alloc();
    let (root_expected) = alloc();
    local leaves_len;
    %{
        # For new test cases simply change the hashes and root_expected lists
        ids.leaves_len = hashes_from_hex([
            "b1fea52486ce0c62bb442b530a3f0132b826c74e473d1f2c220bfa78111c5082",
            "f4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16"
        ], ids.leaves)
        hashes_from_hex([
            "7dac2c5666815c17a3b36427de37bb9d2e2c5ccec3f8633eb91a4205cb4c10ff"
        ], ids.root_expected)
    %}

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    with sha256_ptr {
        let root = compute_merkle_root(leaves, leaves_len);
    }
    assert_hashes_equal(root, root_expected);
    return ();
}

// Power of 2 test case (8 TXs)
// https://blockchain.info/block/000000000000307b75c9b213f61b2a0c429a34b41b628daae9774cb9b5ff1059
// Test case from https://gist.github.com/thereal1024/45bb035e580430988a34
@external
func test_compute_merkle_root_power_of_2{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();
    let (leaves) = alloc();
    let (root_expected) = alloc();
    local leaves_len;
    %{
        ids.leaves_len = hashes_from_hex([
            "04a2808134e646ba67ff83f0bc7535a008b6e154c98953f5e2c9d40429880faf",
            "b6b3ff7b4d004a788c751f3f8fc881f96c7b647ae06eb9a720bddc924e6f9147",
            "e614ebb7e059e248e1f4c440f91af5c9617394a05d72233d7acf6feb153362f1",
            "5bbc4545145126108c91689e62c1806646468c547999241f5c2883a526e015b6",
            "de56c21783d3d466c0a5a155ed909c7011879df1996d8c418dac74465ebc3564",
            "d327f96d32afdbf4238458684570189de26ba5dc300d5cd19fa1a9cdcecdb527",
            "702c3d845810f31c194e7c9ea3d2b3636f3b8b9ee71f3d93a2f36e9d1a4e9a81",
            "b320e44b0e4cbe5973b4ebdea0c63939f9cc196982e3f4d15daaa1baa16f0004"
        ], ids.leaves)

        hashes_from_hex([
            "0b0192e318af62f8f91243948ea4c7ea9d696197e88b9401bce35ecb0a0cb59b"
        ], ids.root_expected)
    %}

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    with sha256_ptr {
        let root = compute_merkle_root(leaves, leaves_len);
    }
    assert_hashes_equal(root, root_expected);
    return ();
}

// Uneven test case (13 TXs)
// https://blockchain.info/block/0000000000004563d49a8e7f7f2a2f0aec01101fa971fb63714b8fbf32f62f91
// Test case from https://gist.github.com/thereal1024/45bb035e580430988a34
@external
func test_compute_merkle_root_uneven{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();
    let (leaves) = alloc();
    let (root_expected) = alloc();
    local leaves_len;
    %{
        ids.leaves_len = hashes_from_hex([
            "df70f26b6df54332ad29c08aab5e5d5560d1468311e90484ebd89f87ac6264e8",
            "2148314cd02237786abe127f23b7346df8a116a2851745cb987652a3e132fc50",
            "06c303894833eb5d639f06f95ceb2c4bd08e0ab4ae1d94cccfa54f02e9b35990",
            "90ae3d27a5215dbb8e2e1657c927f81bdb9601106a6159f5384b4cde53836f24",
            "51cfe20029ed6366e7f475a123ad84c96c54522e9ae64cb2f548811124a6f833",
            "1e856be000b0fbaa5929b887755095106f4f0d3d19f9cd9cb07ab2239c8b4b18",
            "9d6314d68d9de8250513563e02f83ffc80973ec8b7c2966835e2cbcac3320898",
            "5d6e3fc4b0c44b867b83b7d7ca365754a8bb87d93c4f365ecacc1f0109b4c99c",
            "58afcfed0a60792c3e15d8bb2bd8d59f2a968639473e575e2fc1c270fcfae910",
            "50a0e15c32c257934f75ee2fa125dd7e9a542d38b5989efc380ea2c06a299804",
            "acd706cdbe74f82040cc583e42dfc28d8603c2f7d2fe29c0d41ee2e8d78be51b",
            "c7be55d3b55bd59f1ca19d2dc3ffbe8c28917c9e27f02456872755215b4b8a1f",
            "e323fe6719e707b8deb108d3f4bcc43d9e018cf48e027b8f88941886a0744f60"
        ], ids.leaves)

        hashes_from_hex([
            "560a4d3b44e57ff78be70d29698a8f98ce11677c1a59fb9966a7cd1795c9b47b"
        ], ids.root_expected)
    %}

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    with sha256_ptr {
        let root = compute_merkle_root(leaves, leaves_len);
    }
    assert_hashes_equal(root, root_expected);
    return ();
}

// Test CVE-2012-2459
@external
func test_compute_merkle_root_CVE_2012_2459{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    setup_python_defs();
    let (leaves) = alloc();
    local leaves_len;
    %{
        txs = [
            "df70f26b6df54332ad29c08aab5e5d5560d1468311e90484ebd89f87ac6264e8",
            "2148314cd02237786abe127f23b7346df8a116a2851745cb987652a3e132fc50",
            "06c303894833eb5d639f06f95ceb2c4bd08e0ab4ae1d94cccfa54f02e9b35990",
            "90ae3d27a5215dbb8e2e1657c927f81bdb9601106a6159f5384b4cde53836f24",
            "51cfe20029ed6366e7f475a123ad84c96c54522e9ae64cb2f548811124a6f833",
            "1e856be000b0fbaa5929b887755095106f4f0d3d19f9cd9cb07ab2239c8b4b18",
            "9d6314d68d9de8250513563e02f83ffc80973ec8b7c2966835e2cbcac3320898",
            "5d6e3fc4b0c44b867b83b7d7ca365754a8bb87d93c4f365ecacc1f0109b4c99c",
        ]
        ids.leaves_len = hashes_from_hex(txs + txs, ids.leaves)
    %}

    // initialize sha256_ptr
    let sha256_ptr: felt* = alloc();
    %{ expect_revert(error_message = "unexpected node duplication in merkle tree") %}
    with sha256_ptr {
        compute_merkle_root(leaves, leaves_len);
    }
    return ();
}
