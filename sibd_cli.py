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
from wrapper.preprocessing import dumpCairoInput
from wrapper.setup import ctxConfigSetup, INIT_WORK_DIR, VALIDATE_PROG
import os

# Outputs of the validate program used to create a giza proof
VALIDATE_OUTPUTS = 65


@click.group()
@click.option(
    "--configfile",
    default=INIT_WORK_DIR + "sibd.toml",
    help="Config for sibd - used for bitcoin RPC and Cairo sources",
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
def sibd_cli(ctx, configfile, source, force_compile):
    ctx.obj = ctxConfigSetup(configfile, source, force_compile)
    if not checkClientRunning(ctx):
        print("Warning: There might be no accessible bitcoin-client running")
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
@sibd_cli.command("validate-batch")
@click.pass_context
def validateBatch(ctx, batchrange, submit, raw, info, giza_prove):
    """This validates blocks in the range BATCHRANGE using the provided compiled CAIROPROGRAM. Range includes the starting and ending block number and consists of two block numbers seperated by '-', e.g.: 1-10"""
    start = int(batchrange.split("-")[0])
    end = int(batchrange.split("-")[1]) + 1
    ctx.obj['inputFile'] = ctx.obj['work']['dir'] + \
        "validateInput_" + batchrange + ".json"
    dumpCairoInput(ctx, start, end)
    if info:
        cairoOutput = runCairoPrintInfo(
            cairoProg=ctx.obj['validate'],
            inputFile=ctx.obj['inputFile'])
    else:
        cairoOutput = runCairo(
            cairoProg=ctx.obj['validate'],
            inputFile=ctx.obj['inputFile'],
            traceFile=ctx.obj['work']['dir'] +
            "trace_" +
            batchrange +
            ".bin",
            memoryFile=ctx.obj['work']['dir'] +
            "memory_" +
            batchrange +
            ".bin"
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
            outputNum=VALIDATE_OUTPUTS,
        )
        print(result)
        print(f"Giza prove generation took {time} seconds and {memory} KB.")
