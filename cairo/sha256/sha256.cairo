from sha256.packed_sha256 import (
    BLOCK_SIZE,
    compute_message_schedule,
    sha2_compress,
    get_round_constants,
)
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import assert_nn_le, unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le, is_in_range
from starkware.cairo.common.memset import memset
from starkware.cairo.common.pow import pow

const SHA256_INPUT_CHUNK_SIZE_FELTS = 16
const SHA256_STATE_SIZE_FELTS = 8
# Each instance consists of 16 words of message, 8 words for the input state and 8 words
# for the output state.
const SHA256_INSTANCE_SIZE = SHA256_INPUT_CHUNK_SIZE_FELTS + 2 * SHA256_STATE_SIZE_FELTS

# Computes SHA256 of 'input'. Inputs of up to 55 bytes are supported.
# To use this function, split the input into (up to) 14 words of 32 bits (big endian).
# For example, to compute sha256('Hello world'), use:
#   input = [1214606444, 1864398703, 1919706112]
# where:
#   1214606444 == int.from_bytes(b'Hell', 'big')
#   1864398703 == int.from_bytes(b'o wo', 'big')
#   1919706112 == int.from_bytes(b'rld\x00', 'big')  # Note the '\x00' padding.
#
# output is an array of 8 32-bit words (big endian).
#
# Assumption: n_bytes <= 55.
#
# Note: You must call finalize_sha2() at the end of the program. Otherwise, this function
# is not sound and a malicious prover may return a wrong result.
# Note: the interface of this function may change in the future.

# usable for up to two blocks of input (up to 119 Bytes)
func sha256{range_check_ptr, sha256_ptr : felt*}(input : felt*, n_bytes : felt) -> (output : felt*):
    alloc_locals
    assert_nn_le(n_bytes, 119)
    let sha256_start = sha256_ptr

    let (inRangeB) = is_in_range(n_bytes, 64, 120)
    let (special) = is_in_range(n_bytes, 56, 64)
    if inRangeB == 1:
        _sha256_input_nopad(input=input, n_bytes=64, n_words=SHA256_INPUT_CHUNK_SIZE_FELTS)  # copies first 16 felts of input into sha256_ptr
        tempvar range_check_ptr = range_check_ptr
    else:
        if special == 1:
            _sha256_input(input=input, n_bytes=n_bytes, n_words=SHA256_INPUT_CHUNK_SIZE_FELTS)
            tempvar range_check_ptr = range_check_ptr
        else:
            _sha256_input(input=input, n_bytes=n_bytes, n_words=SHA256_INPUT_CHUNK_SIZE_FELTS - 2)
            assert sha256_ptr[0] = 0
            assert sha256_ptr[1] = n_bytes * 8  # padding - bytestring size is attached at the end
            tempvar range_check_ptr = range_check_ptr
        end
        tempvar range_check_ptr = range_check_ptr
    end
    let sha256_ptr = sha256_start + SHA256_INPUT_CHUNK_SIZE_FELTS
    # set the initial state to IV.
    assert sha256_ptr[0] = 0x6A09E667
    assert sha256_ptr[1] = 0xBB67AE85
    assert sha256_ptr[2] = 0x3C6EF372
    assert sha256_ptr[3] = 0xA54FF53A
    assert sha256_ptr[4] = 0x510E527F
    assert sha256_ptr[5] = 0x9B05688C
    assert sha256_ptr[6] = 0x1F83D9AB
    assert sha256_ptr[7] = 0x5BE0CD19
    let sha256_ptr = sha256_ptr + SHA256_STATE_SIZE_FELTS  # input, 8 initial states

    let middle_out = sha256_ptr  # first output
    %{
        from starkware.cairo.common.cairo_sha256.sha256_utils import (
            IV, compute_message_schedule, sha2_compress_function)

        _sha256_input_chunk_size_felts = int(ids.SHA256_INPUT_CHUNK_SIZE_FELTS)
        assert 0 <= _sha256_input_chunk_size_felts < 100

        w = compute_message_schedule(memory.get_range(
            ids.sha256_start, _sha256_input_chunk_size_felts))
        new_state = sha2_compress_function(IV, w)
        segments.write_arg(ids.middle_out, new_state)
    %}
    let sha256_ptr = sha256_ptr + SHA256_STATE_SIZE_FELTS  # input, 8 initial states, middle_out

    let (fin) = is_le(n_bytes, 55)
    if fin == 1:
        let output = middle_out
        return (output)
    end

    local sha256_input_sec : felt* = sha256_ptr
    # below 64B but above 55B as input so the second Block only consists of the message size at the end and zeroes
    if special == 1:
        _sha256_input_zeroes(n_bytes=56, n_words=SHA256_INPUT_CHUNK_SIZE_FELTS - 2)
    else:
        _sha256_input(
            input=input + 16, n_bytes=n_bytes - 64, n_words=SHA256_INPUT_CHUNK_SIZE_FELTS - 2
        )  # incresases sha256_ptr
    end
    assert sha256_ptr[0] = 0
    assert sha256_ptr[1] = n_bytes * 8  # padding - bytestring size is attached at the end
    let sha256_ptr = sha256_ptr + 2  # input, 8 initial states, middle_out, input_sec

    let middle_state = sha256_ptr

    assert sha256_ptr[0] = middle_out[0]
    assert sha256_ptr[1] = middle_out[1]
    assert sha256_ptr[2] = middle_out[2]
    assert sha256_ptr[3] = middle_out[3]
    assert sha256_ptr[4] = middle_out[4]
    assert sha256_ptr[5] = middle_out[5]
    assert sha256_ptr[6] = middle_out[6]
    assert sha256_ptr[7] = middle_out[7]

    let sha256_ptr = sha256_ptr + SHA256_STATE_SIZE_FELTS  # input, 8 initial states, input_sec, middle_state

    let output = sha256_ptr
    %{
        from starkware.cairo.common.cairo_sha256.sha256_utils import (
            IV, compute_message_schedule, sha2_compress_function)

        _sha256_input_chunk_size_felts = int(ids.SHA256_INPUT_CHUNK_SIZE_FELTS)
        assert 0 <= _sha256_input_chunk_size_felts < 100

        wout = compute_message_schedule(memory.get_range(
            ids.sha256_input_sec, _sha256_input_chunk_size_felts))
        newest_state = sha2_compress_function(memory.get_range(ids.middle_state, int(ids.SHA256_STATE_SIZE_FELTS)), wout)
        segments.write_arg(ids.output, newest_state)
    %}
    let sha256_ptr = sha256_ptr + SHA256_STATE_SIZE_FELTS  # input, 8 initial states, middle_out, input_sec, middle_state, output
    return (output)
end

func _sha256_input_nopad{range_check_ptr, sha256_ptr : felt*}(
    input : felt*, n_bytes : felt, n_words : felt
):
    if n_bytes == 0:
        assert sha256_ptr = sha256_ptr + n_words
        return ()
    end
    assert sha256_ptr[0] = input[0]
    let sha256_ptr = sha256_ptr + 1
    return _sha256_input_nopad(input=input + 1, n_bytes=n_bytes - 4, n_words=n_words - 1)
end

func _sha256_input_zeroes{range_check_ptr, sha256_ptr : felt*}(n_bytes : felt, n_words : felt):
    if n_bytes == 0:
        assert sha256_ptr = sha256_ptr + n_words
        return ()
    end
    assert sha256_ptr[0] = 0
    let sha256_ptr = sha256_ptr + 1
    return _sha256_input_zeroes(n_bytes=n_bytes - 4, n_words=n_words - 1)
end

func _sha256_input{range_check_ptr, sha256_ptr : felt*}(
    input : felt*, n_bytes : felt, n_words : felt
):
    alloc_locals

    local full_word
    %{ ids.full_word = int(ids.n_bytes >= 4) %}

    if full_word != 0:
        assert sha256_ptr[0] = input[0]
        let sha256_ptr = sha256_ptr + 1
        return _sha256_input(input=input + 1, n_bytes=n_bytes - 4, n_words=n_words - 1)
    end

    # This is the last input word, so we should add a byte '0x80' at the end and fill the rest with
    # zeros.
    if n_bytes == 0:
        assert sha256_ptr[0] = 0x80000000
        memset(dst=sha256_ptr + 1, value=0, n=n_words - 1)
        let sha256_ptr = sha256_ptr + n_words
        return ()
    end

    assert_nn_le(n_bytes, 3)
    let (padding) = pow(256, 3 - n_bytes)
    local range_check_ptr = range_check_ptr

    assert sha256_ptr[0] = input[0] + padding * 0x80

    memset(dst=sha256_ptr + 1, value=0, n=n_words - 1)
    let sha256_ptr = sha256_ptr + n_words
    return ()
end

# Handles n blocks of BLOCK_SIZE SHA256 instances.
func _finalize_sha256_inner{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    sha256_ptr : felt*, n : felt, round_constants : felt*
):
    if n == 0:
        return ()
    end

    alloc_locals

    local MAX_VALUE = 2 ** 32 - 1

    let sha256_start = sha256_ptr

    let (local message_start : felt*) = alloc()
    let (local input_state_start : felt*) = alloc()

    # Handle message.

    tempvar message = message_start
    tempvar sha256_ptr = sha256_ptr
    tempvar range_check_ptr = range_check_ptr
    tempvar m = SHA256_INPUT_CHUNK_SIZE_FELTS

    message_loop:
    tempvar x0 = sha256_ptr[0 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 0] = x0
    assert [range_check_ptr + 1] = MAX_VALUE - x0
    tempvar x1 = sha256_ptr[1 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 2] = x1
    assert [range_check_ptr + 3] = MAX_VALUE - x1
    tempvar x2 = sha256_ptr[2 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 4] = x2
    assert [range_check_ptr + 5] = MAX_VALUE - x2
    tempvar x3 = sha256_ptr[3 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 6] = x3
    assert [range_check_ptr + 7] = MAX_VALUE - x3
    tempvar x4 = sha256_ptr[4 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 8] = x4
    assert [range_check_ptr + 9] = MAX_VALUE - x4
    tempvar x5 = sha256_ptr[5 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 10] = x5
    assert [range_check_ptr + 11] = MAX_VALUE - x5
    tempvar x6 = sha256_ptr[6 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 12] = x6
    assert [range_check_ptr + 13] = MAX_VALUE - x6
    assert message[0] = x0 + 2 ** 35 * x1 + 2 ** (35 * 2) * x2 + 2 ** (35 * 3) * x3 +
        2 ** (35 * 4) * x4 + 2 ** (35 * 5) * x5 + 2 ** (35 * 6) * x6

    tempvar message = message + 1
    tempvar sha256_ptr = sha256_ptr + 1
    tempvar range_check_ptr = range_check_ptr + 14
    tempvar m = m - 1
    jmp message_loop if m != 0

    # Handle input state.

    tempvar input_state = input_state_start
    tempvar sha256_ptr = sha256_ptr
    tempvar range_check_ptr = range_check_ptr
    tempvar m = SHA256_STATE_SIZE_FELTS

    input_state_loop:
    tempvar x0 = sha256_ptr[0 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 0] = x0
    assert [range_check_ptr + 1] = MAX_VALUE - x0
    tempvar x1 = sha256_ptr[1 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 2] = x1
    assert [range_check_ptr + 3] = MAX_VALUE - x1
    tempvar x2 = sha256_ptr[2 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 4] = x2
    assert [range_check_ptr + 5] = MAX_VALUE - x2
    tempvar x3 = sha256_ptr[3 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 6] = x3
    assert [range_check_ptr + 7] = MAX_VALUE - x3
    tempvar x4 = sha256_ptr[4 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 8] = x4
    assert [range_check_ptr + 9] = MAX_VALUE - x4
    tempvar x5 = sha256_ptr[5 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 10] = x5
    assert [range_check_ptr + 11] = MAX_VALUE - x5
    tempvar x6 = sha256_ptr[6 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 12] = x6
    assert [range_check_ptr + 13] = MAX_VALUE - x6
    assert input_state[0] = x0 + 2 ** 35 * x1 + 2 ** (35 * 2) * x2 + 2 ** (35 * 3) * x3 +
        2 ** (35 * 4) * x4 + 2 ** (35 * 5) * x5 + 2 ** (35 * 6) * x6

    tempvar input_state = input_state + 1
    tempvar sha256_ptr = sha256_ptr + 1
    tempvar range_check_ptr = range_check_ptr + 14
    tempvar m = m - 1
    jmp input_state_loop if m != 0

    # Run sha256 on the 7 instances.

    local sha256_ptr : felt* = sha256_ptr
    local range_check_ptr = range_check_ptr
    compute_message_schedule(message_start)
    let (outputs) = sha2_compress(input_state_start, message_start, round_constants)
    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr

    # Handle outputs.

    tempvar outputs = outputs
    tempvar sha256_ptr = sha256_ptr
    tempvar range_check_ptr = range_check_ptr
    tempvar m = SHA256_STATE_SIZE_FELTS

    output_loop:
    tempvar x0 = sha256_ptr[0 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr] = x0
    assert [range_check_ptr + 1] = MAX_VALUE - x0
    tempvar x1 = sha256_ptr[1 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 2] = x1
    assert [range_check_ptr + 3] = MAX_VALUE - x1
    tempvar x2 = sha256_ptr[2 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 4] = x2
    assert [range_check_ptr + 5] = MAX_VALUE - x2
    tempvar x3 = sha256_ptr[3 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 6] = x3
    assert [range_check_ptr + 7] = MAX_VALUE - x3
    tempvar x4 = sha256_ptr[4 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 8] = x4
    assert [range_check_ptr + 9] = MAX_VALUE - x4
    tempvar x5 = sha256_ptr[5 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 10] = x5
    assert [range_check_ptr + 11] = MAX_VALUE - x5
    tempvar x6 = sha256_ptr[6 * SHA256_INSTANCE_SIZE]
    assert [range_check_ptr + 12] = x6
    assert [range_check_ptr + 13] = MAX_VALUE - x6
    assert outputs[0] = x0 + 2 ** 35 * x1 + 2 ** (35 * 2) * x2 + 2 ** (35 * 3) * x3 +
        2 ** (35 * 4) * x4 + 2 ** (35 * 5) * x5 + 2 ** (35 * 6) * x6

    tempvar outputs = outputs + 1
    tempvar sha256_ptr = sha256_ptr + 1
    tempvar range_check_ptr = range_check_ptr + 14
    tempvar m = m - 1
    jmp output_loop if m != 0

    return _finalize_sha256_inner(
        sha256_ptr=sha256_start + SHA256_INSTANCE_SIZE * BLOCK_SIZE,
        n=n - 1,
        round_constants=round_constants,
    )
end

# Verifies that the results of sha256() are valid.
func finalize_sha256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    sha256_ptr_start : felt*, sha256_ptr_end : felt*
):
    alloc_locals

    let (__fp__, _) = get_fp_and_pc()

    let (round_constants) = get_round_constants()

    tempvar n = (sha256_ptr_end - sha256_ptr_start) / SHA256_INSTANCE_SIZE
    if n == 0:
        return ()
    end

    %{
        # Add dummy pairs of input and output.
        from starkware.cairo.common.cairo_sha256.sha256_utils import (
            IV, compute_message_schedule, sha2_compress_function)

        _block_size = int(ids.BLOCK_SIZE)
        assert 0 <= _block_size < 20
        _sha256_input_chunk_size_felts = int(ids.SHA256_INPUT_CHUNK_SIZE_FELTS)
        assert 0 <= _sha256_input_chunk_size_felts < 100

        message = [0] * _sha256_input_chunk_size_felts
        w = compute_message_schedule(message)
        output = sha2_compress_function(IV, w)
        padding = (message + IV + output) * (_block_size - 1)
        segments.write_arg(ids.sha256_ptr_end, padding)
    %}

    # Compute the amount of blocks (rounded up).
    let (local q, r) = unsigned_div_rem(n + BLOCK_SIZE - 1, BLOCK_SIZE)
    _finalize_sha256_inner(sha256_ptr_start, n=q, round_constants=round_constants)
    return ()
end

func compute_sha256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
    input_len : felt, input : felt*, n_bytes : felt
) -> (sha : felt*):
    alloc_locals

    let (local sha256_ptr_start : felt*) = alloc()
    let sha256_ptr = sha256_ptr_start

    let (local output : felt*) = sha256{sha256_ptr=sha256_ptr}(input, n_bytes)
    finalize_sha256(sha256_ptr_start=sha256_ptr_start, sha256_ptr_end=sha256_ptr)

    return (sha=output)
end
