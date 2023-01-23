//
// To run only this test suite use:
// make test TEST_PATH="stark_verifier/test_random.cairo"
//

%lang starknet

from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.hash import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_blake2s.blake2s import finalize_blake2s,blake2s_as_words
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.hash_state import hash_finalize, hash_init, hash_update

from stark_verifier.air.pub_inputs import (
    MemEntry,
    PublicInputs,
    read_public_inputs,
    read_mem_values,
)
from stark_verifier.crypto.random import (
    draw_integers,
    random_coin_new,
    get_leading_zeros,
    draw,
    merge_with_int,
    merge,
    seed_with_pub_inputs,
    hash_elements,
    reseed_with_int
)

@external
func __setup__() {
    %{ 
        # Compile, run, and generate proof of a fibonnaci program
        import os
        os.system('make INTEGRATION_PROGRAM_NAME=fibonacci integration_proof')
    %}
    return ();
}

@external
func test_merge_with_int{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (blake2s_ptr: felt*) = alloc();
    local blake2s_ptr_start: felt* = blake2s_ptr;

    tempvar seed = new (0, 0, 0, 0, 0, 0, 0, 0);
    
    let value = 1;

    with blake2s_ptr {
        let hash = merge_with_int(seed, value);
    }

    %{
        from src.utils.hex_utils import get_hex
        from zerosync_hints import *
        a = get_hex(memory, ids.hash)
        b = merge_with_int()
        # print("test_merge_with_int", a, b)
        assert a == b
    %} 
    finalize_blake2s(blake2s_ptr_start, blake2s_ptr);  
    return ();
}

@external
func test_merge{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (blake2s_ptr: felt*) = alloc();
    local blake2s_ptr_start: felt* = blake2s_ptr;

    tempvar seed = new (0, 0, 0, 0, 0, 0, 0, 0);
    tempvar value = new (0, 0, 0, 0, 0, 0, 0, 0);

    with blake2s_ptr {
        let hash = merge(seed, value);
    }

    %{
        from src.utils.hex_utils import get_hex
        from zerosync_hints import *
        a = get_hex(memory, ids.hash)
        b = merge()
        # print("test_merge", a, b)
        assert a == b
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
    with blake2s_ptr {
        let public_coin = random_coin_new(seed, 32);
    }

    with blake2s_ptr, public_coin {
        let element = draw();
    }
    
    %{
        from zerosync_hints import *
        a = hex(ids.element)[2:]
        b = draw_felt()
        assert int(a, 16) == int(b, 16), f"{a} != {b}"
    %} 
    finalize_blake2s(blake2s_ptr_start, blake2s_ptr);  
    return ();
}

@external
func test_draw_integers{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (blake2s_ptr: felt*) = alloc();
    local blake2s_ptr_start: felt* = blake2s_ptr;

    tempvar seed: felt* = new (0, 0, 0, 0, 0, 0, 0, 0);
    with blake2s_ptr {
        let public_coin = random_coin_new(seed, 32);
    }

    let (local elements) = alloc();
    let n_elements = 20;
    let domain_size = 64;

    with blake2s_ptr, public_coin {
        draw_integers(n_elements, elements, domain_size);
    }

    %{
        expected = [18, 10, 16, 60, 46, 13, 11, 5, 29, 30, 1, 27, 6, 36, 53, 7, 9, 12, 45, 43]
        for i in range(ids.n_elements):
            assert memory[ids.elements + i] == expected[i]
    %}
    finalize_blake2s(blake2s_ptr_start, blake2s_ptr);
    return ();
}

@external
func test_reseed_with_int{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    let (blake2s_ptr: felt*) = alloc();
    local blake2s_ptr_start: felt* = blake2s_ptr;

    tempvar seed: felt* = new (1, 2, 3, 4, 5, 6, 7, 8);
    with blake2s_ptr {
        let public_coin = random_coin_new(seed, 32);
    }

    with blake2s_ptr, public_coin  {
        reseed_with_int(1337);
        let reseed_coin_z = draw();
    }

    %{
        from zerosync_hints import *
        expected_z = reseed_with_int()
        assert int(expected_z, 16) == ids.reseed_coin_z, f"{expected_z} != {hex(ids.reseed_coin_z)[2:]}"
    %}

    finalize_blake2s(blake2s_ptr_start, blake2s_ptr);
    return ();
}

// TODO: Fix this test. Also test for a grinded seed
@external
func test_leading_zeros{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (blake2s_ptr: felt*) = alloc();
    local blake2s_ptr_start: felt* = blake2s_ptr;

    tempvar seed: felt* = new (4, 0, 0, 0, 0, 0, 0, 1);
    with blake2s_ptr {
        let public_coin = random_coin_new(seed, 32);
    }

    let leading_zeros = get_leading_zeros(public_coin.seed);

    %{ assert ids.leading_zeros == 1 %}
    finalize_blake2s(blake2s_ptr_start, blake2s_ptr);
    return ();
}

/// Test Pedersen hash chain
@external
func test_pedersen_chain{
    range_check_ptr, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*
}() {
    let (values: felt*) = alloc();
    assert values[0] = 1;
    assert values[1] = 1;
    let length = 2;

    let (hash_state_ptr) = hash_init();
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(
        hash_state_ptr=hash_state_ptr,
        data_ptr=values,
        data_length=length
    );
    let (out) = hash_finalize{hash_ptr=pedersen_ptr}(hash_state_ptr=hash_state_ptr);
    %{
        from src.utils.hex_utils import get_hex
        from zerosync_hints import *
        a = hex(ids.out)[2:].zfill(64)
        b = pedersen_chain()
        # print("test_pedersen_chain", a, b)
        assert a == b
    %} 
    return ();
}

/// Test public input hash
 @external
func test_hash_pub_inputs{
    range_check_ptr, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;

    %{ 
        from tests.integration.utils import parse_public_inputs
        json_data = parse_public_inputs('fibonacci')
    %}
    let pub_inputs: PublicInputs* = read_public_inputs();

    let (mem_values: felt*) = alloc();
    let mem_length = pub_inputs.mem_length;
    read_mem_values(
        mem=pub_inputs.mem,
        address=0,
        length=mem_length,
        output=mem_values,
    );

    let (hash_state_ptr) = hash_init();
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(
        hash_state_ptr=hash_state_ptr,
        data_ptr=mem_values,
        data_length=mem_length
    );

    let (pub_mem_hash) = hash_finalize{hash_ptr=pedersen_ptr}(hash_state_ptr=hash_state_ptr);
    %{
        from src.utils.hex_utils import get_hex
        from zerosync_hints import *
        a = ids.pub_mem_hash
        b = int(hash_pub_inputs(), 16)
        # print("test_hash_pub_inputs", a, b)
        assert a == b
    %} 
    return ();
}

/// Test public coin seed generation
@external
func test_public_coin_seed{
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
}() {
    alloc_locals;

    let (blake2s_ptr: felt*) = alloc();
    local blake2s_ptr_start: felt* = blake2s_ptr;

    %{ 
        from tests.integration.utils import parse_public_inputs
        json_data = parse_public_inputs('fibonacci')
    %}
    let pub_inputs: PublicInputs* = read_public_inputs();

    let public_coin_seed: felt* = seed_with_pub_inputs{blake2s_ptr=blake2s_ptr}(pub_inputs);
    %{
        from src.utils.hex_utils import get_hex
        from zerosync_hints import *
        a = get_hex(memory, ids.public_coin_seed)
        b = seed_with_pub_inputs()
        # print("test_public_coin_seed", a, b)
        assert a == b
    %} 
    return ();
}

/// Test hash_elements
@external
func test_hash_elements{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
}() {
    alloc_locals;

    let (blake2s_ptr: felt*) = alloc();
    local blake2s_ptr_start: felt* = blake2s_ptr;

    let (elements) = alloc();
    assert elements[0] = 1;
    assert elements[1] = 0;
    let n_elements = 2;

    let elements_hash: felt* = hash_elements{blake2s_ptr=blake2s_ptr}(n_elements, elements);
    %{ 
        # TODO: Use assert here
        # print('elements_hash',hex(memory[ids.elements_hash]),hex(memory[ids.elements_hash + 7]),'\nexpected: 70012774 ... 66281d59')
    %}
    return ();
}
