%lang starknet

from block_header import bits_to_target, target_to_bits
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

@external
func test_general{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    local bits_to_target_tests_count;
    local target_to_bits_tests_count;
    local bits_to_target_array;
    local target_to_bits_array;

    %{
        # Python program to read
        # json file

        import json

        # Opening JSON file
        io = open('src/block/tests_bits_to_target_io.json')

        # returns JSON object as 
        # a dictionary
        io_json = json.load(io)

        ids.bits_to_target_tests_count = len(io_json["bits_to_target"])
        ids.target_to_bits_tests_count = len(io_json["target_to_bits"])

        io.close()
    %}

    _bits_to_target_tests(bits_to_target_tests_count);
    _target_to_bits_tests(target_to_bits_tests_count);

    return ();
}

func _bits_to_target_tests{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(bits_to_target_tests_count){
    alloc_locals;

    if (bits_to_target_tests_count == 0) {
        return ();
    }

    local input; 
    local expected_output;
    
    %{
        # Python program to read
        # json file

        import json

        # Opening JSON file
        io = open('src/block/tests_bits_to_target_io.json')

        # returns JSON object as 
        # a dictionary
        io_json = json.load(io)
        current_io = io_json["bits_to_target"][ids.bits_to_target_tests_count - 1]
        ids.input = int(current_io["input"], 16)
        ids.expected_output = int(current_io["expected_output"], 16)

        io.close()
    %}

    let (result) = bits_to_target(input);
    assert expected_output = result;

    _bits_to_target_tests(bits_to_target_tests_count - 1);
    return ();
}

func _target_to_bits_tests{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(target_to_bits_tests_count){
    alloc_locals;
    
    if (target_to_bits_tests_count == 0) {
        return ();
    }

    local input;
    local expected_output;
    
    %{
        # Python program to read
        # json file

        import json

        # Opening JSON file
        io = open('src/block/tests_bits_to_target_io.json')

        # returns JSON object as 
        # a dictionary
        io_json = json.load(io)
        current_io = io_json["target_to_bits"][ids.target_to_bits_tests_count - 1]
        ids.input = int(current_io["input"], 16)
        ids.expected_output = int(current_io["expected_output"], 16)

        io.close()
    %}

    let (result) = target_to_bits(input);
    assert expected_output = result;

    _target_to_bits_tests(target_to_bits_tests_count - 1);
    return ();
}
