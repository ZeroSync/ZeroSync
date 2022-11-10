%lang starknet

from starkware.cairo.common.alloc import alloc
from utils.compute_median import compute_timestamps_median

@view
func test_compute_timestamps_median{range_check_ptr}() {
    tempvar timestamps: felt* = new (10, 16, 8, 0, 3, 3, 7, 20, 0, 4, 10);
    let (median) = compute_timestamps_median(timestamps);

    assert 7 = median;

    return ();
}
