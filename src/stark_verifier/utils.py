import json
import subprocess

PWD = subprocess.run(['pwd'],capture_output=True).stdout[:-1].decode("utf-8")
PROOF_PATH = f'{PWD}/tests/integration/stark_proofs/fibonacci.bin'
PARSER_PATH = f'{PWD}/bin/stark_parser'
PRIME = 2**251 + 17 * 2**192 + 1


def set_proof_path(proof_path):
    global PROOF_PATH
    PROOF_PATH = f'{PWD}/{proof_path}'

def write_into_memory(ptr, json_data, segments):
    addr = ptr
    if hasattr(ptr, 'address_'):
        addr = ptr.address_
        
    my_array = json.loads(json_data)
    # Note the following:
    # - Addresses are stored as `Relocatable` values in the Cairo VM.
    # - The "+" operator is overloaded to perform pointer arithmetics.
    # - Felts are hex encoded starting with "0x". The virtual addresses are encoded as decimals.
    my_memory = [(int(x, 16) if x.startswith('0x') else addr + int(x)) for x in my_array]
    segments.write_arg(addr, my_memory)


def index_of(elements_ptr, n_elements, element, memory):
    for i in range(n_elements):
        if( memory[elements_ptr + i] == element):
            return i
    return PRIME-1


def to_json_array(arr_ptr, arr_length, memory):
    arr = []
    for i in range(arr_length):
        arr.append( memory[arr_ptr + i] )
    return json.dumps( arr )


def read_fri_queries_proofs(positions_ptr, fri_queries_proof_ptr, num_queries, memory, segments):
    positions = to_json_array(positions_ptr, num_queries, memory)

    completed_process = subprocess.run(
        [ PARSER_PATH, PROOF_PATH, 'fri-queries', positions],
        capture_output=True)

    json_data = completed_process.stdout
    write_into_memory(fri_queries_proof_ptr, json_data, segments)



def read_queried_trace_states(positions_ptr, trace_queries_proof_ptr, num_queries, memory, segments):
    positions = to_json_array(positions_ptr, num_queries, memory)
    completed_process = subprocess.run(
        [PARSER_PATH, PROOF_PATH, 'trace-queries', positions],
        capture_output=True)
    
    json_data = completed_process.stdout
    write_into_memory(trace_queries_proof_ptr, json_data, segments)



def read_constraint_evaluations(positions_ptr, constraint_queries_proof_ptr, num_queries, memory, segments):
    positions = to_json_array(positions_ptr, num_queries, memory)

    completed_process = subprocess.run(
        [PARSER_PATH, PROOF_PATH, 'constraint-queries', positions],
        capture_output=True)
    
    json_data = completed_process.stdout
    write_into_memory(constraint_queries_proof_ptr, json_data, segments)




def interpolate_poly(xs_ptr, ys_ptr, n_points, polynomial_ptr, memory):
    xs = []
    for i in range(n_points):
        xs.append(hex( memory[xs_ptr + i])[2::].zfill(64) )
    xs = json.dumps( xs )

    ys = []
    for i in range(n_points):
        ys.append(hex( memory[ys_ptr + i])[2::].zfill(64) )
    ys = json.dumps( ys )

    completed_process = subprocess.run(
        [ PARSER_PATH, PROOF_PATH, 'interpolate-poly', xs, ys],
        capture_output = True)
    serialized_poly = str(completed_process.stdout).replace("\\n'", "")
    polynomial = serialized_poly.split(', ')[1:]
    for i, coefficient in enumerate(polynomial):
        memory[polynomial_ptr + i] = int(coefficient, 16)


def read_stark_proof(proof_ptr, segments):
    completed_process = subprocess.run(
        [ PARSER_PATH, PROOF_PATH, 'proof'],
        capture_output=True)
    json_data = completed_process.stdout
    write_into_memory(proof_ptr, json_data, segments)


def read_public_inputs(pub_inputs_ptr, segments):
    completed_process = subprocess.run(
        [ PARSER_PATH, PROOF_PATH, 'public-inputs'],
        capture_output=True)
    if completed_process.returncode != 0:
        raise Exception(completed_process)
    json_data = completed_process.stdout
    write_into_memory(pub_inputs_ptr, json_data, segments)



def debug_print(string):
    f = open("debug-log.txt", "a")
    f.write(f"{string}\n")
    f.close()