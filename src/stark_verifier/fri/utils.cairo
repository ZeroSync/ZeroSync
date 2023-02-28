from starkware.cairo.common.alloc import alloc

// Evaluate l_j(x) for a fixed j and a specified x. Should loop for 0 <= m <= x_i_len.
func lagrange_basis_eval(x_i: felt*, x_i_len, x, j, m) -> felt  {
    if (m + 1 == x_i_len) {
        if (j == m) {
            return 1;
        }
        let numerator = x - x_i[m];
        let denominator = x_i[j] - x_i[m];
        
        return (numerator / denominator);
    }

    if (j == m) {
        return lagrange_basis_eval(x_i, x_i_len, x, j, m + 1);
    }

    let numerator = x - x_i[m];
    let denominator = x_i[j] - x_i[m];
    
    // Reduce to the product of all numerator / denominator
    let old_product = lagrange_basis_eval(x_i, x_i_len, x, j, m + 1);
    return (numerator / denominator) * old_product;
}


// Evaluates L(x)
func lagrange_sum_eval(evaluations_y: felt*, evaluations_x: felt*, evaluations_len, x, j) -> felt {
    alloc_locals;
    if (j + 1 == evaluations_len) {
        let l_j = lagrange_basis_eval(evaluations_x, evaluations_len, x, j, 0);
        return evaluations_y[j] * l_j;
    }
    
    // Reduce to the sum of all l_j * y_j
    let old_sum = lagrange_sum_eval(evaluations_y, evaluations_x, evaluations_len, x, j + 1);
    let l_j = lagrange_basis_eval(evaluations_x, evaluations_len, x, j, 0);
    return evaluations_y[j] * l_j + old_sum;
}

// Evaluate with input x using Lagrange interpolation over evaluations.
func lagrange_eval(evaluations_y: felt*, evaluations_x: felt*, evaluations_len, x) -> felt {   
    return lagrange_sum_eval(evaluations_y, evaluations_x, evaluations_len, x, 0);
}

// Evaluate the split and fold step of FRI commit for folding factor 2
// https://aszepieniec.github.io/stark-anatomy/fri
func evaluate_polynomial(evaluations_x : felt *, x, alpha) -> felt {
    return (1 / 2) * (evaluations_x[0] * (1 + alpha / x) + evaluations_x[1] * (1 - alpha / x));
}




func interpolate_poly(xs:felt*, ys:felt*, length) -> felt* {
    alloc_locals;
    let (local polynomial) = alloc();
    %{
        import json
        import subprocess
        from src.stark_verifier.utils import write_into_memory

        xs = []
        for i in range(ids.length):
            xs.append(hex( memory[ids.xs + i])[2::].zfill(64) )
        xs = json.dumps( xs )

        ys = []
        for i in range(ids.length):
            ys.append(hex( memory[ids.ys + i])[2::].zfill(64) )
        ys = json.dumps( ys )
        
        completed_process = subprocess.run([
            'bin/stark_parser',
            'tests/integration/stark_proofs/fibonacci.bin', # TODO: this path shouldn't be hardcoded here!
            'interpolate-poly',
            xs,
            ys,
        ], capture_output=True )
        serialized_poly = str(completed_process.stdout).replace("\\n'", "")
        polynomial = serialized_poly.split(', ')[1:]
        for i, coefficient in enumerate(polynomial):
           memory[ids.polynomial + i] = int(coefficient, 16)
    %}
    // TODO: verify this hint by evaluating the polynomial at each point
    return polynomial;
}

