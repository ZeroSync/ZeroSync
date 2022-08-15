# Defines write_hashes for tests
func setup_python_defs():
    %{
        import re

        def little_endian(string):
            splited = [str(string)[i: i + 2] for i in range(0, len(str(string)), 2)]
            splited.reverse()
            return "".join(splited)


        def hex_to_felt(hex_string):
            # Seperate hex_string into chunks of 8 chars.
            felts = re.findall(".?.?.?.?.?.?.?.", hex_string)
            # Fill remaining space in last chunk with 0.
            while len(felts[-1]) < 8:
                felts[-1] += "0"
            return [int(x, 16) for x in felts]


        def write_hashes(hashes, destination):
            for i, hex_hash in enumerate(hashes):
                hex_string = little_endian(hex_hash.replace("0x",""))
                _ = write_hex_string(hex_string, destination + i * 8)
            return len(hashes)


        def write_hex_string(hex_string, destination):
            felts = hex_to_felt(hex_string)
            segments.write_arg(destination, felts)
            return len(felts)


        # Writes a string of any length into the given destination array.
        # String is seperated into uint32 chunks.
        # Last chunk is filled with zeros after the last string byte.
        def write_string(string, destination):
            hex_list = [hex(ord(x)).replace("0x","") for x in string]
            hex_string = "".join(hex_list)
            len_felts = write_hex_string(hex_string, destination)
            return len(string), len_felts
    %}
    return ()
end
