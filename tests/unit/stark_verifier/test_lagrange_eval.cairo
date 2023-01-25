//
// To run only this test suite use:
// make test TEST_PATH="stark_verifier/test_lagrange_eval.cairo"
// 

%lang starknet

from starkware.cairo.common.alloc import alloc

from stark_verifier.fri.utils import lagrange_eval, lagrange_basis_eval, lagrange_sum_eval, evaluate_polynomial

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
func test_evaluate_polynomial() {
    let evaluations_len = 2;
    let (evaluations_x) = alloc();
    let (evaluations_y) = alloc();

    assert evaluations_x[0] = 0;
    assert evaluations_x[1] = 2;
    
    // Unused - left here to reconstruct the polynomial.
    assert evaluations_y[0] = 4;
    assert evaluations_y[1] = 0;

    let alpha = 3;
    let x = 6;
    
    let expected_result = 1 / 2;
    let result = evaluate_polynomial(evaluations_x, evaluations_len, x, alpha);

    assert expected_result = result;
    return ();
}
