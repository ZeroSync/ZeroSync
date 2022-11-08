// Wrapper library for a sha256 implementation to be used
//
// Allows to switch between different implementations and dummies
//
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc

from serialize.serialize import byte_size_to_felt_size
from crypto.ripemd160.rmd160 import compute_rmd160

func ripemd160{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    input: felt*, byte_size) -> (hash: felt*) {
    let (felt_size) = byte_size_to_felt_size(byte_size);
    let rmd160_ptr: felt* = alloc();
    let rmd160_ptr_start = rmd160_ptr;
    let (hash) = compute_rmd160{rmd160_ptr=rmd160_ptr}(data=input, n_bytes=byte_size, n_felts=felt_size);
    return (hash,);
}
