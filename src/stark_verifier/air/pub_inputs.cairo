from starkware.cairo.common.alloc import alloc

from stark_verifier.utils import Vec

struct MemEntry {
    address: felt,
    value: felt,
}

struct RegisterState {
    _pc: felt,
    _ap: felt,
    _fp: felt,
}

struct PublicInputs {
    init: RegisterState,
    fin: RegisterState,
    rc_min: felt,
    rc_max: felt,
    mem: MemEntry,
    num_steps: felt,  // number of execution steps
}

func read_public_inputs() -> (proof: PublicInputs*) {
    let (pub_inputs_ptr: PublicInputs*) = alloc();
    %{
        addr = ids.pub_inputs_ptr.address_
        my_memory = [(int(x, 16) if x.startswith('0x') else addr + int(x)) for x in json_data]
        segments.write_arg(addr, my_memory)
    %}
    return (proof=pub_inputs_ptr);
}

func read_mem_values(mem: MemEntry*, address: felt, length: felt, output: felt*) {
    if (length == 0) {
        return ();
    }
    assert mem.address = address;
    assert output[0] = mem.value;
    return read_mem_values(mem=&mem[1], address=address + 1, length=length - 1, output=&output[1]);
}
