import argparse
import json
import os
import struct
import subprocess
import time
import urllib3

parser = argparse.ArgumentParser(description='Generate a chain proof')
parser.add_argument('--output_dir', type=str, default='tmp')
args = parser.parse_args()

P = 2**251 + 17 * 2**192 + 1
NUM_OUTPUTS = 51
FOLDING_FACTOR = 8
COMPILED_PROGRAM = "build/headers_chain_proof_compiled.json"


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


#############################
# CONFIGURE PARAMETER HERE
# start_bklock_height is overwritten by block_height in
# headers_chain_state.json if it exists
start_block_height = 0
batches = 100
batch_size = 4      # Will overwrite batch_size in headers_chain_state.json
#############################

output_dir = args.output_dir
os.popen(f'mkdir -p {output_dir}')

# Check if output_dir includes a heades_chain_state.json already
if os.path.isfile(f'{output_dir}/headers_chain_state.json'):
    f = open(f'{output_dir}/headers_chain_state.json')
    state = json.load(f)
    start_block_height = state['block_height'] + 1
    state['batch_size'] = batch_size
    f.close()
    with open(f'{output_dir}/headers_chain_state.json', 'w') as outfile:
        outfile.write(json.dumps(state))
else:
    # Copy genesis state.json into the output directory
    f = open('src/headers_chain_proof/state_0.json')
    genesis_state = json.load(f)

    # Read the program_length from COMPILED_PROGRAM and update
    # it in the genesis state
    f = open(COMPILED_PROGRAM)
    program = json.load(f)
    genesis_state['program_length'] = len(program['data'])
    # TODO: compute program hash and write it into chain_state.json
    #genesis_state['program_hash'] = SOMECALCULATEDVALUE
    genesis_state['batch_size'] = batch_size
    with open(f'{output_dir}/headers_chain_state.json', 'w') as outfile:
        outfile.write(json.dumps(genesis_state))

chain_state_file = f'{output_dir}/headers_chain_state.json'

# The first Bitcoin TX ever occurred in block 170. The second TX occurred in
# block 181.
for i in range(start_block_height, batches * batch_size, batch_size):
    print(f'\n === Processing block height {i} to {i + batch_size - 1} ===')
    # Fill the bridge_node
    print(f'Step 0: Setup headers bridge_node...')
    http = urllib3.PoolManager()
    url = 'http://localhost:2122/reset/'
    r = http.request('GET', url)
    url = f'http://localhost:2122/create/{i}'
    r = http.request('GET', url)
    response = json.loads(r.data)
    assert response['status'] == 'success'

    # Run the Cairo runner
    print(f'Step 1: Cairo runner...')
    start_time = time.time()
    cmd = f'cairo-run                           \
            --program={COMPILED_PROGRAM} \
            --layout=all                        \
            --print_output                      \
            --program_input={chain_state_file}  \
            --trace_file={output_dir}/trace.bin \
            --memory_file={output_dir}/memory.bin'
    program_output_string = os.popen(cmd).read()
    program_output = parse_cairo_output(program_output_string, True)
    print(f'Running time: { int(time.time()-start_time) } seconds\n')

    # Parse outputs
    try:
        r = FeltsReader(program_output)
        chain_state = {
            'block_height': r.read(),
            'best_block_hash': felts_to_hash(r.read_n(8)),
            'total_work': r.read(),
            'current_target': r.read(),
            'prev_timestamps': r.read_n(11),
            'epoch_start_time': r.read(),
            'batch_size': batch_size,
            'mmr_roots': felts_to_hex(r.read_n(27)),
            'program_hash': hex(r.read())
        }
        # Write the chain state into a json file
        f = open(f'{output_dir}/headers_chain_state.json', 'w')
        f.write(json.dumps(chain_state, indent=2))
        f.close()
    except BaseException:
        print(program_output_string)

    # Run Giza prover
    print(f"Step 2: Giza prover...")
    start_time = time.time()
    cmd = f'giza prove                          \
            --trace={output_dir}/trace.bin      \
            --memory={output_dir}/memory.bin    \
            --program={COMPILED_PROGRAM} \
            --output={output_dir}/headers_chain_proof-{i + batch_size - 1}.bin \
            --num-outputs={NUM_OUTPUTS} \
            --fri-folding-factor={FOLDING_FACTOR}'
    return_code = subprocess.call(cmd, shell=True)
    if return_code == 0:
        print(f'Proving time: { int(time.time()-start_time) } seconds')
        print(f'Done proving chain_proof-{i + batch_size - 1}\n')
    else:
        print(f'Proving failed. Error code: {return_code}\n')
