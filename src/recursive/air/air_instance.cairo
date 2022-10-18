from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from recursive.crypto.random import (
    PublicCoin,
    draw_elements,
    draw_pair,
    random_coin_new,
    hash_elements,
    reseed,
    reseed_with_int,
    seed_with_pub_inputs,
    seed_with_proof_context,
)
from recursive.air.stark_proof import ProofOptions
from recursive.air.trace_info import TraceInfo

struct AirInstance {
    // Layout
    main_segment_width: felt,
    aux_trace_width: felt,
    aux_segment_widths: felt*,
    aux_segment_rands: felt*,
    num_aux_segments: felt,
    // Context
    options: ProofOptions,
    trace_info: TraceInfo,
    num_transition_constraints: felt,
    num_assertions: felt,
    ce_blowup_factor: felt,
    eval_frame_size: felt,
    lde_domain_size: felt,
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

struct TraceCoefficients {
    n_values: felt,
    values: felt,
}

// Coefficients used in construction of DEEP composition polynomial
struct DeepCompositionCoefficients {
    // Trace polynomial composition coefficients $\alpha_i$, $\beta_i$, and $\gamma_i$
    trace: TraceCoefficients*,
    // Constraint column polynomial composition coefficients $\delta_j$
    constraints: felt*,
    // Degree adjustment composition coefficients $\lambda$ and $\mu$
    degree: (felt, felt),
}

func air_instance_new(trace_info: TraceInfo, options: ProofOptions) -> (res: AirInstance) {
    alloc_locals;
    let (aux_segment_widths: felt*) = alloc();
    let (aux_segment_rands: felt*) = alloc();

    // TODO: Use correct values for Cairo AIR. Make configurable for other
    // VMs and custom AIRs
    return (res=AirInstance(
        main_segment_width=30,
        aux_trace_width=2,
        aux_segment_widths=aux_segment_widths,
        aux_segment_rands=aux_segment_rands,
        num_aux_segments=3,
        options=options,
        trace_info=trace_info,
        num_transition_constraints=20,
        num_assertions=4,
        ce_blowup_factor=4,
        eval_frame_size=2,
        lde_domain_size=options.blowup_factor * trace_info.trace_length,
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
        transition_a=t_coefficients_a,
        transition_b=t_coefficients_b,
        boundary_a=b_coefficients_a,
        boundary_b=b_coefficients_b,
    );

    return (res=res);
}

// Returns coefficients needed to construct the DEEP composition polynomial
func get_deep_composition_coefficients{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    public_coin: PublicCoin,
}(
    air: AirInstance,
) -> (res: DeepCompositionCoefficients) {
    alloc_locals;

    let (t_coefficients: TraceCoefficients*) = alloc();
    set_trace_coefficients(
        n_vec=air.eval_frame_size,
        n_coefficients=air.main_segment_width,
        coefficients=t_coefficients,
    );

    let (c_coefficients: felt*) = alloc();
    draw_elements(n_elements=air.ce_blowup_factor, elements=c_coefficients);

    let (lambda, mu) = draw_pair();

    let res = DeepCompositionCoefficients(
        trace=t_coefficients,
        constraints=c_coefficients,
        degree=(lambda, mu),
    );
    return (res=res);
}

func set_trace_coefficients{
    range_check_ptr,
    blake2s_ptr: felt*,
    bitwise_ptr: BitwiseBuiltin*,
    public_coin: PublicCoin,
}(
    n_vec: felt,
    n_coefficients: felt, 
    coefficients: TraceCoefficients*,
) -> () {
    if (n_vec == 0) {
        return ();
    }
    draw_elements(n_elements=n_coefficients, elements=coefficients);
    set_trace_coefficients(
        n_vec=n_vec - 1,
        n_coefficients=n_coefficients,
        coefficients=coefficients,
    );
    return ();
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
    coefficients_b: felt*,
) -> () {
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
