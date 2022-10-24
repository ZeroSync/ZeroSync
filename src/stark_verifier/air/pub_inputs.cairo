from stark_verifier.utils import Vec

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
    mem: Vec,
    num_steps: felt, // number of execution steps
}
