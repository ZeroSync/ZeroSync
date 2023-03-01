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
func lagrange_sum_eval(y_values: felt*, x_values: felt*, n_points, x, j) -> felt {
    alloc_locals;
    if (j + 1 == n_points) {
        let l_j = lagrange_basis_eval(x_values, n_points, x, j, 0);
        return y_values[j] * l_j;
    }
    
    // Reduce to the sum of all l_j * y_j
    let old_sum = lagrange_sum_eval(y_values, x_values, n_points, x, j + 1);
    let l_j = lagrange_basis_eval(x_values, n_points, x, j, 0);
    return y_values[j] * l_j + old_sum;
}

// Evaluate with input x using Lagrange interpolation over evaluations.
func lagrange_eval(y_values: felt*, x_values: felt*, n_points, x) -> felt {   
    return lagrange_sum_eval(y_values, x_values, n_points, x, 0);
}


// Interpolate the Lagrange polynomial derived from `n_points` many points,
// given as arrays of their `x_values` and `y_values`.
func interpolate_poly(x_values:felt*, y_values:felt*, n_points) -> felt* {
    alloc_locals;
    let (local polynomial) = alloc();
    %{
        from src.stark_verifier.utils import interpolate_poly
        interpolate_poly(ids.x_values, ids.y_values, ids.n_points, ids.polynomial, memory)
    %}
    // TODO: move hint verification code here
    return polynomial;
}


