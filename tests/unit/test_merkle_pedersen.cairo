%lang starknet

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.alloc import alloc
from headers_chain_proof.pedersen_merkle_tree import append_merkle_tree_pedersen

@external
func test_create_merkle_tree{pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (leaves_ptr: felt*) = alloc();
    assert leaves_ptr[0] = 1;
    assert leaves_ptr[1] = 2;
    assert leaves_ptr[2] = 3;
    assert leaves_ptr[3] = 4;
    assert leaves_ptr[4] = 5;
    assert leaves_ptr[5] = 6;
    assert leaves_ptr[6] = 7;
    assert leaves_ptr[7] = 8;

    let leaves_ptr_len = 8;

    let (merkle_path) = alloc();
    assert merkle_path[0] = 0;
    assert merkle_path[1] = 0;
    assert merkle_path[2] = 0;

    let expected_merkle_root = 0x28015ba23dce0238feda181c0c2dd7a87e528721d96f71281d65c603263d0ca;

    let merkle_root = append_merkle_tree_pedersen{hash_ptr=pedersen_ptr}(leaves_ptr, leaves_ptr_len, merkle_path);

    assert expected_merkle_root = merkle_root;

    return ();
}


// Old Merkle tree consists of 1,2,3,4,5,6,7 and we want to append 8
@external
func test_append_incomplete_merkle_tree{pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (leaves_ptr: felt*) = alloc();
    // Element of the merkle path on the lowest level is part of leaves input
    assert leaves_ptr[0] = 7;
    // Elements that will be appended
    assert leaves_ptr[1] = 8;

    let leaves_ptr_len = 2;
    
    let (merkle_path) = alloc();
    assert merkle_path[0] = 0x1f680f4b3e66b11ac6b827ef46e7d2da4075e0dc83b7e322d590dbb7687f417; // hash of 5 and 6
    assert merkle_path[1] = 0x6a27df2b1eaf16c77478b9c001cfdebe956b7ad878b141b0b4b24659fa59fde; // hash of 1-2 and 3-4
    assert merkle_path[2] = 0;

    let expected_merkle_root = 0x28015ba23dce0238feda181c0c2dd7a87e528721d96f71281d65c603263d0ca;
    let merkle_root = append_merkle_tree_pedersen{hash_ptr=pedersen_ptr}(leaves_ptr, leaves_ptr_len, merkle_path);
    assert expected_merkle_root = merkle_root;

    return ();
}


// Old Merkle tree consists of 1,2,3,4 and we want to append 5,6,7,8
@external
func test_append_complete_merkle_tree{pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (leaves_ptr: felt*) = alloc();
    // Elements that will be appended
    assert leaves_ptr[0] = 5;
    assert leaves_ptr[1] = 6;
    assert leaves_ptr[2] = 7;
    assert leaves_ptr[3] = 8;

    let leaves_ptr_len = 4;
    
    let (merkle_path) = alloc();
    assert merkle_path[0] = 0;
    assert merkle_path[1] = 0x6a27df2b1eaf16c77478b9c001cfdebe956b7ad878b141b0b4b24659fa59fde; // hash of 1-2 and 3-4
    assert merkle_path[2] = 0;

    let expected_merkle_root = 0x28015ba23dce0238feda181c0c2dd7a87e528721d96f71281d65c603263d0ca;
    let merkle_root = append_merkle_tree_pedersen{hash_ptr=pedersen_ptr}(leaves_ptr, leaves_ptr_len, merkle_path);
    assert expected_merkle_root = merkle_root;

    return ();
}

