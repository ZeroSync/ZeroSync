from wrapper.preprocessing import (
    dumpCairoInput,
    dumpMerkleProofInput
)

from wrapper.cairo import(
    runCairoBenchmark,
    formatCairoOutput,
)

from wrapper.setup import ctxConfigSetup


# fills the config with likely values
# they can still be overwritten
# different setup can be used by calling ctxConfigSetup directly
# TODO remove .. from the paths when the benchmark scripts location is known
def benchmarkInit():
    return ctxConfigSetup("../../work/starkRelay.toml", "../../cairo", False)


def benchmarkBatch(ctx, batchStart, batchEnd):
    dumpCairoInput(ctx, batchStart, batchEnd)
    cairoOutput, secs, memory = runCairoBenchmark(
        cairoProg=ctx.obj['cairoProgram'], inputFile=ctx.obj['inputFile']
    )
    if [line for line in cairoOutput.split("\n")][
        0
    ] != "Program output:":  # check first line is not an error output
        print("Error: Cairo program errored:", file=STDERR)
        print(cairoOutput, file=STDERR, flush=True)
    else:
        return (
            batchStart,
            batchEnd - 1,
            secs,
            memory,
            formatCairoOutput(cairoOutput))


# batches is a list of tuples (start, end)
# results are returned in a list of tuples for each batch - None if the
# batch errored
def benchmarkBatches(ctx, batches):
    results = []
    for batch in batches:
        results.append(benchmarkBatch(ctx, batch[0], batch[1]))
    return results


def benchmarkWindowOfBatches(ctx, initBatchStart, batchSize, n, step):
    """Repeats the Benchmark for the given Batchsize [n] times with the starting block number increased by [STEP] each time, e.g.: 1-10, 11-20, 21-30,... for a step size of 10 (Batches can overlap)"""
    batches = [
        (x *
         step +
         initBatchStart,
         x *
         step +
         initBatchStart +
         batchSize) for x in range(n)]
    return benchmarkBatches(ctx, batches)


def benchmarkMerkleProof(
    ctx, batchStart, batchEnd, intermediaryIndex
):

    cairoprogram = obj.ctx['cairoProgram']
    inputfile = obj.ctx['inputFile']
    dumpMerkleProofInput(ctx, batchStart, batchEnd, intermediaryIndex)
    cairoOutput, secs, memory = runCairoBenchmark(
        cairoProg=cairoprogram, inputFile=inputfile
    )
    if [line for line in cairoOutput.split("\n")][
        0
    ] != "Program output:":  # check first line is not an error output
        print("Error: Cairo program errored:", file=STDERR)
        print(cairoOutput, file=STDERR, flush=True)
    else:
        return (
            batchStart,
            batchEnd - 1,
            secs,
            memory,
            formatCairoOutput(cairoOutput))
