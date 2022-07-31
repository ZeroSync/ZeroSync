# taken from
# https://github.com/informartin/zkRelay/blob/master/preprocessing/create_input.py
from binascii import hexlify, unhexlify
from typing import List

from wrapper.btcrpc import getBlockHeadersInRange
from json import dumps as jsonDumps
import re
import sys


def littleEndian(string):
    splited = [str(string)[i: i + 2] for i in range(0, len(str(string)), 2)]
    splited.reverse()
    return "".join(splited)


# adopted from
# https://github.com/informartin/zkRelay/blob/master/preprocessing/create_input.py
def createCairoInputFromBlock(block):
    version = littleEndian(block["versionHex"])
    little_endian_previousHash = (
        littleEndian(
            block["previousblockhash"]) if block["height"] > 0 else 64 *
        "0")
    little_endian_merkleRoot = littleEndian(block["merkleroot"])
    little_endian_time = littleEndian(hex(block["time"])[2:])
    little_endian_difficultyBits = littleEndian(block["bits"])
    nonce = hex(block["nonce"])[2:]
    nonce = "0" * (8 - len(nonce)) + nonce  # ensure nonce is 4 bytes long
    little_endian_nonce = littleEndian(nonce)

    header = (
        version
        + little_endian_previousHash
        + little_endian_merkleRoot
        + little_endian_time
        + little_endian_difficultyBits
        + little_endian_nonce
    )
    return header


def binToFelt(str: str) -> List[int]:
    feltFormat = re.findall(".?.?.?.?.?.?.?.", str)
    while len(feltFormat[-1]) != 8:
        feltFormat[-1] += "0"
    return [int(x, 16) for x in feltFormat]


# formula:
# https://medium.com/@dongha.sohn/bitcoin-6-target-and-difficulty-ee3bc9cc5962
def unpackTarget(bits: str):  # TODO remove or keep for tests
    coefficient = int(bits[2:8], 16)
    index = int(bits[0:2], 16)
    target = coefficient * (2 ** (8 * (index - 3)))
    return "{0:0{1}x}".format(target, 64)


# includes block i, exludes block j
def dumpCairoInput(ctx, i, j):
    fileStr = ctx.obj['inputFile']
    cairo_input = open(fileStr, "w") if fileStr else sys.stdout
    dump = {"Blocks": []}
    blocks = getBlockHeadersInRange(ctx, i, j)
    for k, _ in enumerate(range(i, j)):
        block = binToFelt(createCairoInputFromBlock(blocks[k]))
        dump["Blocks"].append(block)
    firstEpochBlock = getBlockHeadersInRange(
        ctx, ((i - 1) // 2016 * 2016), ((i - 1) // 2016 * 2016) + 1
    )[0]
    dump["firstEpochBlock"] = binToFelt(
        createCairoInputFromBlock(firstEpochBlock))
    dump["blockNrThisEpoch"] = i - ((i // 2016) * 2016)
    cairo_input.write(jsonDumps(dump))
    if cairo_input is not sys.stdout:
        cairo_input.close()
    return


def dumpMerkleProofInput(ctx, i, j, intermediaryIndex):
    fileStr = ctx.obj['inputFile']
    cairo_input = open(fileStr, "w") if fileStr else sys.stdout
    dump = {"Blocks": []}
    blocks = getBlockHeadersInRange(ctx, i, j)
    for k, _ in enumerate(range(i, j)):
        block = binToFelt(createCairoInputFromBlock(blocks[k]))
        dump["Blocks"].append(block)
    dump["blockToHash"] = intermediaryIndex
    cairo_input.write(jsonDumps(dump))
    if cairo_input is not sys.stdout:
        cairo_input.close()
    return
