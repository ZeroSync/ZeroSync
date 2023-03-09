import argparse
import json
import os
import struct
import urllib3
import subprocess
import time

parser = argparse.ArgumentParser(description='Generate a chain proof')
parser.add_argument('--output_dir', type=str, default='tmp')
args = parser.parse_args()

P = 2**251 + 17 * 2**192 + 1
NUM_OUTPUTS = 51
FOLDING_FACTOR = 8


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


def felts_to_hex(felts):
    return list(map(felt_to_hex, felts))


def felt_to_hex(felt):
    """
    Convert felts to hex representation.
    Remove leading "0x", pad leading zeros to 32 bytes
    """
    hex_felt = hex(felt).replace('0x', '').zfill(64)
    if(int(hex_felt, 16) == 0):
        return "0"
    return hex_felt


def parse_cairo_output(cairo_output, debug=False):
    # Split at line break. Then cut off all lines until the start of the
    # program output
    lines = cairo_output.split('\n')
    start_index = lines.index('Program output:') + 1

    if debug:
        print('\n')
        prints = lines[:start_index - 1]
        for line in prints:
            print(line)

    lines = lines[start_index:]
    lines = [x for x in lines if x.strip() != '']
    lines = map(int, lines)
    lines = map(lambda x: x if x >= 0 else (x + P) % P, lines)
    return list(lines)


output_dir = args.output_dir
os.popen(f'mkdir -p {output_dir}')

# Reset the bridge node to ensure we start with an empty UTXO set
urllib3.PoolManager().request('GET', 'http://localhost:2121/reset')

# Run the Cairo compiler
cmd = f'cairo-compile src/chain_proof/main.cairo \
        --cairo_path=src                         \
        --output={output_dir}/program.json'
print(os.popen(cmd).read())

# Copy genesis state.json into the output directory
f = open('src/chain_proof/state_0.json')
genesis_state = json.load(f)

# Read the program_length from program.json and update
# it in the genesis state
f = open(f'{output_dir}/program.json')
program = json.load(f)
genesis_state['program_length'] = len(program['data'])
# TODO: compute program hash and write it into chain_state.json

with open(f'{output_dir}/chain_state.json', 'w') as outfile:
    outfile.write(json.dumps(genesis_state))

chain_state_file = f'{output_dir}/chain_state.json'

# The first Bitcoin TX ever occured in block 170. The second TX occured in block 181.
start_block_height = 0
end_block_height = 100
for i in range(start_block_height, end_block_height):
    print(f'\n === Processing block height {i} ===')

    # Run the Cairo runner
    print(f'Step 1: Cairo runner...')
    start_time = time.time()
    cmd = f'cairo-run                           \
            --program={output_dir}/program.json \
            --layout=all                        \
            --print_output                      \
            --program_input={chain_state_file}  \
            --trace_file={output_dir}/trace.bin \
            --memory_file={output_dir}/memory.bin'
    program_output_string = os.popen(cmd).read()
    program_output = parse_cairo_output(program_output_string)
    print(f'Running time: { int(time.time()-start_time) } seconds\n')

    # Parse outputs
    r = FeltsReader(program_output)
    chain_state = {
        'block_height':         r.read(),
        'best_block_hash':      felts_to_hash(r.read_n(8)),
        'total_work':           r.read(),
        'current_target':       r.read(),
        'prev_timestamps':      r.read_n(11),
        'epoch_start_time':     r.read(),
        'utreexo_roots':        felts_to_hex(r.read_n(27)),
        'program_hash':         hex(r.read())
    }
    # Write the chain state into a json file
    f = open(f'{output_dir}/chain_state.json', 'w')
    f.write(json.dumps(chain_state, indent=2))
    f.close()

    # Run Giza prover
    print(f"Step 2: Giza prover...")
    start_time = time.time()
    cmd = f'giza prove                          \
            --trace={output_dir}/trace.bin      \
            --memory={output_dir}/memory.bin    \
            --program={output_dir}/program.json \
            --output={output_dir}/chain_proof-{i}.bin \
            --num-outputs={NUM_OUTPUTS} \
            --fri-folding-factor={FOLDING_FACTOR}'
    return_code = subprocess.call(cmd, shell=True)
    if return_code == 0:
        print(f'Proving time: { int(time.time()-start_time) } seconds')
        print(f'Done proving chain_proof-{i}\n')
    else:
        print(f'Proving failed. Error code: {return_code}\n')
