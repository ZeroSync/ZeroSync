# Example usage: 
# 	python3 utxo_data_bridge.py 00000000000004ff83b6c10460b239ef4a6aa320e5fffd6c7bcedefa8c78593c
# 	python3 utxo_data_bridge.py 000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506

import struct
from blockstream import blockexplorer

def fetch_utxo_data_for_block(block_hash):
	result_hex = ''
	block = blockexplorer.get_block_by_hash(block_hash)
	start_index = 0
	while start_index < block.tx_count:
		transactions = blockexplorer.get_block_transactions(block_hash, start_index)
		start_index = start_index + len(transactions)
		for i in range(1, len(transactions)):
			for tx_input in transactions[i].vin:
				prevout = tx_input['prevout']
				pubkey = prevout['scriptpubkey']
				
				pubkey_len = len(pubkey) // 2
				# Ensure that the length of the pubkey fits into a single byte
				# Otherwise, we'd have to encode it as a varint.
				assert pubkey_len < 2**8
				pubkey_len = "{0:02x}".format(pubkey_len)

				value = prevout['value']
				value = swap_endianess(value)
				value = "{0:016x}".format(value, 8)

				# print(value, pubkey_len, pubkey)
				result_hex += value + pubkey_len + pubkey
	return result_hex

def swap_endianess(value):
	# See: https://docs.python.org/2/library/struct.html
    return struct.unpack("<Q", struct.pack(">Q", value))[0]



import sys
if __name__ == "__main__":    
    result = fetch_utxo_data_for_block(sys.argv[1])
    print(result)