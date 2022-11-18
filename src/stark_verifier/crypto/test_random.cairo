//
// To run only this test suite use:
// protostar test --cairo-path=./src target src/stark_verifier/crypto/test_random.cairo
//

%lang starknet

from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_blake2s.blake2s import finalize_blake2s,blake2s_as_words
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from stark_verifier.crypto.random import draw_integers, random_coin_new, get_leading_zeros, draw, merge_with_int


@external
func test_merge_with_int{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (blake2s_ptr: felt*) = alloc();
    local blake2s_ptr_start: felt* = blake2s_ptr;

    let (seed) = alloc();
    assert seed[0] = 0;
    assert seed[1] = 0;
    assert seed[2] = 0;
    assert seed[3] = 0;
    assert seed[4] = 0;
    assert seed[5] = 0;
    assert seed[6] = 0;
    assert seed[7] = 0;
    
    let value = 1;

    with blake2s_ptr {
        let hash = merge_with_int(seed, value);
    }

    %{
        print('merge_with_int:', hex(memory[ids.hash]), '...', hex(memory[ids.hash+7]))
        print('expected:', '4C C6 5F A0 ... 7A 71 F7 B3')
    %} 
    finalize_blake2s(blake2s_ptr_start, blake2s_ptr);  
    return ();
}

@external
func test_draw{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (blake2s_ptr: felt*) = alloc();
    local blake2s_ptr_start: felt* = blake2s_ptr;

    tempvar seed: felt* = new (0, 0, 0, 0, 0, 0, 0, 0);
    let public_coin = random_coin_new(seed);

    with blake2s_ptr, public_coin {
        let element = draw();
    }
    %{
        print('expected: 6c b9 a1 f2 ... 58 29 f7 39')
    %} 
    finalize_blake2s(blake2s_ptr_start, blake2s_ptr);  
    return ();
}


// @external
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
    }

    %{
        for i in range(ids.n_elements):
            assert memory[ids.elements + i] < ids.domain_size
    %}

    finalize_blake2s(blake2s_ptr_start, blake2s_ptr);
    return ();
}

@external
func test_leading_zeros{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (blake2s_ptr: felt*) = alloc();
    local blake2s_ptr_start: felt* = blake2s_ptr;

    tempvar seed: felt* = new (1, 0, 0, 0, 0, 0, 0, 1);
    let public_coin = random_coin_new(seed);

    with blake2s_ptr, public_coin {
        let leading_zeros = get_leading_zeros();
    }

    %{ assert ids.leading_zeros == 31 %}
    finalize_blake2s(blake2s_ptr_start, blake2s_ptr);
    return ();
}





//
// Tests for Blake2s
//

// @external
// func test_blake2s_abc{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
//     alloc_locals;
//     let (blake2s_ptr: felt*) = alloc();
//     local blake2s_ptr_start: felt* = blake2s_ptr;

//     let (bytes) = alloc();
//     assert bytes[0] = 'cba'; // little endian order

//     with blake2s_ptr {
//         let hash: felt* = blake2s_as_words(bytes, 3);
//     }

//     // https://datatracker.ietf.org/doc/html/draft-saarinen-blake2-06
//     %{
//         print('hash', hex(memory[ids.hash]), 'expected: 50 8C 5E 8C ... 86 67 59 82')
//     %} 
//     finalize_blake2s(blake2s_ptr_start, blake2s_ptr);  
//     return ();
// }

// @external
// func test_blake2s_empty{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
//     alloc_locals;
//     let (blake2s_ptr: felt*) = alloc();
//     local blake2s_ptr_start: felt* = blake2s_ptr;

//     let (bytes) = alloc();
    
//     with blake2s_ptr {
//         let hash: felt* = blake2s_as_words(bytes, 0);
//     }
//     %{
//         print('hash', hex(memory[ids.hash]), 'should be 69217A30')
//     %} 
//     finalize_blake2s(blake2s_ptr_start, blake2s_ptr);  
//     return ();
// }
