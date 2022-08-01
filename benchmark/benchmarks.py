# This contains the benchmark cases for the cairo-runner
# Cairo vm runtime is measured from within the python wrapper and apart
# from that only includes the time it takes for the subprocess to start

# Note that I assume the bitcoin chain will not change and collect the
# blocks from a running bitcoin client.
# WARNING: THIS CAN LEAD TO DIFFERENT INPUTS WHEN THE CLIENT SWITCHED
# BETWEEN TESTNET AND MAINNET OR THE CHAIN TIP IS USED.

import sys
from lib.benchmark_lib import benchmarkInit, benchmarkBatches


# Imitating the ctx object from click allows to share code base
class Ctx:
    obj = {}


# decide on what batches we use
smallBatches = [(1, 3), (2015, 2017)]
mediumBatches = [(1, 21), (2015, 2035)]
bigBatches = [(1, 252), (2015, 2267)]

ctx = Ctx()
ctx.obj = benchmarkInit()
results = benchmarkBatches(ctx, smallBatches)
# TODO print table of results with prettytable or other package
# TODO maybe change benchmarkRunCairo to run with --print_info to get the steps
