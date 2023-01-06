%builtins output range_check bitwise

// Original path in repository was src/crypto/sha1
// Replaced src with zerosync to import from the installed python package
from zerosync.crypto.sha1 import sha1

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.alloc import alloc

func main{output_ptr: felt*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    let (input) = alloc();
    assert input[0] = 0x61626300;  // "abc"
    let input_length = 3;

    let result = sha1(input, input_length);

    serialize_word(result);  // should be 968236873715988614170569073515315707566766479517
    return ();
}
