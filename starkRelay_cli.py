import click
import toml
from wrapper.btcrpc import checkClientRunning
from wrapper.cairo import (
        createGizaProof,
        formatCairoOutput,
        runCairo,
        runCairoBenchmark,
        runCairoPrintInfo,
        submitSharp,
        compileCairo
        )
from wrapper.preprocessing import dumpCairoInput, dumpMerkleProofInput
import os

INIT_WORK_DIR = "work/"
VALIDATE_PROG = "validate_compiled.json"
MERKLE_PROG = "merkle_proof_compiled.json"

@click.group()
@click.option(
        "--configfile",
        default=INIT_WORK_DIR + "starkRelay.toml",
        help="Config for starkRelay - used for bitcoin RPC",
        show_default=True,
        )
@click.option(
        "--source",
        default="cairo/src",
        help="Source directory of the Cairo programs",
        )
@click.option(
        "--force-compile",
        "-c",
        default=False,
        show_default=True,
        is_flag=True,
        help="Force to recompile all Cairo sources."
        )
@click.pass_context
def starkRelay_cli(ctx, configfile, source, force_compile):

    if not os.path.exists(configfile):
        while (1):
            newConf = input("No config file found.\nDo you want to create a new one in "
                    + "'" 
                    + os.getcwd()
                    + "/" 
                    + INIT_WORK_DIR
                    + "'? [y/N]:" ) or "N"
            if newConf.lower() == "y":
                break
            if newConf.lower() == "n":
                exit(0)
        
        print("Provide Bitcoin-client RPC information.")
        host = input("Host [localhost]: ") or "localhost"
        port = input("Port [8332]: ") or "8332"
        user = input("User: ")
        psw = input("Password: ")
        print("starkRelay will create a working directory for compiled cairo programs and program traces.")
        workDir = (input("Working directory path [./work/]: ") or "work") + "/"
        os.makedirs(workDir)
        workDir = os.path.abspath(workDir) + "/"
        config =  {
                "title" : "starkRelay config file",
                "btc-client" : {
                    "host" : host,
                    "port" : port,
                    "user" : user,
                    "psw"  : psw
                    },
                "work" : {
                    "dir" : workDir
                    }
                }
        with open(configfile, 'w+') as f:
            print(toml.dumps(config), file=f)
    
    ctx.obj = toml.load(configfile)
    ctx.ensure_object(dict)
    if not os.path.exists(ctx.obj['work']['dir']):
        print("No working directory set up... creating new one at " + ctx.obj['work']['dir'])
        os.makedirs(ctx.obj['work']['dir'])
    workDir = ctx.obj['work']['dir']
    
    if (not os.path.exists(source) and not (os.path.exists(workDir + VALIDATE_PROG) or not os.path.exists(workDir + MERKLE_PROG))):
        source = os.path.abspath(source)
        print("ERROR: Source directory " + source + " does not exist. Specify a source directory using --source.")
        exit(3)
    validateSrcFile = source + "/validate.cairo"
    merkleSrcFile = source + "/merkle_proof.cairo"
    #compile the files and store in our work_dir
    if not os.path.exists(workDir + VALIDATE_PROG) or force_compile:
        print("Compiling " + validateSrcFile + "...")
        if not compileCairo(validateSrcFile, workDir + VALIDATE_PROG):
            print("ERROR: Unable to compile validate source file.")
            exit(1)
        print("Done.")
    if not os.path.exists(workDir + MERKLE_PROG) or force_compile:
        print("Compiling " + merkleSrcFile + "...")
        if not compileCairo(merkleSrcFile,  workDir + MERKLE_PROG):
            print("ERROR: Unable to compile merkleProof source file.")
            exit(2)
        print("Done.")

    if not checkClientRunning(ctx):
        print("Warning: There might be no accessible bitcoin-client running")
    ctx.obj['validate'] = workDir + VALIDATE_PROG
    ctx.obj['merkle'] = workDir + MERKLE_PROG
    return ctx


@click.argument("batchrange")
@click.option(
        "--raw",
        "-r",
        is_flag=True,
        show_default=True,
        default=False,
        help="Get raw Cairo-runner output",
        )
@click.option(
        "--info",
        "-i",
        is_flag=True,
        show_default=True,
        default=False,
        help="Print info instead of output",
        )
@click.option(
        "--submit",
        "-s",
        is_flag=True,
        show_default=True,
        default=False,
        help="Submit the proof via SHARP",
        )
@click.option(
        "giza_prove",
        "--giza-prove",
        "-g",
        is_flag=True,
        show_default=True,
        default=False,
        help="Create a STARK proof with giza",
        )
@starkRelay_cli.command("validate-batch")
@click.pass_context
def validateBatch(ctx, batchrange, submit, raw, info, giza_prove):
    """This validates blocks in the range BATCHRANGE using the provided compiled CAIROPROGRAM. Range includes the starting and ending block number and consists of two block numbers seperated by '-', e.g.: 1-10"""
    start = int(batchrange.split("-")[0])
    end = int(batchrange.split("-")[1]) + 1
    ctx.obj['inputFile'] = ctx.obj['work']['dir'] + "validateInput_" + batchrange + ".json"
    dumpCairoInput(ctx, start, end)
    if info:
        cairoOutput = runCairoPrintInfo(cairoProg=ctx.obj['validate'], inputFile=ctx.obj['inputFile'])
    else:
        cairoOutput = runCairo(
                cairoProg=ctx.obj['validate'],
                inputFile=ctx.obj['inputFile'],
                traceFile=ctx.obj['work']['dir'] + "trace_" + batchrange + ".bin",
                memoryFile=ctx.obj['work']['dir'] + "memory_" + batchrange + ".bin",
                )
    if raw or info:
        print(cairoOutput)
    else:
        print(formatCairoOutput(cairoOutput))
    if submit:
        submitSharp(ctx.obj['validate'])
    if giza_prove:
        result, time, memory = createGizaProof(
                compiledProgram=ctx.obj['validate'],
                traceFile=ctx.obj['work']['dir'] + "trace_" + batchrange + ".bin",
                memoryFile=ctx.obj['work']['dir'] + "memory_" + batchrange + ".bin",
                outputFile=ctx.obj['work']['dir'] + "prove_" + batchrange + ".bin",
                outputNum=66,
                )
        print(result)
        print(f"Giza prove generation took {time} seconds and {memory} KB.")


@click.argument("batchrange")
@click.argument("intermediary-index")
@click.option(
        "--raw",
        "-r",
        is_flag=True,
        show_default=True,
        default=False,
        help="Get raw Cairo output",
        )
@click.option(
        "--submit",
        "-s",
        is_flag=True,
        show_default=True,
        default=False,
        help="Submit the proof via sharp",
        )
@click.option(
        "giza_prove",
        "--giza-prove",
        "-g",
        is_flag=True,
        show_default=True,
        default=False,
        help="Create a STARK proof with giza",
        )
@starkRelay_cli.command("merkle-proof")
@click.pass_context
def merkleProof(
        ctx, batchrange, intermediary_index, raw, submit, giza_prove
        ):
    start = int(batchrange.split("-")[0])
    end = int(batchrange.split("-")[1]) + 1
    ctx.obj['inputFile'] = ctx.obj['work']['dir'] + "merkleInput_" + batchrange + ".json"
    dumpMerkleProofInput(ctx, start, end, int(intermediary_index))
    cairoOutput = runCairo(
            cairoProg=ctx.obj['merkle'],
            inputFile=ctx.obj['inputFile'],
            traceFile=ctx.obj['work']['dir'] + "merkle_trace_" + batchrange + ".bin",
            memoryFile=ctx.obj['work']['dir'] + "merkle_memory_" + batchrange + ".bin",
            )
    if raw:
        print(cairoOutput)
    else:
        print(formatCairoOutput(cairoOutput))
    if submit:
        submitSharp(ctx.obj['merkle'])
    if giza_prove:
        result, time, memory = createGizaProof(
                compiledProgram=ctx.obj['merkle'],
                traceFile=ctx.obj['work']['dir'] + "merkle_trace_" + batchrange + ".bin",
                memoryFile=ctx.obj['work']['dir'] + "merkle_memory_" + batchrange + ".bin",
                outputFile=ctx.obj['work']['dir'] + "merkle_prove_" + batchrange + ".bin",
                outputNum=23,
                )
        print(result)
        print(f"Giza prove generation took {time} seconds and {memory} KB.")
