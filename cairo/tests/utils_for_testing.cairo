
from starkware.cairo.common.alloc import alloc
# Defines write_hashes for tests
func setup_hashes() -> (leaves : felt*):
    let (ptr) = alloc()

    %{
        import re

        def little_endian(string):
            splited = [str(string)[i: i + 2] for i in range(0, len(str(string)), 2)]
            splited.reverse()
            return "".join(splited)


        def hex_to_felt(str):
            raw_str = little_endian(str.replace("0x",""))
            felts = re.findall(".?.?.?.?.?.?.?.", raw_str)
            return [int(x, 16) for x in felts]


        def write_hashes(hashes, destination):
            for i, tx_hash in enumerate(hashes):
                segments.write_arg(destination + i*8, hex_to_felt(tx_hash))
    %}
    return (ptr)
end