from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc

from serialize.serialize import byte_size_to_felt_size, UINT32_SIZE

from crypto.sha256 import compute_sha256, SHA256_STATE_SIZE_FELTS

func hash256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, sha256_ptr: felt*}(
    input: felt*, byte_size: felt
) -> felt* {
    alloc_locals;
    let felt_size = byte_size_to_felt_size(byte_size);
    let result = _compute_double_sha256(felt_size, input, byte_size);
    return result;
}

// Hashing
func _compute_double_sha256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, sha256_ptr: felt*}(
    felt_size: felt, input: felt*, byte_size: felt
) -> felt* {
    alloc_locals;
    let hash_first_round = compute_sha256(input, byte_size);
    // A hash has 32 bytes
    let hash = compute_sha256(hash_first_round, SHA256_STATE_SIZE_FELTS * UINT32_SIZE);
    return hash;
}
