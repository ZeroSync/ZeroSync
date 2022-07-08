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
)
from wrapper.preprocessing import dumpCairoInput, dumpMerkleProofInput
import os

TMP_DIR = "tmp_work/"


@click.group()
@click.option(
    "--configfile",
    default="conf/starkRelay.toml",
    help="Config for starkRelay - used for bitcoin RPC",
    show_default=True,
)
@click.pass_context
def starkRelay_cli(ctx, configfile):
    ctx.obj = toml.load(configfile)
    if not os.path.exists(TMP_DIR):
        os.makedirs(TMP_DIR)
    if not checkClientRunning(ctx):
        print("Warning: There might be no accesible bitcoin-client running")
    return ctx


@click.argument("cairoprogram")
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
def validateBatch(ctx, cairoprogram, batchrange, submit, raw, info, giza_prove):
    """This validates blocks in the range BATCHRANGE using the provided compiled CAIROPROGRAM. Range includes the starting and ending block number and consists of two block numbers seperated by '-', e.g.: 1-10"""
    start = int(batchrange.split("-")[0])
    end = int(batchrange.split("-")[1]) + 1
    inputfile = TMP_DIR + "validateInput_" + batchrange + ".json"
    dumpCairoInput(ctx, inputfile, start, end)
    if info:
        cairoOutput = runCairoPrintInfo(cairoProg=cairoprogram, inputFile=inputfile)
    else:
        cairoOutput = runCairo(
            cairoProg=cairoprogram,
            inputFile=inputfile,
            traceFile=TMP_DIR + "trace_" + batchrange + ".bin",
            memoryFile=TMP_DIR + "memory_" + batchrange + ".bin",
        )
    if raw or info:
        print(cairoOutput)
    else:
        print(formatCairoOutput(cairoOutput))
    if submit:
        submitSharp(cairoprogram)
    if giza_prove:
        result, time, memory = createGizaProof(
            compiledProgram=cairoprogram,
            traceFile=TMP_DIR + "trace_" + batchrange + ".bin",
            memoryFile=TMP_DIR + "memory_" + batchrange + ".bin",
            outputFile=TMP_DIR + "prove_" + batchrange + ".bin",
            outputNum=66,
        )
        print(result)
        print(f"Giza prove generation took {time} seconds and {memory} KB.")


@click.argument("cairoprogram")
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
    ctx, cairoprogram, batchrange, intermediary_index, raw, submit, giza_prove
):
    start = int(batchrange.split("-")[0])
    end = int(batchrange.split("-")[1]) + 1
    inputfile = TMP_DIR + "merkleInput_" + batchrange + ".json"
    dumpMerkleProofInput(ctx, inputfile, start, end, int(intermediary_index))
    cairoOutput = cairoOutput = runCairo(
        cairoProg=cairoprogram,
        inputFile=inputfile,
        traceFile=TMP_DIR + "merkle_trace_" + batchrange + ".bin",
        memoryFile=TMP_DIR + "merkle_memory_" + batchrange + ".bin",
    )
    if raw:
        print(cairoOutput)
    else:
        print(formatCairoOutput(cairoOutput))
    if submit:
        submitSharp(cairoprogram)
    if giza_prove:
        result, time, memory = createGizaProof(
            compiledProgram=cairoprogram,
            traceFile=TMP_DIR + "merkle_trace_" + batchrange + ".bin",
            memoryFile=TMP_DIR + "merkle_memory_" + batchrange + ".bin",
            outputFile=TMP_DIR + "merkle_prove_" + batchrange + ".bin",
            outputNum=23,
        )
        print(result)
        print(f"Giza prove generation took {time} seconds and {memory} KB.")
