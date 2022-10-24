from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math_cmp import is_le

const TIMESTAMP_COUNT = 11;
const TIMESTAMP_MEDIAN_INDEX = 6;

func compute_timestamps_median{range_check_ptr}(timestamp_array : felt*) -> (
        median_value : felt
    ) {
    let (sorted_timestamp_array : felt*) = sort_unsigned(TIMESTAMP_COUNT, timestamp_array);
    return (median_value=sorted_timestamp_array[TIMESTAMP_MEDIAN_INDEX]);
}

// Implement a naive sort algorithm for an array of felts without using any hint.
// Complexity is O(n^2) but this is not a problem as it is used to sort an array of only 11 elements.
func sort_unsigned{range_check_ptr}(arr_len : felt, arr : felt*) -> (sorted_array : felt*) {
    alloc_locals;

    let (local sorted_array : felt*) = alloc();
    sort_unsigned_loop(arr_len, arr, sorted_array);
    return (sorted_array=sorted_array);
}

func sort_unsigned_loop{range_check_ptr}(arr_len : felt, arr : felt*, sorted_array : felt*){
    if (arr_len == 0) {
        return ();
    }

    // find the lowest element out of remaining elements
    let (lowest_element_index, lowest_element) = find_lowest_element(arr_len, arr);

    // push the lowest element to the sorted array
    assert sorted_array[0] = lowest_element;

    // remove the lowest element from the remaining elements
    let (arr : felt*) = copy_array_without_index(arr_len, arr, lowest_element_index);

    sort_unsigned_loop(arr_len - 1, arr, sorted_array + 1);
    return ();
}

func find_lowest_element{range_check_ptr}(arr_len : felt, arr : felt*) -> (
    lowest_element_index : felt, lowest_element : felt
){
    return find_lowest_element_loop(0, arr_len, arr, 0);
}

func find_lowest_element_loop{range_check_ptr}(
    index : felt, arr_len : felt, arr : felt*, lowest_element_index : felt
) -> (lowest_element_index : felt, lowest_element : felt){
    if (index == arr_len) {
        return (
            lowest_element_index=lowest_element_index, lowest_element=arr[lowest_element_index]
        );
    }

    let is_lower = is_le(arr[index], arr[lowest_element_index]);
    let new_lowest_element_index = index * is_lower + lowest_element_index * (1 - is_lower);

    return find_lowest_element_loop(index + 1, arr_len, arr, new_lowest_element_index);
}

func copy_array_without_index{range_check_ptr}(
    arr_len : felt, arr : felt*, removed_index : felt
) -> (new_arr : felt*) {
    alloc_locals;

    let (local new_arr : felt*) = alloc();
    copy_array_without_index_loop(0, arr_len, arr, removed_index, 0, new_arr);
    return (new_arr=new_arr);
}

func copy_array_without_index_loop{range_check_ptr}(
    index : felt,
    arr_len : felt,
    arr : felt*,
    removed_index : felt,
    new_index : felt,
    new_arr : felt*,
){
    if (index == arr_len) {
        return ();
    }

    if (index == removed_index) {
        copy_array_without_index_loop(
            index + 1, arr_len, arr, removed_index, new_index, new_arr
        );
        return ();
    }

    assert new_arr[new_index] = arr[index];

    copy_array_without_index_loop(
        index + 1, arr_len, arr, removed_index, new_index + 1, new_arr
    );
    return ();
}
