import os
import json

P = 2**251 + 17 * 2**192 + 1

def parse_cairo_output(cairo_output):
	# Split at line break. Then cut off all lines until the start of the program output
    lines = cairo_output.split('\n')
    start_index = lines.index('Program output:') + 1

    print('\n')
    prints = lines[:start_index-1]
    for line in prints:
        print(line)

    lines = lines[start_index:]

	# Remove the empty lines
    lines = [x for x in lines if x.strip() != '']

    # Cast all values to int
    lines = map(int, lines)

    # Make negative values positive
    lines = map(lambda x: x if x >= 0 else (x + P) % P, lines)

    return list(lines)


cursor = 0
def read_felt():
	global cursor
	cursor += 1
	return program_output[cursor-1]

def read_felts(felt_count):
	global cursor
	cursor += felt_count
	return program_output[cursor-felt_count:cursor]


cmd = 'cairo-compile cairo/src/main.cairo --cairo_path cairo/src --output tmp/program.json'
print( os.popen(cmd).read() )

file_name = 'data/block_0.json' 

start_block_height = 0
end_block_height = 172 # First Bitcoin TX ever occured in block 170
for i in range(start_block_height, end_block_height):
	if i >= 1:
		file_name = 'data/state.json'

	cmd = 'cairo-run --program=tmp/program.json --layout=all --print_output --program_input=' + file_name + ' --trace_file=tmp/trace.bin --memory_file=tmp/memory.bin'

	program_output_string = os.popen(cmd).read()
	program_output = parse_cairo_output(program_output_string)

	# print(program_output)

	cursor = 0

	state = {
		'block_height' : read_felt(),
		'best_block_hash' : read_felts(8),
		'total_work' : read_felt(),
		'difficulty' : read_felt(),
		'prev_timestamps' : read_felts(11),
		'epoch_start_time' : read_felt(),
		'state_roots' : read_felts(27)
	}

	print('block height:', state['block_height'])


	# Write the state into a json file
	f = open('data/state.json', 'w')
	f.write(json.dumps(state, indent=2))
	f.close()

