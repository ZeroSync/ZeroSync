import json

def write_into_memory(ptr, json_data, segments):
    addr = ptr
    if hasattr(ptr, 'address_'):
        addr = ptr.address_
        
    my_array = json.loads(json_data)
    # Note the following:
    # - Addresses are stored as `Relocatable` values in the Cairo VM.
    # - The "+" operator is overloaded to perform pointer arithmetics.
    # - Felts are hex encoded starting with "0x". The virtual addresses are encoded as decimals.
    my_memory = [(int(x, 16) if x.startswith('0x') else addr + int(x)) for x in my_array]
    segments.write_arg(addr, my_memory)