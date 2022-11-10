%lang starknet

from starkware.cairo.common.alloc import alloc
from utils.compute_median import compute_timestamps_median

@external
func test_compute_timestamps_median{range_check_ptr}() {
    tempvar timestamps: felt* = new (10, 16, 8, 0, 3, 3, 7, 20, 0, 4, 10);
    let (median) = compute_timestamps_median(timestamps);

    assert 7 = median;

    return ();
}

@external
func test_compute_timestamps_median_zero{range_check_ptr}() {
    tempvar timestamps: felt* = new (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
    let (median) = compute_timestamps_median(timestamps);

    assert 5 = median;

    return ();
}

@external
func test_compute_timestamps_median_edge_case1{range_check_ptr}() {
    tempvar timestamps: felt* = new (1, 2, 3, 4, 5, 5, 6, 7, 8, 9, 10);
    let (median) = compute_timestamps_median(timestamps);

    %{ expect_revert() %}

    assert 6 = median;

    return ();
}