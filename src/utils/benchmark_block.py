import struct
import os
import json
from utxo_dummy_generator import generate_utxo_dummys
import urllib3

P = 2**251 + 17 * 2**192 + 1


def parse_cairo_output(cairo_output):
    # Split at line break. Then cut off all lines until the start of the
    # program output
    lines = cairo_output.split('\n')
    start_index = lines.index('Program output:') + 1

    print('\n')
    prints = lines[:start_index - 1]
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


class FeltsReader:
    def __init__(self, program_output):
        self.cursor = 0
        self.program_output = program_output

    def read(self):
        self.cursor += 1
        return self.program_output[self.cursor - 1]

    def read_n(self, felt_count):
        self.cursor += felt_count
        return self.program_output[self.cursor - felt_count: self.cursor]


def felts_to_hash(felts):
    res = 0
    for i in range(8):
        felt = felts[i]
        # Swap endianess
        felt = struct.unpack("<I", struct.pack(">I", felt))[0]
        res += pow(2**32, i) * felt

    return hex(res).replace('0x', '').zfill(64)


# Pretty format as hex
# remove leading "0x", add leading zeros to 32 bytes, but display zero as "0".
def felt_to_hex(felt):
    hex_felt = hex(felt).replace('0x', '').zfill(64)
    if(int(hex_felt, 16) == 0):
        return "0"
    return hex_felt


def felts_to_hex(felts):
    return list(map(felt_to_hex, felts))


# Inserts all required utxos and returns the utreexo roots.
def setup_bridge_node(block_height):
    http = urllib3.PoolManager()
    utxo_hashes = generate_utxo_dummys(block_height)
    for utxo_hash in utxo_hashes:
        url = 'http://localhost:2121/add/' + hex(hash)
        r = http.request('GET', url)

    url = 'http://localhost:2121/add/' + hex_hash
    r = http.request('GET', url)


if __name__ == '__main__':
    output_dir = 'tmp'

    os.popen(f'mkdir -p {output_dir}')

    # Run the Cairo compiler
    os.cwd('../')
    cmd = f'cairo-compile src/chain_proof/main.cairo --cairo_path src --output utils/{output_dir}/program.json'
    os.cwd('utils/')

    print(os.popen(cmd).read())

    # Copy genesis state.json into the output directory
    # also read the program_length from program.json
    # and add it to the state.json
    f = open('../src/chain_proof/state_0.json')
    genesis_state = json.load(f)

    f = open(f'{output_dir}/program.json')
    program = json.load(f)
    genesis_state['program_length'] = len(program['data'])

    with open(f'{output_dir}/chain_state.json', 'w') as outfile:
        outfile.write(json.dumps(genesis_state))

    chain_state_file = f'{output_dir}/chain_state.json'

    # The first Bitcoin TX ever occured in block 170. The second TX occured in
    # block 181.
    block_height = 0  # TODO Allow input from user.

    # Run the Cairo runner
    cmd = f'cairo-run --program={output_dir}/program.json --layout=all --print_info --print_output --program_input={chain_state_file} --trace_file={output_dir}/trace.bin --memory_file={output_dir}/memory.bin'

    # TODO Parse this in a way to see info and program output.
    program_output_string = os.popen(cmd).read()
    program_output = parse_cairo_output(program_output_string)

    # Parse outputs
    r = FeltsReader(program_output)
    chain_state = {
        'block_height': r.read(),
        'best_block_hash': felts_to_hash(r.read_n(8)),
        'total_work': r.read(),
        'current_target': r.read(),
        'prev_timestamps': r.read_n(11),
        'epoch_start_time': r.read(),
        'utreexo_roots': felts_to_hex(r.read_n(27)),
        'program_hash': hex(r.read()),
        'program_length': r.read()
    }

    print('block height:', chain_state['block_height'])

    # Run Giza prover
    cmd = f'giza prove --trace={output_dir}/trace.bin --memory={output_dir}/memory.bin --program={output_dir}/program.json --output={output_dir}/proof.bin --num-outputs=50'
    program_output_string = os.popen(cmd).read()
    # TODO Get amount of RAM used by giza
