// Defines hashes_from_hex for tests
func setup_python_defs() {
    %{
        # Note: This import requires $PYTHONPATH to include the zerosync path.
        #       Currently appended in Makefile.
        from src.utils.btc_api import BTCAPI
        global BTC_API
        BTC_API = BTCAPI.make_BTCAPI()
        import re
        def hex_to_felt(hex_string):
            # Seperate hex_string into chunks of 8 chars.
            felts = re.findall(".?.?.?.?.?.?.?.", hex_string)
            # Fill remaining space in last chunk with 0.
            while len(felts[-1]) < 8:
                felts[-1] += "0"
            return [int(x, 16) for x in felts]

        # Writes a hex string into an uint32 array
        #
        # Using multi-line strings in python:
        # - https://stackoverflow.com/questions/10660435/how-do-i-split-the-definition-of-a-long-string-over-multiple-lines
        def from_hex(hex_string, destination):
            # To see if there are only 0..f in hex_string we can try to turn it into an int
            try:
                check_if_hex = int(hex_string,16)
            except ValueError:
                print("ERROR: Input to from_hex contains non-hex characters.")
            felts = hex_to_felt(hex_string)
            segments.write_arg(destination, felts)

            # Return the byte size of the uint32 array and the array length.
            return (1 + len(hex_string))// 2, len(felts)

        # Writes a string of any length into the given destination array.
        # String is seperated into uint32 chunks.
        # Last chunk is filled with zeros after the last string byte.
        def from_string(string, destination):
            hex_list = [hex(ord(x)).replace("0x","") for x in string]
            hex_string = "".join(hex_list)
            
            return from_hex(hex_string, destination)


        def little_endian(string):
            splited = [str(string)[i: i + 2] for i in range(0, len(str(string)), 2)]
            splited.reverse()
            return "".join(splited)

        # Writes an array of hex-encoded hashes into an uint32 array
        # Because of the quirk in Bitcoin we display hex-encoded hashes 
        # in reverse byte order.
        def hashes_from_hex(hashes, destination):
            for i, hex_hash in enumerate(hashes):
                hex_string = little_endian(hex_hash.replace("0x",""))
                _ = from_hex(hex_string, destination + i * 8)
            return len(hashes)


        def felts_from_hash(hex_hash):
            hex_hash = little_endian(hex_hash)
            return hex_to_felt(hex_hash)

        def felts_from_hex_strings(hex_strings):
            return list( map(lambda x: int(x, 16), hex_strings ))

        # additional helper functions invoked from `utxo_set_extract`
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
    %}
    return ();
}
