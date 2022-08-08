from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.alloc import alloc
from utils import _compute_double_sha256
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

func compute_merkle_root{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(leaves : felt*, leaves_len : felt) -> (hash : felt*):
	alloc_locals

	if leaves_len == 1:
	 	let (root_hash) = _compute_double_sha256(8, leaves, 8 * 4)
		return (root_hash)
	end
	
	let (_, is_odd) = unsigned_div_rem(leaves_len, 2)

	# padding (duplicate last leaf)
	if is_odd == 1:
		assert leaves[leaves_len * 8 + 0] = leaves[(leaves_len - 1) * 8 + 0]
		assert leaves[leaves_len * 8 + 1] = leaves[(leaves_len - 1) * 8 + 1]
		assert leaves[leaves_len * 8 + 2] = leaves[(leaves_len - 1) * 8 + 2]
		assert leaves[leaves_len * 8 + 3] = leaves[(leaves_len - 1) * 8 + 3]
		assert leaves[leaves_len * 8 + 4] = leaves[(leaves_len - 1) * 8 + 4]
		assert leaves[leaves_len * 8 + 5] = leaves[(leaves_len - 1) * 8 + 5]
		assert leaves[leaves_len * 8 + 6] = leaves[(leaves_len - 1) * 8 + 6]
		assert leaves[leaves_len * 8 + 7] = leaves[(leaves_len - 1) * 8 + 7]
	end

	let leaves_out_len = (leaves_len + is_odd) / 2

	let (leaves_out) = alloc()
	_compute_merkle_root_loop(leaves, leaves_out_len, leaves_out, 0)

	return compute_merkle_root(leaves_out, leaves_out_len)
end

func _compute_merkle_root_loop{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(
	leaves_in : felt*, leaves_out_len : felt, leaves_out : felt*, index : felt):
	
	if index == leaves_out_len:
		return ()
	end

	let (hash : felt*) = _compute_double_sha256(16, leaves_in, 16 * 4)

	assert leaves_out[0] = hash[0]
	assert leaves_out[1] = hash[1]
	assert leaves_out[2] = hash[2]
	assert leaves_out[3] = hash[3]
	assert leaves_out[4] = hash[4]
	assert leaves_out[5] = hash[5]
	assert leaves_out[6] = hash[6]
	assert leaves_out[7] = hash[7]

	return _compute_merkle_root_loop(leaves_in + 16, leaves_out_len, leaves_out + 8, index + 1)

end