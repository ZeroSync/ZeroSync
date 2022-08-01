import os
import subprocess
import resource
import time
import sys

P = 2**251 + 17 * 2**192 + 2


def compileCairo(src, output):
    # switch into the directory of src because of dependencies
    originalPath = os.getcwd()
    outputFile = os.path.abspath(output)
    abspath = os.path.abspath(src)
    dname = os.path.dirname(abspath)
    os.chdir(dname)
    program = f"cairo-compile {abspath} --output {outputFile}".split(" ")
    proc = subprocess.run(program)
    os.chdir(originalPath)
    if proc.returncode != 0:
        return False
    return True


def runCairo(cairoProg, inputFile, traceFile, memoryFile):
    program = f"cairo-run --program={cairoProg} --layout=all --print_output --program_input={inputFile} --memory_file={memoryFile} --trace_file={traceFile} --cairo_pie_output={cairoProg.replace('.json','') + '.pie'}".split(
        " "
    )
    proc = subprocess.run(program, stdout=subprocess.PIPE)
    return proc.stdout.decode("utf-8")


def runCairoPrintInfo(cairoProg, inputFile):
    program = f"cairo-run --program={cairoProg} --layout=all --print_info --program_input={inputFile} --cairo_pie_output={cairoProg.replace('.json','') + '.pie'}".split(
        " "
    )
    proc = subprocess.run(program, stdout=subprocess.PIPE)
    return proc.stdout.decode("utf-8")


def submitSharp(cairoProg):
    program = f"cairo-sharp submit --cairo_pie {cairoProg.replace('.json','') + '.pie'}".split(
        " ")
    print(program)
    proc = subprocess.run(program, stdout=subprocess.PIPE)
    print(proc.stdout.decode("utf-8"))
    return


def createGizaProof(
        traceFile,
        memoryFile,
        compiledProgram,
        outputFile,
        outputNum):
    startTime = time.time()
    program = f"giza prove --trace={traceFile} --memory={memoryFile} --program={compiledProgram} --output={outputFile} --num-outputs={outputNum}".split(
        " "
    )
    proc = subprocess.run(program, stdout=subprocess.PIPE)
    result = proc.stdout.decode("utf-8")
    endTime = time.time()

    # index 2 is maximum resident set size in KBytes:
    # https://docs.python.org/3/library/resource.html#resource.getrusage
    memory = resource.getrusage(resource.RUSAGE_CHILDREN)
    return result, endTime - startTime, memory[2]


def formatCairoOutput(output):
    retStr = "["
    lines = [x for x in output.split("\n")[1::] if x != " " and x != ""]
    for x in lines[:-1]:
        retStr += f'"{int(x) if int(x) >= 0 else ((int(x) + P) % P)}",'
    retStr += (
        f'"{int(lines[-1]) if int(lines[-1]) >= 0 else ((int(lines[-1]) + P) % P)}"]'
    )
    return retStr


def runCairoBenchmark(cairoProg, inputFile):
    startTime = time.time()
    result = runCairo(cairoProg, inputFile, "/dev/null", "/dev/null")
    endTime = time.time()
    # index 2 is maximum resident set size in KBytes:
    # https://docs.python.org/3/library/resource.html#resource.getrusage
    memory = resource.getrusage(resource.RUSAGE_CHILDREN)
    return result, endTime - startTime, memory[2]
