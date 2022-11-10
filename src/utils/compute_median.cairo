from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.math import abs_value, assert_le

const TIMESTAMP_COUNT = 11;
const TIMESTAMP_MEDIAN_INDEX = 5;

// Compute the median value of an array of 11 timestamps
//
func compute_timestamps_median{range_check_ptr}(timestamp_array : felt*) -> (
        median_value : felt
    ) {
    alloc_locals;
    local median;
    %{
        arr = []
        for i in range(ids.TIMESTAMP_COUNT):
            arr.append( memory[ids.timestamp_array + i] )
        arr.sort()
        ids.median = arr[ids.TIMESTAMP_MEDIAN_INDEX]
    %}

    let (lt, eq, gt) = count_values(median, timestamp_array, TIMESTAMP_COUNT);

    // Ensure the median occurs at least once
    if(eq == 0){
        assert 1 = 0;
    }

    // To verify the hint iterate through the array and ensure that 
    // num_elems_eq_median > abs( num_elems_lt_median - num_elems_gt_median )
    let diff = abs_value(lt - gt);
    assert_le(diff + 1, eq);
    
    return (median,);
}

func count_values{range_check_ptr}(median, arr: felt*, arr_len) -> (felt, felt, felt){
    if(arr_len == 0) {
        return (0, 0, 0);
    }
    let (lt, eq, gt) = count_values(median, arr + 1, arr_len - 1);
    if ([arr] == median) {
        return (lt, eq + 1, gt);
    }

    let is_lt = is_le([arr], median);
    if(is_lt == 1){
        return (lt + 1, eq, gt);
    }

    return (lt, eq, gt + 1);
}
