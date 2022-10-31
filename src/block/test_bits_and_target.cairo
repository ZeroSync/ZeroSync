%lang starknet

from block_header import bits_to_target, target_to_bits
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

@external
func test_general{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    local bits_to_target_tests_count;
    local target_to_bits_tests_count;
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

func _bits_to_target_tests{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(test_index){
    alloc_locals;

    if (test_index == 0) {
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
        current_io = io_json["bits_to_target"][ids.test_index - 1]
        ids.input = int(current_io["input"], 16)
        ids.expected_output = int(current_io["expected_output"], 16)

        io.close()
    %}

    let (result) = bits_to_target(input);
    assert expected_output = result;

    _bits_to_target_tests(test_index - 1);
    return ();
}

func _target_to_bits_tests{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(test_index){
    alloc_locals;
    
    if (test_index == 0) {
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
        current_io = io_json["target_to_bits"][ids.test_index - 1]
        ids.input = int(current_io["input"], 16)
        ids.expected_output = int(current_io["expected_output"], 16)

        io.close()
    %}

    let (result) = target_to_bits(input);
    assert expected_output = result;

    _target_to_bits_tests(test_index - 1);
    return ();
}
