# Python program to read
# json file

import json

# Opening JSON file
io = open('tests_bits_to_target_io.json')
# Creating .cairo file
f = open("test_bits_to_target.cairo", "w")

# returns JSON object as 
# a dictionary
io_json = json.load(io)

f.write("// This is a auto generated test\n%lang starknet\nfrom block_header import bits_to_target, target_to_bits\nfrom starkware.cairo.common.cairo_builtins import BitwiseBuiltin\n\n")
TAB = "    "

def generate_function(function_name, input, expected_output, counter):
        return f"@external\nfunc test_{function_name}_{counter}" + "{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {\n" + \
        TAB +"let input = " + input + ";\n" + \
        TAB +"let expected_target = " + expected_output + ";\n" + \
        TAB + f"let (result) = {function_name}(input);\n" + \
        TAB + "assert result = expected_target;\n"  + \
        TAB + "return ();\n" + \
        "}\n\n"

for func_case in io_json.keys():
    tests_count = 0
    for io_case in io_json[func_case]:
        f.write(generate_function(func_case, io_case["input"], io_case["expected_output"], tests_count))
        tests_count += 1

# Closing file
io.close()
f.close()
