//
// To run only this test suite use:
// make test TEST_PATH="stark_verifier/test_polynomials.cairo"
// 

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.hash import HashBuiltin

from stark_verifier.fri.polynomials import lagrange_eval, lagrange_basis_eval, lagrange_sum_eval, interpolate_poly_and_verify

@external
func test_lagrange_eval() {
    alloc_locals;
    let evaluations_len = 3;
    let (evaluations_x) = alloc();
    let (evaluations_y) = alloc();

    assert evaluations_x[0] = 0;
    assert evaluations_x[1] = 2;
    assert evaluations_x[2] = 8;

    assert evaluations_y[0] = 4;
    assert evaluations_y[1] = 0;
    assert evaluations_y[2] = 36;

    let x = 6;
    let expected_y = 16;
    
    let resulting_y = lagrange_eval(evaluations_y, evaluations_x, evaluations_len, x);

    assert expected_y = resulting_y;
    return ();
}


@external
func test_lagrange_eval2() {
    alloc_locals;
    let (evaluations_x: felt*) = alloc();
    let (evaluations_y: felt*) = alloc();
    local degree;
    %{
        polynomial = [7, 13, 0, 23, 47, 17]
        def f(x):
            sum = 0
            for (index, coefficient) in enumerate(polynomial):
                sum += coefficient * pow(x, index, PRIME)
            return sum % PRIME


        ids.degree = len(polynomial) - 1
        for i in range(20): # Make a few more evaluations 
            x = 7*i**2 + 29  # evaluate at some random offset
            memory[ids.evaluations_x + i] = x
            memory[ids.evaluations_y + i] = f(x)
    %}
    
    let result = lagrange_eval(evaluations_y, evaluations_x, degree+1, evaluations_x[10]);
    assert result = evaluations_y[10];

    let result = lagrange_eval(evaluations_y, evaluations_x, degree+1, evaluations_x[11]);
    assert result = evaluations_y[11];

    let result = lagrange_eval(evaluations_y, evaluations_x, degree+1, evaluations_x[12]);
    assert result = evaluations_y[12];

    let result = lagrange_eval(evaluations_y, evaluations_x, degree+1, evaluations_x[13]);
    assert result = evaluations_y[13];

    let result = lagrange_eval(evaluations_y, evaluations_x, degree+1, evaluations_x[19]);
    assert result = evaluations_y[19];

    return ();
}

@external
func test_lagrange_basis_eval() {
    alloc_locals;
    let evaluations_len = 2;
    let (evaluations_x) = alloc();
    let (evaluations_y) = alloc();

    assert evaluations_x[0] = 0;
    assert evaluations_x[1] = 2;

    let x = 6;
    let expected_basis_0 = (x - evaluations_x[1]) / (evaluations_x[0] - evaluations_x[1]);
    let expected_basis_1 = (x - evaluations_x[0]) / (evaluations_x[1] - evaluations_x[0]);


    let basis_0 = lagrange_basis_eval(evaluations_x, evaluations_len, x, 0, 0);
    let basis_1 = lagrange_basis_eval(evaluations_x, evaluations_len, x, 1, 0);

    assert expected_basis_0 = basis_0;
    assert expected_basis_1 = basis_1;
    return ();
}


@external
func test_lagrange_sum_eval() {
    alloc_locals;
    let evaluations_len = 2;
    let (evaluations_x) = alloc();
    let (evaluations_y) = alloc();

    assert evaluations_x[0] = 0;
    assert evaluations_x[1] = 2;

    assert evaluations_y[0] = 4;
    assert evaluations_y[1] = 0;

    let x = 6;
    let expected_y = 16;

    let basis_0 = (x - evaluations_x[1]) / (evaluations_x[0] - evaluations_x[1]);
    let basis_1 = (x - evaluations_x[0]) / (evaluations_x[1] - evaluations_x[0]);

    local expected_sum = evaluations_y[0] * basis_0 + evaluations_y[1] * basis_1;
    
    let sum = lagrange_sum_eval(evaluations_y, evaluations_x, evaluations_len, x, 0);
    assert expected_sum = sum;
    return ();
}


@external
func test_interpolate_poly_and_verify{pedersen_ptr: HashBuiltin*}() {
    alloc_locals;
    local evaluations_len;
    let (evaluations_x: felt*) = alloc();
    let (evaluations_y: felt*) = alloc();
    let (expected_polynomial: felt*) = alloc();
    local degree;
    %{
        polynomial = [1,7,2,11]
        def f(x):
            sum = 0
            for (index, coefficient) in enumerate(polynomial):
                sum += coefficient * pow(x, index, PRIME)
            return sum

        ids.degree = len(polynomial) - 1
        ids.evaluations_len = 20  # Make a few more evaluations 
        for i in range(ids.evaluations_len):
            x = 7*i**2 + 29  # evaluate at some random offset
            memory[ids.evaluations_x + i] = x
            memory[ids.evaluations_y + i] = f(x)

        for (index, coefficient) in enumerate(polynomial):
            memory[ids.expected_polynomial + index] = coefficient
    %}
    
    let polynomial = interpolate_poly_and_verify(evaluations_x, evaluations_y, degree + 1);
    
    assert expected_polynomial[0] = polynomial[0];
    assert expected_polynomial[1] = polynomial[1];
    assert expected_polynomial[2] = polynomial[2];
    assert expected_polynomial[3] = polynomial[3];
  

    return ();
}