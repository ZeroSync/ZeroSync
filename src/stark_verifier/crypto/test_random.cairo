//
// To run only this test suite use:
// protostar test --cairo-path=./src target src/stark_verifier/crypto/test_random.cairo
//

%lang starknet

from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_blake2s.blake2s import finalize_blake2s
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from stark_verifier.crypto.random import draw_integers, random_coin_new, get_leading_zeros, draw

@external
func test_draw_integers{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (blake2s_ptr: felt*) = alloc();
    local blake2s_ptr_start: felt* = blake2s_ptr;

    tempvar seed: felt* = new (0, 0, 0, 0, 0, 0, 0, 0);
    let public_coin = random_coin_new(seed);

    let (elements) = alloc();
    let n_elements = 4;
    let domain_size = 2 ** 5;

    with blake2s_ptr, public_coin {
        draw_integers(n_elements, elements, domain_size);
        %{
            for i in range(ids.n_elements):
                assert memory[ids.elements + i] < ids.domain_size
        %}
        // A hint may not be the last command in a code block.
        // Here comes a random command to make the Cairo compiler happy:
        tempvar foo = 42 + elements[0];
    }

    finalize_blake2s(blake2s_ptr_start, blake2s_ptr);
    return ();
}

@external
func test_leading_zeros{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (blake2s_ptr: felt*) = alloc();
    local blake2s_ptr_start: felt* = blake2s_ptr;

    // let seed = Uint256(1, 2**128 / 2**32);
    tempvar seed: felt* = new (1, 0, 0, 0, 0, 0, 0, 1);
    let public_coin = random_coin_new(seed);

    with blake2s_ptr, public_coin {
        let leading_zeros = get_leading_zeros();
        %{ assert ids.leading_zeros == 31 %}
        finalize_blake2s(blake2s_ptr_start, blake2s_ptr);
        return ();
    }
}
