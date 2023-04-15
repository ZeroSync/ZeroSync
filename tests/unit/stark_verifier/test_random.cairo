//
// To run only this test suite use:
// make test TEST_PATH="stark_verifier/test_random.cairo"
//

%lang starknet

from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
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
    assert_le_lzcnt,
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
func test_merge_with_int{range_check_ptr, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    tempvar seed = 0x5337;
    
    let value = 1;

    with pedersen_ptr {
        let hash = merge_with_int(seed, value);
    }

    %{
        from zerosync_hints import *
        a = hex(ids.hash)[2:].zfill(64)
        b = merge_with_int().zfill(64)
        assert int(a, 16) == int(b, 16), f"{a} != {b}"
    %} 
    return ();
}

@external
func test_merge{range_check_ptr, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    tempvar seed = 0x5337;
    tempvar value = 1;

    with pedersen_ptr {
        let hash = merge(seed, value);
    }

    %{
        from zerosync_hints import *
        a = hex(ids.hash)[2:].zfill(64)
        b = merge().zfill(64)
        assert a == b, f"{a} != {b}"
    %}
    return ();
}

@external
func test_draw{range_check_ptr, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    tempvar seed = 0x5337;
    with pedersen_ptr {
        let public_coin = random_coin_new(seed);
    }

    with pedersen_ptr, public_coin {
        let element = draw();
    }
    
    %{
        from zerosync_hints import *
        a = hex(ids.element)[2:].zfill(64)
        b = draw_felt().zfill(64)
        assert int(a, 16) % PRIME == int(b, 16) % PRIME, f"{a} != {b}"
    %} 
    return ();
}

@external
func test_draw_integers{range_check_ptr, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    tempvar seed = 0x5337;
    with pedersen_ptr {
        let public_coin = random_coin_new(seed);
    }

    let (local elements) = alloc();
    let n_elements = 20;
    let domain_size = 64;

    with pedersen_ptr, public_coin {
        draw_integers(n_elements, elements, domain_size);
    }

    %{
        # TODO: double-check those values
        expected = [39, 31, 4, 46, 32, 61, 27, 5, 44, 12, 37, 3, 6, 9, 63, 45, 48, 30, 17, 33]
        for i in range(ids.n_elements):
            assert memory[ids.elements + i] == expected[i]
    %}
    return ();
}

@external
func test_reseed_with_int{range_check_ptr, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    tempvar seed = 0x800000007000000060000000500000004000000030000000200000001;
    with pedersen_ptr {
        let public_coin = random_coin_new(seed);
    }

    with pedersen_ptr, public_coin  {
        reseed_with_int(1337);
        let reseed_coin_z = draw();
    }

    %{
        from zerosync_hints import *
        expected_z = reseed_with_int()
        assert int(expected_z, 16) % PRIME == ids.reseed_coin_z, f"{expected_z} != {hex(ids.reseed_coin_z)[2:]}"
    %}

    return ();
}

@external
func test_assert_le_lzcnt{bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    assert_le_lzcnt(10, 0x07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAAAAAAAAAAAAAAAAAAAAAAAAFFFFF800);
    assert_le_lzcnt(11, 0x07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAAAAAAAAAAAAAAAAAAAAAAAAFFFFF800);
    %{ expect_revert() %}
    assert_le_lzcnt(12, 0x07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAAAAAAAAAAAAAAAAAAAAAAAAFFFFF800);
    
    assert_le_lzcnt(16, 0x7FFFFFFFFFE0000);
    assert_le_lzcnt(17, 0x7FFFFFFFFFE0000);
    %{ expect_revert() %}
    assert_le_lzcnt(18, 0x7FFFFFFFFFE0000);
    return ();
}

// TODO: Test for a grinded seed


/// Test Pedersen hash chain
@external
func test_pedersen_chain{
    range_check_ptr, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*
}() {
    tempvar values: felt* = new (1, 1);
    let (hash_state_ptr) = hash_init();
    let (hash_state_ptr) = hash_update{hash_ptr=pedersen_ptr}(
        hash_state_ptr=hash_state_ptr,
        data_ptr=values,
        data_length=2
    );
    let (out) = hash_finalize{hash_ptr=pedersen_ptr}(hash_state_ptr=hash_state_ptr);
    %{
        from zerosync_hints import *
        a = hex(ids.out)[2:].zfill(64)
        b = pedersen_chain()
        assert a == b, f"{a} != {b}"
    %} 
    return ();
}

/// Test public input hash
@external
func test_hash_pub_inputs{
    range_check_ptr, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;

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
        from zerosync_hints import *
        a = ids.pub_mem_hash
        b = int(hash_pub_inputs(), 16)
        assert a == b, f"{a} != {b}"
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

    let pub_inputs: PublicInputs* = read_public_inputs();
    with pedersen_ptr {
        let public_coin_seed: felt* = seed_with_pub_inputs(pub_inputs);
    }
    %{
        from zerosync_hints import *
        a = hex(ids.public_coin_seed)[2:].zfill(64)
        b = seed_with_pub_inputs().zfill(64)
        assert a == b, f"{a} != {b}"
    %} 
    return ();
}

/// Test hash_elements
@external
func test_hash_elements{
    range_check_ptr,
    pedersen_ptr: HashBuiltin*,
    bitwise_ptr: BitwiseBuiltin*,
}() {
    alloc_locals;

    tempvar elements: felt* = new (1, 0);
    let n_elements = 2;

    with pedersen_ptr {
        let elements_hash = hash_elements(n_elements, elements);
    }

    %{
        from zerosync_hints import *
        a = hex(ids.elements_hash)[2:].zfill(64)
        b = hash_elements().zfill(64)
        assert a == b, f"{a} != {b}"
    %}
    return ();
}
