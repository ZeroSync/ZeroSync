# calculate merkle root of a merkle tree out of bitcoin block hashes
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.pow import pow
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import hash2

# felt array representation of the block header to its pedersen hash
# NOTE: I do not use the block hash here because calculating all hashes again for every merkle proof sounds infeasable
# Assumtion: Input is 80 bytes spread over 20 felts
func headerPedersenHash{pedersen_ptr : HashBuiltin*}(header : felt*) -> (pedersenHash : felt):
    # It could be cleverer to compress the block header into 5 128bit felts, but I'll just throw the hammer and calculate a huge hash chain
    let (a1) = hash2{hash_ptr=pedersen_ptr}(header[0], header[1])
    let (a2) = hash2{hash_ptr=pedersen_ptr}(header[2], header[3])
    let (a3) = hash2{hash_ptr=pedersen_ptr}(header[4], header[5])
    let (a4) = hash2{hash_ptr=pedersen_ptr}(header[6], header[7])
    let (a5) = hash2{hash_ptr=pedersen_ptr}(header[8], header[9])
    let (a6) = hash2{hash_ptr=pedersen_ptr}(header[10], header[11])
    let (a7) = hash2{hash_ptr=pedersen_ptr}(header[12], header[13])
    let (a8) = hash2{hash_ptr=pedersen_ptr}(header[14], header[15])
    let (a9) = hash2{hash_ptr=pedersen_ptr}(header[16], header[17])
    let (a10) = hash2{hash_ptr=pedersen_ptr}(header[18], header[19])

    let (b1) = hash2{hash_ptr=pedersen_ptr}(a1, a2)
    let (b2) = hash2{hash_ptr=pedersen_ptr}(a3, a4)
    let (b3) = hash2{hash_ptr=pedersen_ptr}(a5, a6)
    let (b4) = hash2{hash_ptr=pedersen_ptr}(a7, a8)
    let (b5) = hash2{hash_ptr=pedersen_ptr}(a9, a10)

    let (c1) = hash2{hash_ptr=pedersen_ptr}(b1, b2)
    let (c2) = hash2{hash_ptr=pedersen_ptr}(b3, b4)

    let (d1) = hash2{hash_ptr=pedersen_ptr}(c1, c2)
    let (pedersenHash) = hash2{hash_ptr=pedersen_ptr}(d1, b5)
    return (pedersenHash)
end

# create array of all block headers' pedersen hashes
func prepareMerkleTree{pedersen_ptr : HashBuiltin*}(
    leaves_ptr : felt*, blockData : felt**, size, step
):
    let (tmp) = headerPedersenHash(blockData[step])
    assert leaves_ptr[step] = tmp
    if step + 1 == size:
        return ()
    end
    prepareMerkleTree(leaves_ptr, blockData, size, step + 1)
    return ()
end

# start with left_index = 0 and right_index is 2**Height-1 -> can calc the height with a hint
func createMerkleTree{pedersen_ptr : HashBuiltin*, range_check_ptr}(
    leaves_ptr : felt*, left_index : felt, leaves_ptr_len : felt, height : felt
) -> (root : felt):
    alloc_locals
    if height == 0:
        let tmp = leaves_ptr[left_index]
        return (leaves_ptr[left_index])
    end
    local curr1
    local curr2
    let (tmp) = createMerkleTree(leaves_ptr, left_index, leaves_ptr_len, height - 1)
    curr1 = tmp
    let (intervalSize) = pow(2, height)
    let right_index = left_index + intervalSize - 1
    let (rightSubTreeLeftIndex, r) = unsigned_div_rem(left_index + right_index, 2)

    let (outOfBounds) = is_le_felt(leaves_ptr_len, rightSubTreeLeftIndex + 1)
    if outOfBounds == 1:
        return (curr1)
    else:
        let (curr2) = createMerkleTree(
            leaves_ptr, rightSubTreeLeftIndex + 1, leaves_ptr_len, height - 1
        )
    end

    let (le) = is_le_felt(curr1, curr2)

    if le == 1:
        let (n) = hash2{hash_ptr=pedersen_ptr}(curr1, curr2)
        let root = n
    else:
        let (n) = hash2{hash_ptr=pedersen_ptr}(curr2, curr1)
        let root = n
    end
    return (root)
end
