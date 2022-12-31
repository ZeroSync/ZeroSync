//
// To run only this test suite use:
// protostar test --cairo-path=./src target tests/unit/stark_verifier/test_frame.cairo
//

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memset import memset

from stark_verifier.air.transitions.frame import EvaluationFrame, evaluate_transition

@external
func test_evaluate_transition() {
    alloc_locals;

    let (current) = alloc();
    let (next) = alloc();
    memset(current, 0, 64);
    memset(next, 0, 64);

    let (t_evaluations) = alloc();
    let frame = EvaluationFrame(0, current, 0, next);
    evaluate_transition(frame, t_evaluations);

    return ();
}