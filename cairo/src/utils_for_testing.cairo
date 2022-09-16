# Defines hashes_from_hex for tests
func setup_python_defs():
    %{
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
                check_if_hex = int(hex_string,16)
            except ValueError:
                print("ERROR: Input to from_hex contains non-hex characters.")
            felts = hex_to_felt(hex_string)
            segments.write_arg(destination, felts)

            # Return the byte size of the uint32 array and the array length.
            return len(hex_string) // 2, len(felts)

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
    %}
    return ()
end
