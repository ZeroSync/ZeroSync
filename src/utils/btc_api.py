from functools import lru_cache
import urllib3
from src.utils.authproxy import AuthServiceProxy
import urllib3
import json
import asyncio

# TODO rename the constants as e.e. txs data is not really big just unnecessary to cache for other purposes than testing
# Specify the number of API calls cached
# SMALL_DATA: hashes, headers
CACHE_SIZE_SMALL_DATA = 10**5
# BIG_DATA: blocks, txs
CACHE_SIZE_LARGE_DATA = 10**3

GENESIS_COINBASE_TX = r"""{"txid":"4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b","version":1,"locktime":0,"vin":[{"txid":"0000000000000000000000000000000000000000000000000000000000000000","vout":4294967295,"prevout":null,"scriptsig":"04ffff001d0104455468652054696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e64206261696c6f757420666f722062616e6b73","scriptsig_asm":"OP_PUSHBYTES_4 ffff001d OP_PUSHBYTES_1 04 OP_PUSHBYTES_69 5468652054696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e64206261696c6f757420666f722062616e6b73","is_coinbase":true,"sequence":4294967295}],"vout":[{"scriptpubkey":"4104678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5fac","scriptpubkey_asm":"OP_PUSHBYTES_65 04678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5f OP_CHECKSIG","scriptpubkey_type":"p2pk","value":5000000000}],"size":204,"weight":816,"fee":0,"status":{"confirmed":true,"block_height":0,"block_hash":"000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f","block_time":1231006505}}"""

GENESIS_COINBASE_TX_RAW = r"""01000000010000000000000000000000000000000000000000000000000000000000000000ffffffff4d04ffff001d0104455468652054696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e64206261696c6f757420666f722062616e6b73ffffffff0100f2052a01000000434104678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5fac00000000"""

def little_endian(string):
    splited = [str(string)[i: i + 2] for i in range(0, len(str(string)), 2)]
    splited.reverse()
    return "".join(splited)


def marshall_block_header(header):
    marshalled_header = {
        'version': int(little_endian(header[0:8]), 16),
        'previousblockhash': little_endian(header[8:72]),
        'merkle_root': little_endian(header[72:136]),
        'timestamp': int(little_endian(header[136:144]), 16),
        'bits': int(little_endian(header[144:152]), 16),
        'nonce': int(little_endian(header[152:160]), 16),
    }
    return marshalled_header


class BTCAPI:
    def __init__(self, base_url):
        self.base_url = base_url

    def get_block_header_raw(self, block_height):
        pass

    def get_block(self, block_height):
        pass

    def get_block_raw(self, block_height):
        pass

    def get_transaction_raw(self, block_height, tx_index):
        pass

    def get_transaction(self, block_height, tx_index):
        pass

    def get_block_header(self, block_height):
        raw_header = self.get_block_header_raw(block_height)
        return marshall_block_header(raw_header)

    def get_block_headers(self, start, end):
        headers = []
        for i in range(start, end):
            headers.append(self.get_block_header(i))
        return headers

    @staticmethod
    def make_BTCAPI():
        # Since bitcoin-cli is the preferred way to retrieve blocks try to
        # setup the respective API and fall back to Esplorer in case there
        # is no correctly configured bitcoind instance running
        try:
            API = BitcoinCLI('http://mario:myrpcpsw@localhost:8332')
            # Check if bitcoin-cli serves the main net genesis hash
            if API.get_block_hash(0) != '000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f' or API.get_block(
                    0) is None or API.get_transaction_raw(170, 1) is None:
                API = EsplorerAPI('https://blockstream.info/api/')
        except Exception:
            print(
                '[WARNING] No bitcoinrpc setup found. Falling back to blockstream API')
            API = EsplorerAPI('https://blockstream.info/api/')
        return API


class BitcoinCLI(BTCAPI):
    def __init__(self, rpc_auth):
        self.rpc_auth = rpc_auth
        self.rpc = AuthServiceProxy(self.rpc_auth)

    def get_block_hash(self, block_height):
        self.rpc = AuthServiceProxy(self.rpc_auth)
        block_hash = self.rpc.getblockhash(block_height)
        return block_hash

    def get_block_header_raw(self, block_height):
        block_hash = self.get_block_hash(block_height)
        block_header = self.rpc.getblockheader(block_hash, False)
        return block_header

    def get_block(self, block_height):
        block_hash = self.get_block_hash(block_height)
        block = self.rpc.getblock(block_hash)
        block['tx_count'] = block['nTx']
        return block

    def get_block_raw(self, block_height):
        block_hash = self.get_block_hash(block_height)
        block = self.rpc.getblock(block_hash, False)
        return block

    # Expecting bitcoind client with -txindex
    @lru_cache(maxsize=CACHE_SIZE_LARGE_DATA)
    def get_transaction_raw(self, block_height, tx_index):
        if block_height == 0 and tx_index == 0:
            return GENESIS_COINBASE_TX_RAW
        block_hash = self.get_block_hash(block_height)
        tx_id = self.rpc.getblock(block_hash)['tx'][tx_index]
        tx_hex = self.rpc.getrawtransaction(f'{tx_id}')
        return tx_hex

    # Expecting bitcoind client with -txindex
    def get_transaction(self, block_height, tx_index):
        if block_height == 0 and tx_index == 0:
            return json.loads(GENESIS_COINBASE_TX)
        block_hash = self.get_block_hash(block_height)
        tx_id = self.rpc.getblock(block_hash)['tx'][tx_index]
        tx_json = self.rpc.getrawtransaction(f'{tx_id}', True)
        return tx_json

    def get_transaction_by_id(self, txid):
        if tx_id == "4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b":
            return json.loads(GENESIS_COINBASE_TX)
        tx_json = self.rpc.getrawtransaction(f'{tx_id}', True)
        return tx_json


class EsplorerAPI(BTCAPI):
    def __init__(self, base_url):
        self.base_url = base_url
        self.pool_manager = urllib3.PoolManager()

    @lru_cache(maxsize=CACHE_SIZE_SMALL_DATA)
    def get_block_hash(self, block_height):
        url = self.base_url + 'block-height/' + str(block_height)
        r = self.pool_manager.request('GET', url)
        if r.status != 200:
            print(
                f'ERROR: get_block_hash({block_height}) received a bad answer from the remote API: ',
                r.status,
                r.data.decode('utf-8'))
            exit(-1)
        block_hash = str(r.data, 'utf-8')
        return block_hash

    @lru_cache(maxsize=CACHE_SIZE_SMALL_DATA)
    def get_block_header_raw(self, block_height):
        block_hash = self.get_block_hash(block_height)
        url = self.base_url + 'block/' + str(block_hash) + '/header'
        r = self.pool_manager.request('GET', url)
        if r.status != 200:
            print(
                f'ERROR: get_block_header_raw({block_height}) received a bad answer from the remote API: ',
                r.status,
                r.data.decode('utf-8'))
            exit(-1)
        block_header = r.data.decode('utf-8')
        return block_header

    @lru_cache(maxsize=CACHE_SIZE_LARGE_DATA)
    def get_block(self, block_height):
        block_hash = self.get_block_hash(block_height)
        url = self.base_url + 'block/' + str(block_hash)
        r = self.pool_manager.request('GET', url)
        if r.status != 200:
            print(
                f'ERROR: get_block({block_height}) received a bad answer from the remote API: ',
                r.status,
                r.data.decode('utf-8'))
            exit(-1)
        block = json.loads(r.data)
        return block

    @lru_cache(maxsize=CACHE_SIZE_LARGE_DATA)
    def get_block_raw(self, block_height):
        block_hash = self.get_block_hash(block_height)
        url = self.base_url + 'block/' + str(block_hash) + '/raw'
        r = self.pool_manager.request('GET', url)
        if r.status != 200:
            print(
                f'ERROR: get_block_raw({block_height}) received a bad answer from the remote API: ',
                r.status,
                r.data.decode('utf-8'))
            exit(-1)
        block_raw = r.data.hex()
        return block_raw

    @lru_cache(maxsize=CACHE_SIZE_LARGE_DATA)
    def get_transaction_raw(self, block_height, tx_index):
        block_hash = self.get_block_hash(block_height)
        url = self.base_url + f'block/{block_hash}/txid/' + str(tx_index)
        r = self.pool_manager.request('GET', url)
        txid = r.data.decode('utf-8')
        if r.status != 200:
            print(
                f'ERROR: get_transaction_raw({block_height}, {tx_index}) could not retrieve tx_id from the remote API: ',
                r.status,
                r.data.decode('utf-8'))
            exit(-1)
        url = self.base_url + f'tx/{txid}/hex'
        r = self.pool_manager.request('GET', url)
        tx_hex = r.data.decode('utf-8')
        if r.status != 200:
            print(
                    f'ERROR: get_transaction_raw({block_height}, {tx_index}) could not retrieve transaction data from the remote API',
                r.status,
                r.data.decode('utf-8'))
            exit(-1)
        return tx_hex
    
    @lru_cache(maxsize=CACHE_SIZE_LARGE_DATA)
    def get_transaction_by_id(self, txid):
        url = self.base_url + f'tx/{txid}'
        r = self.pool_manager.request('GET', url)
        tx = json.loads(r.data)
        if r.status != 200:
            print(
                f'ERROR: get_transaction_by_id({txid}) could not retrieve tx_id from the remote API: ',
                r.status,
                r.data.decode('utf-8'))
            exit(-1)
        return tx


    @lru_cache(maxsize=CACHE_SIZE_LARGE_DATA)
    def get_transaction(self, block_height, tx_index):
        block_hash = self.get_block_hash(block_height)
        url = self.base_url + f'block/{block_hash}/txid/' + str(tx_index)
        r = self.pool_manager.request('GET', url)
        txid = r.data.decode('utf-8')
        if r.status != 200:
            print(
                f'ERROR: get_transaction({block_height}, {tx_index}) could not retrieve tx_id from the remote API: ',
                r.status,
                r.data.decode('utf-8'))
            exit(-1)
        return self.get_transaction_by_id(txid)

if __name__ == '__main__':
    API = BTCAPI.make_BTCAPI()
    print("[BLOCK HASH]", API.get_block_hash(1))
    print("[BLOCK]", API.get_block(1))
    print("[BLOCK_RAW]", API.get_block_raw(1))
    print("[BLOCK_HEADER]", API.get_block(1))
    print("[BLOCK_HEADER_RAW]", API.get_block_header_raw(1))
    print("[TRANSACTION]", API.get_transaction(1, 0))
    print("[TRANSACTION_RAW]", API.get_transaction_raw(1, 0))
