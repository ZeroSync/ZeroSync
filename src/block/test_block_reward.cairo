//
// To run only this test suite use:
// protostar test --cairo-path=./src target src/block/test_block_reward.cairo
//
%lang starknet

from block.block import compute_block_reward

@external
func test_compute_merkle_root{range_check_ptr}() {
    // TODO: implement me
    return ();
}
    
