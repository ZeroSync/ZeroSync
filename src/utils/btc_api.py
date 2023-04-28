from functools import lru_cache
import urllib3
from bitcoinrpc.authproxy import AuthServiceProxy, JSONRPCException # TODO has to be installed -> setup
import urllib3
import json
import asyncio

# TODO rename the constants as e.e. txs data is not really big just unnecessary to cache for other purposes than testing
# Specify the number of API calls cached
# SMALL_DATA: hashes, headers
CACHE_SIZE_SMALL_DATA = 10**5
# BIG_DATA: blocks, txs
CACHE_SIZE_LARGE_DATA = 10**3

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
            if API.get_block_hash(0) != '000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f' or API.get_block(0) == None or API.get_transaction(170, 1) == None: #
                API = EsplorerAPI('https://blockstream.info/api/')
        except Exception:
            print('[WARNING] No bitcoinrpc setup found. Falling back to blockstream API')
            API = EsplorerAPI('https://blockstream.info/api/')
        return API




class BitcoinCLI(BTCAPI):
    def __init__(self, rpc_auth):
        self.rpc = AuthServiceProxy(rpc_auth)


    def get_block_hash(self, block_height):
        block_hash = self.rpc.getblockhash(block_height)
        return block_hash

    def get_block_header_raw(self, block_height):
        block_hash = self.get_block_hash(block_height)
        block_header = self.rpc.getblockheader(block_hash, False)
        return block_header

    def get_block(self, block_height):
        block_hash = self.get_block_hash(block_height)
        block = self.rpc.getblock(block_hash)
        return block

    # Expecting bitcoind client with -txindex
    @lru_cache(maxsize=CACHE_SIZE_LARGE_DATA)
    def get_transaction(self, block_height, tx_index):
        block_hash = self.get_block_hash(block_height)
        tx_id = self.rpc.getblock(block_hash)['tx'][tx_index]
        tx_hex = self.rpc.getrawtransaction(f'{tx_id}')
        return tx_hex


class EsplorerAPI(BTCAPI):
    def __init__(self, base_url): 
        self.base_url = base_url
        self.pool_manager = urllib3.PoolManager()

    @lru_cache(maxsize=CACHE_SIZE_SMALL_DATA)
    def get_block_hash(self, block_height):
        url = self.base_url + 'block-height/' + str(block_height)
        r = self.pool_manager.request('GET', url)
        if r.status != 200:
            print(f'ERROR: get_block_hash({block_height}) received a bad answer from the remote API: ', r.status, r.data.decode('utf-8'))
            exit(-1)
        block_hash = str(r.data, 'utf-8')
        return block_hash
    
    @lru_cache(maxsize=CACHE_SIZE_SMALL_DATA)
    def get_block_header_raw(self, block_height):
        block_hash = self.get_block_hash(block_height)
        url = self.base_url + 'block/' + str(block_hash) + '/header'
        r = self.pool_manager.request('GET', url)
        # TODO error message
        block_header = r.data.decode('utf-8')
        return block_header
    
    @lru_cache(maxsize=CACHE_SIZE_LARGE_DATA)
    def get_block(self, block_height):
        block_hash = self.get_block_hash(block_height)
        url = self.base_url + 'block/' + str(block_hash)
        r = self.pool_manager.request('GET', url)
        # TODO error message
        block = json.loads(r.data)
        return block

    @lru_cache(maxsize=CACHE_SIZE_LARGE_DATA)
    def get_transaction(self, block_height, tx_index):
        block_hash = self.get_block_hash(block_height)
        url = self.base_url + f'block/{block_hash}/txid/' + str(tx_index)
        r = self.pool_manager.request('GET', url)
        txid = r.data.decode('utf-8')
        # TODO error message
        url = self.base_url + f'tx/{txid}/hex'
        r = self.pool_manager.request('GET', url)
        tx_hex = r.data.decode('utf-8')
        if r.status != 200:
            print("ERROR: Fetch_transaction received a bad answer from the API: ", r.status, r.data.decode('utf-8'))
            exit(-1)
        return tx_hex


if __name__ == '__main__':
    API = BTCAPI.make_BTCAPI()
    print(API.get_block_hash(0))
    print(API.get_block(0))
    print(API.get_block_header_raw(0))
    print(API.get_transaction(0,0))
