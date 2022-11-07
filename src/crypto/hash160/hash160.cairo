from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc

from serialize.serialize import byte_size_to_felt_size, UINT32_SIZE
from crypto.ripemd160.ripemd160 import ripemd160
from crypto.sha256.sha256 import compute_sha256

func hash160{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, sha256_ptr: felt*}(
     input: felt*, byte_size
) -> (hash: felt*) {
     alloc_locals;
     //let (felt_size) = byte_size_to_felt_size(byte_size);
     let (partial_result) =  compute_sha256(input, byte_size);
     let (hash) = ripemd160(partial_result, 32);
     return (hash,);
}