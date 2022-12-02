//
// To run only this test suite use:
// protostar test  --cairo-path=./src target src/**/*_utreexo*
//
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin

from utreexo.utreexo import utreexo_add, utreexo_delete, utreexo_init

@external
func test_utreexo_basics{range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    alloc_locals;

    let utreexo_roots = utreexo_init();

    utreexo_add{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x111111111111111111111111);
    assert 0x111111111111111111111111 = utreexo_roots[0];

    utreexo_add{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x222222222222222222222222);
    assert 0 = utreexo_roots[0];
    assert 0x1b586e993478db71562f0cfe2ad81ccc463b0d18e64bde2fc825530714d8328 = utreexo_roots[1];

    utreexo_add{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x333333333333333333333333);
    assert 0x333333333333333333333333 = utreexo_roots[0];
    assert 0x1b586e993478db71562f0cfe2ad81ccc463b0d18e64bde2fc825530714d8328 = utreexo_roots[1];

    utreexo_add{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(0x444444444444444444444444);
    assert 0 = utreexo_roots[0];
    assert 0 = utreexo_roots[1];
    assert 0x155d0053a90471bdcccd6f93c7bcea38a8e4dddb190077568fb8514cf9f3392 = utreexo_roots[2];

    let (inclusion_proof) = alloc();
    assert inclusion_proof[0] = 0x444444444444444444444444;
    assert inclusion_proof[1] = 0x1b586e993478db71562f0cfe2ad81ccc463b0d18e64bde2fc825530714d8328;

    let inclusion_proof_len = 2;
    let leaf_index = 2;
    let leaf = 0x333333333333333333333333;
    utreexo_delete{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(
        leaf, leaf_index, inclusion_proof, inclusion_proof_len
    );

    return ();
}

@external
func test_utreexo_inclusion{range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    alloc_locals;

    let (utreexo_roots) = alloc();

    assert utreexo_roots[0] = 0;
    assert utreexo_roots[1] = 0x60eca2f5761f335018c8349e3009266cecb15ca0aafebf16fff82294b58a927;
    assert utreexo_roots[2] = 0;
    assert utreexo_roots[3] = 0x2da545c9e563a98924b88674350c101473dfc830cfc8294149009482e692d38;
    assert utreexo_roots[4] = 0;
    assert utreexo_roots[5] = 0x0b821cae677cb979640f3174d902df305e43801f1341dc4d6e688b38d582f63;
    assert utreexo_roots[6] = 0;
    assert utreexo_roots[7] = 0x79165659241d0f009f93ba979fdcbdf392d608a2e312df19f225725ab48a03d;
    assert utreexo_roots[8] = 0;
    assert utreexo_roots[9] = 0;
    assert utreexo_roots[10] = 0;
    assert utreexo_roots[11] = 0;
    assert utreexo_roots[12] = 0;
    assert utreexo_roots[13] = 0;
    assert utreexo_roots[14] = 0;
    assert utreexo_roots[15] = 0;
    assert utreexo_roots[16] = 0;
    assert utreexo_roots[17] = 0;
    assert utreexo_roots[18] = 0;
    assert utreexo_roots[19] = 0;
    assert utreexo_roots[20] = 0;
    assert utreexo_roots[21] = 0;
    assert utreexo_roots[22] = 0;
    assert utreexo_roots[23] = 0;
    assert utreexo_roots[24] = 0;
    assert utreexo_roots[25] = 0;
    assert utreexo_roots[26] = 0;
    let leaf = 0x17da72c9147f43a3491e2f378f3d62f626136ca5d5c77d61f7cee2f76d595ea;
    let leaf_index = 9;

    let (inclusion_proof) = alloc();
    assert inclusion_proof[0] = 0x4ce2e86eb35ce480db8e78be4a8ce0ef6b954f1fa2a6f212292a80945561af0;
    assert inclusion_proof[1] = 0x1562e0628478c3f51de8fa35997bbd88a6f88de01ef5e4173cec5c7d0467515;
    assert inclusion_proof[2] = 0x488e519ce1f3792fd89ce87c976d19ce67b1a27a7f5a8cab92b39be10a853b7;
    assert inclusion_proof[3] = 0x5fc2a2790b3dabe66f73b5f850b630ff986cdaacf1561a7aa1dd30c47aab9a4;
    assert inclusion_proof[4] = 0x5234b6e55ded0e42e4733293f6da7e934d1912507bf1832815d98a4b9c05b07;
    assert inclusion_proof[5] = 0x6aa8b88954fbac89b8b792b1ab5503736b4bea9a6f29b81f4f807b63a0ed4d5;
    assert inclusion_proof[6] = 0x18a171f75918e2721982736cd51d849ef640a1d544b847330c56ba98f589d94;
    let inclusion_proof_len = 7;

    utreexo_delete{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(
        leaf, leaf_index, inclusion_proof, inclusion_proof_len
    );

    // Test if the tree is still intact
    utreexo_add{hash_ptr=pedersen_ptr, utreexo_roots=utreexo_roots}(leaf);

    return ();
}
