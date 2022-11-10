import json
import subprocess

def cairo_compile(path):
    "Compile from Cairo source code"
    dirname, filename = path
    completed_process = subprocess.run([
        'cairo-compile', f'{dirname}{filename}.cairo',
        '--cairo_path', 'src',
        '--output', f'tests/cairo_programs_compiled/{filename}.json'])
    assert completed_process.returncode == 0

def cairo_run(program_name):
    "Generate register and memory output from running the program"
    completed_process = subprocess.run([
        'cairo-run',
		'--layout', 'all',
        '--program', f'tests/cairo_programs_compiled/{program_name}.json',
        '--trace_file', f'tests/cairo_programs_trace/{program_name}/trace.bin', 
        '--memory_file', f'tests/cairo_programs_trace/{program_name}/memory.bin'])

def giza_prove(program_name):
    "Generate a proof of the program execution"
    completed_process = subprocess.run([
        'giza', 'prove',
        '--program', f'tests/cairo_programs_compiled/{program_name}.json',
        '--trace', f'tests/cairo_programs_trace/{program_name}/trace.bin',
        '--memory', f'tests/cairo_programs_trace/{program_name}/memory.bin',
        '--output', f'tests/stark_proofs/{program_name}.bin'])

def parse_proof(program_name):
    completed_process = subprocess.run([
        'src/stark_verifier/parser/target/debug/parser',
        f'tests/stark_proofs/{program_name}.bin',
        'proof'],
        capture_output=True)
    return json.loads(completed_process.stdout)

def parse_public_inputs(program_name):
    completed_process = subprocess.run([
        'src/stark_verifier/parser/target/debug/parser',
        f'tests/stark_proofs/{program_name}.bin',
        'public-inputs'],
        capture_output=True)
    return json.loads(completed_process.stdout)

def setup(path):
    cairo_compile(path)
    cairo_run(path[1])
    giza_prove(path[1])
