from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from recursive.crypto.random import (
    PublicCoin,
    draw_pair,
    random_coin_new,
    hash_elements,
    reseed,
    reseed_with_int,
    seed_with_pub_inputs,
    seed_with_proof_context,
)

struct AirInstance {
    // Layout
    num_segments: felt,
    main_trace_width: felt,
    aux_trace_width: felt,
    // Context
    num_transition_constraints: felt,
    num_assertions: felt,
}

// Coefficients used in construction of constraint composition polynomial
struct ConstraintCompositionCoefficients {
    // Transition constraints (alpha and beta)
    transition_a: felt*,
    transition_b: felt*,
    // Boundary constraints (alpha and beta)
    boundary_a: felt*,
    boundary_b: felt*,
}

func air_instance_new() -> (res: AirInstance) {
    // TODO: Use correct values for Cairo AIR. Make configurable for other
    // VMs and custom AIRs
    return (res=AirInstance(
        num_segments=5,
        main_trace_width=30,
        aux_trace_width=10,
        num_transition_constraints=21,
        num_assertions=4,
    ));
}

// Returns coefficients needed to construct the constraint composition polynomial
func get_constraint_composition_coefficients{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    public_coin: PublicCoin,
}(
    air: AirInstance
) -> (res: ConstraintCompositionCoefficients) {
    alloc_locals;

    let (t_coefficients_a: felt*) = alloc();
    let (t_coefficients_b: felt*) = alloc();
    tempvar num_constraints = air.num_transition_constraints;
    draw_pairs(
        n_pairs=num_constraints,
        coefficients_a=t_coefficients_a,
        coefficients_b=t_coefficients_b,
    );

    let (b_coefficients_a: felt*) = alloc();
    let (b_coefficients_b: felt*) = alloc();
    tempvar num_assertions = air.num_assertions;
    draw_pairs(
        n_pairs=num_assertions,
        coefficients_a=b_coefficients_a,
        coefficients_b=b_coefficients_b,
    );

    let res = ConstraintCompositionCoefficients(
        transition_a = t_coefficients_a,
        transition_b = t_coefficients_b,
        boundary_a = b_coefficients_a,
        boundary_b = b_coefficients_b,
    );

    return (res=res);
}

// Returns the next pair of pseudo-random field elements, and adds them to the
// list of coefficients
func draw_pairs{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    public_coin: PublicCoin,
}(
    n_pairs: felt,
    coefficients_a: felt*,
    coefficients_b: felt*) 
-> () {
    let (num1, num2) = draw_pair();
    coefficients_a[0] = num1;
    coefficients_b[0] = num2;

    if (n_pairs == 0) {
        return ();
    }
    return draw_pairs(
        n_pairs=n_pairs - 1,
        coefficients_a=coefficients_a + 1,
        coefficients_b=coefficients_b + 1,
    );
}

func get_aux_trace_segment_random_elements(air: AirInstance) -> () {
    // TODO
}
