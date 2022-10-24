%lang starknet

from starkware.cairo.common.alloc import alloc
from utils.compute_median import compute_timestamps_median, find_lowest_element, sort_unsigned
from block.block_header import BlockHeader

@view
func test_compute_timestamps_median{range_check_ptr}() {
    tempvar timestamps: felt* = new (10, 16, 8, 0, 3, 3, 7, 20, 0, 4, 10);
    let (median) = compute_timestamps_median(timestamps);

    assert median = 8;

    return ();
}

@view
func test_find_lowest_element{range_check_ptr}() {
    let (lowest_element_index, lowest_element) = find_lowest_element(4, new (10, 4, 3, 7));

    assert lowest_element_index = 2;
    assert lowest_element = 3;

    return ();
}

@view
func test_sort_unsigned{range_check_ptr}(){
    let (sorted_array : felt*) = sort_unsigned(4, new (10, 4, 3, 7));

    assert 3 = sorted_array[0];
    assert 4 = sorted_array[1];
    assert 7 = sorted_array[2];
    assert 10 = sorted_array[3];

    return ();
}


@view
func test_sort_unsigned_with_equal_values{range_check_ptr}(){
    let (sorted_array : felt*) = sort_unsigned(
        11, new (10, 16, 8, 0, 3, 3, 7, 20, 0, 4, 10)
    );

    assert 0 = sorted_array[0];
    assert 0 = sorted_array[1];
    assert 3 = sorted_array[2];
    assert 3 = sorted_array[3];
    assert 4 = sorted_array[4];
    assert 7 = sorted_array[5];
    assert 8 = sorted_array[6];
    assert 10 = sorted_array[7];
    assert 10 = sorted_array[8];
    assert 16 = sorted_array[9];
    assert 20 = sorted_array[10];

    return ();
}
