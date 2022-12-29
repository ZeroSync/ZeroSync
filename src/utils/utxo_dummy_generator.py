import urllib3
import json
import re
import math
import sys
import os

from starkware.cairo.lang.vm.crypto import pedersen_hash
from starkware.cairo.common.hash_chain import compute_hash_chain

HASH_FELT_SIZE = 8


def hex_to_felt(hex_string):
    # Seperate hex_string into chunks of 8 chars.
    felts = re.findall(".?.?.?.?.?.?.?.", hex_string)
    # Fill remaining space in last chunk with 0.
    while len(felts[-1]) < 8:
        felts[-1] += "0"
    return [int(x, 16) for x in felts]


def little_endian(string):
    splited = [str(string)[i: i + 2] for i in range(0, len(str(string)), 2)]
    splited.reverse()
    return "".join(splited)


# Returns the block at given height in json format
def fetch_block(block_height):
    http = urllib3.PoolManager()

    url = 'https://blockstream.info/api/block-height/' + str(block_height)
    r = http.request('GET', url)
    block_hash = r.data.decode('utf8')
    url = 'https://blockstream.info/api/block/' + str(block_hash)
    r = http.request('GET', url)
    return json.loads(r.data)


# see here: https://github.com/zerosync/zerosync/blob/fb70c24e16bbc5617fe91c4c7db23f6748102558/src/utxo_set/utxo_set.cairo#L120
# txid as a list of uint32
# script_pub_key is a list of uint32
def hash_output(txid, vout, amount, script_pub_key):
    script_pub_key_hash = compute_hash_chain(script_pub_key)
    txid_hash = compute_hash_chain(txid)
    tmp1 = pedersen_hash(amount, script_pub_key_hash)
    tmp2 = pedersen_hash(vout, tmp1)
    return(pedersen_hash(txid_hash, tmp2))


# Returns a list of tx inputs (used utxos) of a block at specified height
def fetch_tx_ins_and_outs(block_height):
    http = urllib3.PoolManager()

    # fetch the block hash
    url = 'https://blockstream.info/api/block-height/' + str(block_height)
    r = http.request('GET', url)
    block_hash = r.data.decode('utf8')

    # fetch a list of txids
    url = 'https://blockstream.info/api/block/' + block_hash + '/txids'
    r = http.request('GET', url)
    txids = json.loads(r.data)

    txs = {}
    # fetch all tx_in and tx_out per tx in txids
    for txid in txids:
        url = 'https://blockstream.info/api/tx/' + txid
        r = http.request('GET', url)
        tx = json.loads(r.data)
        txs[txid] = tx

    return txs


def hash_tx_ins(txs):
    hashes = []
    for tx in txs:
        for tx_vin in txs[tx]['vin']:
            if tx_vin['is_coinbase']:
                continue
            # this utxo is generated in the validated block and we should not add
            # it to the utxo set manually
            if tx_vin['txid'] in txs:
                continue
            txid_list = hex_to_felt(little_endian(tx_vin['txid']))
            vout = tx_vin['vout']
            amount = tx_vin['prevout']['value']
            script_pub_key = hex_to_felt(tx_vin['prevout']['scriptpubkey'])
            utxo_hash = hash_output(txid_list, vout, amount, script_pub_key)
            hashes.append(utxo_hash)
    return hashes


def generate_utxo_dummys(block_height):
    # TODO add cache folder to gitignore

    # Check if the current block exists in the cache directory
    cache_dir = 'utxo_dummy_cache'
    os.system(f'mkdir -p {cache_dir}')

    if os.path.isfile(f'{cache_dir}/block_{block_height}.json'):
        f = open(f'{cache_dir}/block_{block_height}.json', 'r')
        output_hashes = json.load(f)
    else:
        # Fetch all required utxos
        txs = fetch_tx_ins_and_outs(block_height)
        output_hashes = hash_tx_ins(txs)

        # Create new file as cache entry
        f = open(f'{cache_dir}/block_{block_height}.json', 'w')
        json.dump(output_hashes, f)

    f.close()
    return output_hashes


if __name__ == "__main__":
    if len(sys.argv) == 1:
        print(
            f"ERROR: No block height specified.\nUSAGE: python {sys.argv[0]} <block-height>\n")
        exit(1)
    block_height = int(sys.argv[1])
    if block_height < 0:
        print("ERROR: Specify a block height above zero.")
        exit(2)

    dummys = generate_utxo_dummys(block_height)
    print(dummys)
