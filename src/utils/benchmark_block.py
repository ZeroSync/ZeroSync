import struct
import sys
import os
import json
from utxo_dummy_generator import generate_utxo_dummys, fetch_block
import urllib3
import time
import datetime
import resource

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

    # Send a reset.
    url = 'http://localhost:2121/reset'
    _ = http.request('GET', url)

    # Fetch all required utxo hashes.
    utxo_hashes = generate_utxo_dummys(block_height)

    # Fill bridge node with utxos.
    for utxo_hash in utxo_hashes:
        url = 'http://localhost:2121/add/' + hex(utxo_hash)
        r = http.request('GET', url)

    # Get the final list of roots
    url = 'http://localhost:2121/roots'
    r = http.request('GET', url)
    return json.loads(r.data)


def bridge_node_running():
    http = urllib3.PoolManager()

    try:
        # Send a reset.
        url = 'http://localhost:2121/reset'
        _ = http.request('GET', url)
    except BaseException:
        return False
    return True


if __name__ == '__main__':

    # The first Bitcoin TX ever occurred in block 170. The second TX occurred in
    # block 181.

    if len(sys.argv) < 2:
        print(
            f'Wrong number of arguments.\nUsage: python {sys.argv[0]} BLOCK_HEIGHT')
        exit(1)
    block_height = int(sys.argv[1])

    # Before we do anything else check if the bridge node is running
    if not bridge_node_running():
        print("ERROR: Bridge node is not running. Required to initialize the utxo set.")
        exit(2)

    output_dir = 'benchmark_tmp'
    os.system(f'mkdir -p {output_dir}')

    # Run the Cairo compiler
    # Assume we are in the repository root directory.
    print('Compiling the Cairo program...')
    cmd = f'cairo-compile src/chain_proof/main.cairo --cairo_path src --output {output_dir}/program.json'
    print(os.popen(cmd).read())  # In case there are compilation issues
    print('Done.')
    print('Fetching utxos and setting up brige node and initial state...')
    # Copy genesis state.json into the output directory
    # also read the program_length from program.json
    # and add it to the state.json
    f = open('src/chain_proof/state_0.json')
    initial_state = json.load(f)

    # Fetch the next block.
    block = fetch_block(block_height)

    initial_state['block_height'] = block_height - 1
    initial_state['best_block_hash'] = block['previousblockhash']
    initial_state['utreexo_roots'] = setup_bridge_node(block_height)
    initial_state['current_target'] = block['bits']

    with open(f'{output_dir}/program.json') as f:
        program = json.load(f)
        initial_state['program_length'] = len(program['data'])

    with open(f'{output_dir}/chain_state.json', 'w') as outfile:
        outfile.write(json.dumps(initial_state))

    chain_state_file = f'{output_dir}/chain_state.json'
    print('Done.')

    print('Next up is the cairo runner.')

    # Change the runner command here if you need the pprof trace
    # Note: Using --profile_output significantly increases the time spent in
    # the runner
    # Run the Cairo runner (without pprof trace)
    cmd = f'cairo-run --program={output_dir}/program.json --layout=all --print_info --print_output --program_input={chain_state_file} --trace_file={output_dir}/trace.bin --memory_file={output_dir}/memory.bin'

    # Run the Cairo runner (with pprof trace)
    # cmd = f'cairo-run --program={output_dir}/program.json --layout=all --print_info --print_output --program_input={chain_state_file} --trace_file={output_dir}/trace.bin --memory_file={output_dir}/memory.bin --profile_output={output_dir}/profile.pb.gz'

    start_time = time.clock_gettime(time.CLOCK_REALTIME)
    program_output_string = os.popen(cmd).read()
    total_time = time.clock_gettime(time.CLOCK_REALTIME) - start_time

    print(program_output_string)  # User can check if everything worked

    print(
        f'RUNNER_TIME: {total_time} -> {str(datetime.timedelta(seconds=total_time))}\n')

    # Run Giza prover
    cmd = f'giza prove --trace={output_dir}/trace.bin --memory={output_dir}/memory.bin --program={output_dir}/program.json --output={output_dir}/proof.bin --num-outputs=50 --fri-folding-factor=8'
    start_time = time.clock_gettime(time.CLOCK_REALTIME)
    program_output_string = os.popen(cmd).read()
    total_time = time.clock_gettime(time.CLOCK_REALTIME) - start_time

    print(program_output_string)
    print(
        f'PROVER_TIME: {total_time} -> {str(datetime.timedelta(seconds=total_time))}\n')

    print(
        f'MAXIMUM_USED_RAM: {resource.getrusage(resource.RUSAGE_CHILDREN)[2]/10**6:.2f} GB')
