# This contains the benchmark cases for the cairo-runner
# Cairo vm runtime is measured from within the python wrapper and apart
# from that only includes the time it takes for the subprocess to start

# Note that I assume the bitcoin chain will not change and collect the
# blocks from a running bitcoin client.
# WARNING: THIS CAN LEAD TO DIFFERENT INPUTS WHEN THE CLIENT SWITCHED
# BETWEEN TESTNET AND MAINNET OR THE CHAIN TIP IS USED.

import sys
import atexit
import csv
from prettytable import PrettyTable
from lib.benchmark_lib import benchmarkInit, benchmarkBatches


# Imitating the ctx object from click allows to share code base
class Ctx:
    obj = {}


# CAN CHANGE/ADD THE BATCHES TO TEST HERE
smallBatches = [(1, 3), (2015, 2017)]
mediumBatches = [(1, 21), (2015, 2035)]
largeBatches = [(1, 252), (2015, 2266)]

# list of lists of batches - the bigger the batch the farther at the end of the list
# one can decide to only run the first x batches
batches = [smallBatches, mediumBatches, largeBatches]

results = []
resTable = PrettyTable()
resTable.field_names = [
    "start",
    "end",
    "time (s)",
    "memory (KB)",
    "steps",
    "cells"]


def printResults():
    print()
    print(
        resTable.get_string(
            fields=[
                "start",
                "end",
                "time (s)",
                "memory (KB)",
                "steps",
                "cells",
            ]))


# If the program is stopped still output the results up to this point
atexit.register(printResults)

ctx = Ctx()
ctx.obj = benchmarkInit()


# no command-line option given -> run all batches and do not output csv
batchesToRun = len(batches)
if len(sys.argv) >= 2:
    if int(sys.argv[1]) <= batchesToRun:
        batchesToRun = int(sys.argv[1])
    else:
        print("WARNING: There are not as many batch sets as you specified to run. Running all batch sets now.")

for i in range(0, batchesToRun):
    print(
        f"\rRunning batch set {i + 1}/{batchesToRun}... (batch size increases with every batch set)",
        end="")
    results = benchmarkBatches(ctx, batches[i])
    resTable.add_rows(results)


if len(sys.argv) == 3:
    with open(sys.argv[2], 'w') as resFile:
        wr = csv.writer(resFile)
        wr.writerow(("start", "end", "time", "memory", "steps", "cells"))
        wr.writerows(results)