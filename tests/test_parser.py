import pytest
import subprocess

@pytest.fixture(autouse=True)
def setup(cairo_compile, cairo_run, giza_prove):
    # TODO: Ensure fixtures are called serially, and only once
    pass

@pytest.fixture(params=[
    ("src/stark_verifier/", "stark_verifier"),
    ("tests/cairo_programs/", "fibonacci")])
def cairo_compile(request):
    """
    Compile from Cairo source code
    """
    dirname, filename = request.param
    completed_process = subprocess.run([
        'cairo-compile', dirname + filename + '.cairo',
        '--cairo_path', 'src',
        '--output', 'tests/cairo_programs_compiled/' + filename + '.json'])
    assert completed_process.returncode == 0

@pytest.fixture(params=[
    "stark_verifier",
    "fibonacci"])
def cairo_run(request):
    """
    Generate register and memory output from running the program
    """
    filename = request.param
    completed_process = subprocess.run([
        'cairo-run',
		'--layout', 'all',
        '--program', 'tests/cairo_programs_compiled/' + filename + '.json',
        '--trace_file', 'tests/cairo_programs_trace/%s/trace.bin' % filename, 
        '--memory_file', 'tests/cairo_programs_trace/%s/memory.bin' % filename])
    assert completed_process.returncode == 0

@pytest.fixture(params=["fibonacci"])
def giza_prove(request):
    filename = request.param
    completed_process = subprocess.run([
        'giza', 'prove',
        '--program', 'tests/cairo_programs_compiled/' + filename + '.json',
        '--trace', 'tests/cairo_programs_trace/' + filename + '/trace.bin',
        '--memory', 'tests/cairo_programs_trace/' + filename + '/memory.bin',
        '--output', 'tests/stark_proofs/' + filename + '.bin'])

def test_proof_parsing():
    # TODO
    pass
