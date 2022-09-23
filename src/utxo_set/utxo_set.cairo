from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.hash import hash2

from crypto.sha256d.sha256d import HASH_FELT_SIZE
from utreexo.utreexo import utreexo_add, utreexo_delete, fetch_inclusion_proof

func utxo_set_insert{range_check_ptr, hash_ptr: HashBuiltin*, utreexo_roots: felt*}(
    txid:felt*, vout, amount, script_pub_key:felt*, script_pub_key_size):
    alloc_locals

    let (script_pub_key_len, _) = unsigned_div_rem(script_pub_key_size + 3, 4)
    let (local hash) = hash_output(txid, vout, amount, script_pub_key, script_pub_key_len)

    %{

        import struct

        def swap32(i):
            return struct.unpack("<I", struct.pack(">I", i))[0]

        BASE = 2**32
        def _read_i(address, i):
            return swap32( memory[address + i] ) * BASE ** i 

        def hash_from_memory(address):
            hash = _read_i(address, 0)  \
                 + _read_i(address, 1)  \
                 + _read_i(address, 2)  \
                 + _read_i(address, 3)  \
                 + _read_i(address, 4)  \
                 + _read_i(address, 5)  \
                 + _read_i(address, 6)  \
                 + _read_i(address, 7)
            return hex(hash).replace('0x','').zfill(64)
        txid = hash_from_memory(ids.txid) 
        print('UTXOSET insert:', 'txid', txid, 'vout', ids.vout, 'amount', ids.amount, 'script_pub_key_size', ids.script_pub_key_size, 'hash', hex(ids.hash))
    %}

    %{

        # print('>> Add hash to utreexo DB', ids.hash) 
        import urllib3
        http = urllib3.PoolManager()
        hex_hash = hex(ids.hash).replace('0x','')
        url = 'http://localhost:2121/add/' + hex_hash
        r = http.request('GET', url)

        # import json
        # response = json.loads(r.data)
    %}

    utreexo_add(hash)
    return()
end

func utxo_set_extract{hash_ptr: HashBuiltin*, utreexo_roots: felt*}(
    txid:felt*, vout) -> (amount, script_pub_key:felt*, script_pub_key_len):
    alloc_locals

    local amount
    local script_pub_key_size
    local script_pub_key_len
    let (script_pub_key) = alloc()

    %{
        import struct

        def swap32(i):
            return struct.unpack("<I", struct.pack(">I", i))[0]

        BASE = 2**32
        def _read_i(address, i):
            return swap32( memory[address + i] ) * BASE ** i 

        def hash_from_memory(address):
            hash = _read_i(address, 0)  \
                 + _read_i(address, 1)  \
                 + _read_i(address, 2)  \
                 + _read_i(address, 3)  \
                 + _read_i(address, 4)  \
                 + _read_i(address, 5)  \
                 + _read_i(address, 6)  \
                 + _read_i(address, 7)
            return hex(hash).replace('0x','').zfill(64)

        txid = hash_from_memory(ids.txid) 


        import urllib3
        http = urllib3.PoolManager()
        url = 'https://blockstream.info/api/tx/' + txid
        r = http.request('GET', url)
        

        import json
        tx = json.loads(r.data)
        tx_output = tx["vout"][ids.vout]

        ids.amount = tx_output["value"]       
        
        import re
        def hex_to_felt(hex_string):
            # Seperate hex_string into chunks of 8 chars.
            felts = re.findall(".?.?.?.?.?.?.?.", hex_string)
            # Fill remaining space in last chunk with 0.
            while len(felts[-1]) < 8:
                felts[-1] += "0"
            return [int(x, 16) for x in felts]

        # Writes a hex string string into an uint32 array
        #
        # Using multi-line strings in python:
        # - https://stackoverflow.com/questions/10660435/how-do-i-split-the-definition-of-a-long-string-over-multiple-lines
        def from_hex(hex_string, destination):
            # To see if there are only 0..f in hex_string we can try to turn it into an int
            try:
                check_if_hex = int(hex_string, 16)
            except ValueError:
                print("ERROR: Input to from_hex contains non-hex characters.")
            felts = hex_to_felt(hex_string)
            segments.write_arg(destination, felts)

            # Return the byte size of the uint32 array and the array length.
            return (1 + len(hex_string)) // 2, len(felts)


        byte_size, felt_size = from_hex( tx_output["scriptpubkey"], ids.script_pub_key)
        ids.script_pub_key_len = felt_size
        ids.script_pub_key_size = byte_size
        print('UTXOSET extract:', 'txid', txid, 'vout', ids.vout, 'amount', ids.amount, 'script_pub_key_size', ids.script_pub_key_size)
    %}

    let (prevout_hash) = hash_output(txid, vout, amount, script_pub_key, script_pub_key_len)
    
    let (leaf_index, proof, proof_len) = fetch_inclusion_proof(prevout_hash)

    # Prove inclusion and delete from accumulator
    utreexo_delete(prevout_hash, leaf_index, proof, proof_len)

    return (amount, script_pub_key, script_pub_key_len)
end


func hash_output{hash_ptr: HashBuiltin*}(
    txid:felt*, vout, amount, script_pub_key: felt*, script_pub_key_len)->(hash):
    alloc_locals
    let (script_pub_key_hash) = hash_chain(script_pub_key, script_pub_key_len)
    let script_pub_key_hash = 42
    let (txid_hash) = hash_chain(txid, HASH_FELT_SIZE) 
    let (tmp1) = hash2(amount, script_pub_key_hash) 
    let (tmp2) = hash2(vout, tmp1)
    let (hash) = hash2(txid_hash, tmp2)
    return (hash)
end




# Computes a hash chain of a sequence whose length is given at [data_ptr] and the data starts at
# data_ptr. The hash is calculated backwards (from the highest memory address to the lowest).
# For example, for the 3-element sequence [x, y, z] the hash is:
#   h(3, h(x, h(y, z)))
# If data_length = 0, the function does not return (takes more than field prime steps).
func hash_chain{hash_ptr : HashBuiltin*}(data_ptr : felt*, data_length) -> (hash : felt):
    struct LoopLocals:
        member data_ptr : felt*
        member hash_ptr : HashBuiltin*
        member cur_hash : felt
    end

    tempvar data_ptr_end = data_ptr + data_length - 1
    # Prepare the loop_frame for the first iteration of the hash_loop.
    tempvar loop_frame = LoopLocals(
        data_ptr=data_ptr_end,
        hash_ptr=hash_ptr,
        cur_hash=[data_ptr_end])

    hash_loop:
    let curr_frame = cast(ap - LoopLocals.SIZE, LoopLocals*)
    let current_hash : HashBuiltin* = curr_frame.hash_ptr

    tempvar new_data = [curr_frame.data_ptr - 1]

    let n_elements_to_hash = [ap]
    # Assign current_hash inputs and allocate space for n_elements_to_hash.
    current_hash.x = new_data; ap++
    current_hash.y = curr_frame.cur_hash

    # Set the frame for the next loop iteration (going backwards).
    tempvar next_frame = LoopLocals(
        data_ptr=curr_frame.data_ptr - 1,
        hash_ptr=curr_frame.hash_ptr + HashBuiltin.SIZE,
        cur_hash=current_hash.result)

    # Update n_elements_to_hash and loop accordingly. Note that the hash is calculated backwards.
    n_elements_to_hash = next_frame.data_ptr - data_ptr
    jmp hash_loop if n_elements_to_hash != 0

    # Set the hash_ptr implicit argument and return the result.
    let hash_ptr = next_frame.hash_ptr
    return (hash=next_frame.cur_hash)
end
