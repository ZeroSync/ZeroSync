def chunks(lst, n):
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

def get_hex(memory, ptr):
    hex_str = ""
    for i in range(8):
        word=hex(memory[ptr+i])[2:].zfill(8)
        for nibs in list(chunks(word, 2))[::-1]:
            for nib in nibs:
                hex_str += nib
    return hex_str

