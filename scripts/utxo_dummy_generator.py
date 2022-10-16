import urllib3
import json
import re
import math

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
def fetch_tx_ins(block_height):
    http = urllib3.PoolManager()
    
    # fetch the block hash
    url = 'https://blockstream.info/api/block-height/' + str(block_height)
    r = http.request('GET', url)
    block_hash = r.data.decode('utf8')
    
    # fetch a list of txids
    url = 'https://blockstream.info/api/block/' + block_hash + '/txids'
    r = http.request('GET', url)
    txids = json.loads(r.data)
    
    tx_ins = []
    # fetch all tx_in per tx in txids
    for txid in txids:
        url = 'https://blockstream.info/api/tx/' + txid
        r = http.request('GET', url)
        tx = json.loads(r.data)
        for tx_vin in tx['vin']:
            tx_ins.append(tx_vin)
    return tx_ins


def hash_tx_ins(tx_ins):
    hashes = []
    for tx_vin in tx_ins:
        if tx_vin['is_coinbase'] == True:
            continue
        txid_list = hex_to_felt(little_endian(tx_vin['txid']))
        vout = tx_vin['vout']
        amount = tx_vin['prevout']['value']
        script_pub_key = hex_to_felt(tx_vin['prevout']['scriptpubkey'])
        utxo_hash = hash_output(txid_list, vout, amount, script_pub_key)
        hashes.append(utxo_hash)
    return hashes


def generate_utxo_dummys(block_height):
    tx_ins = fetch_tx_ins(block_height)
    output_hashes = hash_tx_ins(tx_ins)
    code_block = ['dummy_utxo_insert{hash_ptr=pedersen_ptr, utreexo_roots=prev_utreexo_roots}(' + hex(x) + ');\n' for x in output_hashes]

    return code_block


print("".join(generate_utxo_dummys(328734)))
