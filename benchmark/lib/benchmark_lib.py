from wrapper.preprocessing import (
    dumpCairoInput,
)

from wrapper.cairo import(
    runCairoBenchmark,
    formatCairoOutput,
    createGizaProof
)

from wrapper.setup import ctxConfigSetup
import sys

# fills the config with likely values
# they can still be overwritten
# different setup can be used by calling ctxConfigSetup directly


def benchmarkInit():
    return ctxConfigSetup("../work/sibd.toml", "../cairo/src", False)


def benchmarkBatch(ctx, batchStart, batchEnd):
    ctx.obj['inputFile'] = ctx.obj['work']['dir'] + \
        "validateInput_" + str(batchStart) + "-" + str(batchEnd) + ".json"
    dumpCairoInput(ctx, batchStart, batchEnd + 1)
    cairoOutput, secs, memory, steps, cells = runCairoBenchmark(
        cairoProg=ctx.obj['validate'], inputFile=ctx.obj['inputFile'], traceFile=ctx.obj['traceFile'], memoryFile=ctx.obj['memoryFile'])
    firstLine = [line for line in cairoOutput.split("\n")][0]
    # check first line is not an error output
    if firstLine != "Program output:" and firstLine[0:15] != "Number of steps":
        print("Error: Cairo program errored:", file=sys.stderr)
        print(cairoOutput, file=sys.stderr, flush=True)
    else:
        return (
            batchEnd + 1 - batchStart,
            batchStart,
            batchEnd,
            round(secs, 4),
            memory,
            steps,
            cells,
        )


# batches is a list of tuples (start, end)
# results are returned in a list of tuples for each batch - None if the
# batch errored
def benchmarkBatches(ctx, batches):
    results = []
    for batch in batches:
        ctx.obj['traceFile'] = ctx.obj["validate"].replace(
            ".json", f"{batch[0]}_{batch[1]}_trace.bin")
        ctx.obj['memoryFile'] = ctx.obj["validate"].replace(
            ".json", f"{batch[0]}_{batch[1]}_memory.bin")
        results.append(benchmarkBatch(ctx, batch[0], batch[1]))
    return results


def benchmarkProofGenBatch(ctx, batchStart, batchEnd):
    result = createGizaProof(
        ctx.obj['traceFile'],
        ctx.obj['memoryFile'],
        ctx.obj['validate'],
        "/dev/null",
        65)
    return (
        batchEnd + 1 - batchStart,
        batchStart,
        batchEnd,
        round(result[1], 4),
        result[2])


def benchmarkProofGenBatches(ctx, batches):
    results = []
    for batch in batches:
        ctx.obj['traceFile'] = ctx.obj["validate"].replace(
            ".json", f"{batch[0]}_{batch[1]}_trace.bin")
        ctx.obj['memoryFile'] = ctx.obj["validate"].replace(
            ".json", f"{batch[0]}_{batch[1]}_memory.bin")
        results.append(benchmarkProofGenBatch(ctx, batch[0], batch[1]))
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
