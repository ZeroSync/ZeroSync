from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import sign, abs_value, assert_le

const TIMESTAMP_COUNT = 11;
const TIMESTAMP_MEDIAN_INDEX = 5;

// Compute the median value of an array of 11 timestamps
//
func compute_timestamps_median{range_check_ptr}(timestamp_array: felt*) -> (felt,) {
    alloc_locals;
    // Compute the median using a hint
    local median;
    %{
        timestamps = []
        for i in range(ids.TIMESTAMP_COUNT):
            timestamps.append( memory[ids.timestamp_array + i] )
        timestamps.sort()
        ids.median = timestamps[ids.TIMESTAMP_MEDIAN_INDEX]
    %}
    verify_timestamps_median(timestamp_array, median);
    return (median,);
}

// Verify the median value of an array of 11 timestamps
//
func verify_timestamps_median{range_check_ptr}(timestamp_array: felt*, median) {
    // To verify the hint iterate through the array and ensure that
    // num_elems_eq_median > abs( num_elems_lt_median - num_elems_gt_median )
    tempvar signs_diff = 0;
    tempvar n_median_occurences = 0;
    tempvar timestamp_ptr = timestamp_array;
    tempvar n_timestamps = 11;
    tempvar range_check_ptr = range_check_ptr;

    verify_median_loop:
    let delta_sign = sign([timestamp_ptr] - median);
    if (delta_sign == 0) {
        tempvar signs_diff = signs_diff;
        tempvar n_median_occurences = n_median_occurences + 1;
    } else {
        tempvar signs_diff = signs_diff + delta_sign;
        tempvar n_median_occurences = n_median_occurences;
    }
    tempvar timestamp_ptr = timestamp_ptr + 1;
    tempvar n_timestamps = n_timestamps - 1;
    tempvar range_check_ptr = range_check_ptr;
    jmp verify_median_loop if n_timestamps != 0;
    let absolute_signs = abs_value(signs_diff);
    with_attr error_message("invalid timestamps median") {
        assert_le(absolute_signs + 1, n_median_occurences);
    }
    return ();
}
