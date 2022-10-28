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

f.write("// This is a auto generated test\n")
f.write("%lang starknet\n")
f.write("from block_header import bits_to_target, target_to_bits\n")
f.write("from starkware.cairo.common.cairo_builtins import BitwiseBuiltin\n")

TAB = "    "
tests_count = 1
for io_case in io_json["bits_to_target"]:
    f.write(f"@external\nfunc test_bits_to_target_small_works{tests_count}" + "{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {\n")
    f.write(TAB +"let bits = " + io_case["input"] + ";\n")
    f.write(TAB +"let expected_target = " + io_case["expected_target"] + ";\n")
    f.write(TAB + "let (result) = bits_to_target(bits);\n")
    f.write(TAB + "assert result = expected_target;\n" )    
    f.write(TAB + "return ();\n")
    f.write("}\n\n")
    tests_count += 1

# Closing file
io.close()
f.close()
