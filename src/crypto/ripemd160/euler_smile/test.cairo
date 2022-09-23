%builtins output range_check bitwise

from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.default_dict import default_dict_new
from starkware.cairo.common.dict import dict_new, dict_write, dict_squash
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.math import unsigned_div_rem
from rmd160 import init, compress, finish, dict_to_array
from utils import BYTES_TO_WORD, MAX_BYTE, uint8_div
from pow2 import pow2

func RMD{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}(msg: felt*, msglen: felt) -> (hash: felt*):
    alloc_locals
    let (local buf: felt*) = alloc()
    let (local arr_x: felt*) = alloc()

    # 1. init magic constants
    init(buf, 5)

    # 2. compress data
    let (x) = default_dict_new(0)
    let start = x
    let (res, rsize, new_msg) = compress_data{dict_ptr=x, bitwise_ptr=bitwise_ptr}(buf, 5, msg, msglen)
    let (_, _) = dict_squash{range_check_ptr=range_check_ptr}(start, x)

    # 3. finish hash
    let (res, _) = finish(res, rsize, new_msg, msglen, 0)

    # 4. [optional]convert words to bytes
    let (hash) = default_dict_new(0)
    let h0 = hash
    buf2hash{dict_ptr=hash, bitwise_ptr=bitwise_ptr}(res, 0)
    dict_to_array{dict_ptr=hash}(arr_x, 20)
    let (_, _) = dict_squash{range_check_ptr=range_check_ptr}(h0, hash)

    # 5. return bytes hash code.
    return (hash=arr_x)
end

func buf2hash{range_check_ptr, dict_ptr: DictAccess*, bitwise_ptr: BitwiseBuiltin*}(buf: felt*, index: felt):
    if index == 20:
        return ()
    end

    let (index_4, _) = unsigned_div_rem(index, 4)
    let val_4 = buf[index_4]
    let (pow2_8) = pow2(8)
    let (pow2_16) = pow2(16)
    let (pow2_24) = pow2(24)
    let (val_1) = uint8_div(val_4, pow2_8)
    let (val_2) = uint8_div(val_4, pow2_16)
    let (val_3) = uint8_div(val_4, pow2_24)
    let (val_4) = uint8_div(val_4, 1)

    dict_write{dict_ptr=dict_ptr}(index, val_4)
    dict_write{dict_ptr=dict_ptr}(index + 1, val_1)
    dict_write{dict_ptr=dict_ptr}(index + 2, val_2)
    dict_write{dict_ptr=dict_ptr}(index + 3, val_3)

    buf2hash{dict_ptr=dict_ptr, bitwise_ptr=bitwise_ptr}(buf, index+4)
    return ()
end

func parse_msg{dict_ptr: DictAccess*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(msg: felt*, index: felt):
    if index == 16:
        return ()
    end

    let (val) = BYTES_TO_WORD(msg)
    dict_write{dict_ptr=dict_ptr}(index, val)
    parse_msg{dict_ptr=dict_ptr, bitwise_ptr=bitwise_ptr}(msg=msg+4, index=index+1)
    return ()
end

func compress_data{dict_ptr: DictAccess*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(buf: felt*, bufsize: felt, msg: felt*, msglen: felt) -> (res: felt*, rsize: felt, new_msg: felt*):
    alloc_locals
    let (len_lt_63) = is_le(msglen, 63)
    if len_lt_63 == 1:
        return (buf, bufsize, msg)
    end

    parse_msg{dict_ptr=dict_ptr}(msg, 0)
    let (local arr_x: felt*) = alloc()
    dict_to_array{dict_ptr=dict_ptr}(arr_x, 16)
    local dict_ptr : DictAccess* = dict_ptr
    let (res, rsize) = compress(buf, bufsize, arr_x, 16)
    let new_msg = msg+64
    let (res, rsize, new_msg) = compress_data{dict_ptr=dict_ptr, bitwise_ptr=bitwise_ptr}(res, rsize, new_msg, msglen-64)
    return (res=res, rsize=rsize, new_msg=new_msg)
end

func main{output_ptr : felt*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}():
    let (hash) = test2()
    serialize_word(hash[0])
    serialize_word(hash[1])
    serialize_word(hash[2])
    serialize_word(hash[3])
    serialize_word(hash[4])
    serialize_word(hash[5])
    serialize_word(hash[6])
    serialize_word(hash[7])
    serialize_word(hash[8])
    serialize_word(hash[9])
    serialize_word(hash[10])
    serialize_word(hash[11])
    serialize_word(hash[12])
    serialize_word(hash[13])
    serialize_word(hash[14])
    serialize_word(hash[15])
    serialize_word(hash[16])
    serialize_word(hash[17])
    serialize_word(hash[18])
    serialize_word(hash[19])

    return ()
end

func test1{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() -> (hash: felt*):
    # test vectors:
    # message: "a"
    # hashcode: 0bdc9d2d256b3ee9daae347be6f4dc835a467ffe
    alloc_locals
    let (local msg: felt*) = alloc()
    assert [msg] = 97
    let (hash) = RMD(msg, 1)
    return (hash=hash)
end

func test2{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() -> (hash: felt*):
    # test vectors:
    # message: "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopqabcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
    # hashcode: 69a155bddf855b0973a0791d5b7a3326fb83e163
    alloc_locals
    let (local msg: felt*) = alloc()
    assert [msg + 0] = 97
    assert [msg + 1] = 98
    assert [msg + 2] = 99
    assert [msg + 3] = 100
    assert [msg + 4] = 98
    assert [msg + 5] = 99
    assert [msg + 6] = 100
    assert [msg + 7] = 101
    assert [msg + 8] = 99
    assert [msg + 9] = 100
    assert [msg + 10] = 101
    assert [msg + 11] = 102
    assert [msg + 12] = 100
    assert [msg + 13] = 101
    assert [msg + 14] = 102
    assert [msg + 15] = 103
    assert [msg + 16] = 101
    assert [msg + 17] = 102
    assert [msg + 18] = 103
    assert [msg + 19] = 104
    assert [msg + 20] = 102
    assert [msg + 21] = 103
    assert [msg + 22] = 104
    assert [msg + 23] = 105
    assert [msg + 24] = 103
    assert [msg + 25] = 104
    assert [msg + 26] = 105
    assert [msg + 27] = 106
    assert [msg + 28] = 104
    assert [msg + 29] = 105
    assert [msg + 30] = 106
    assert [msg + 31] = 107
    assert [msg + 32] = 105
    assert [msg + 33] = 106
    assert [msg + 34] = 107
    assert [msg + 35] = 108
    assert [msg + 36] = 106
    assert [msg + 37] = 107
    assert [msg + 38] = 108
    assert [msg + 39] = 109
    assert [msg + 40] = 107
    assert [msg + 41] = 108
    assert [msg + 42] = 109
    assert [msg + 43] = 110
    assert [msg + 44] = 108
    assert [msg + 45] = 109
    assert [msg + 46] = 110
    assert [msg + 47] = 111
    assert [msg + 48] = 109
    assert [msg + 49] = 110
    assert [msg + 50] = 111
    assert [msg + 51] = 112
    assert [msg + 52] = 110
    assert [msg + 53] = 111
    assert [msg + 54] = 112
    assert [msg + 55] = 113
    assert [msg + 56] = 97
    assert [msg + 57] = 98
    assert [msg + 58] = 99
    assert [msg + 59] = 100
    assert [msg + 60] = 98
    assert [msg + 61] = 99
    assert [msg + 62] = 100
    assert [msg + 63] = 101
    assert [msg + 64] = 99
    assert [msg + 65] = 100
    assert [msg + 66] = 101
    assert [msg + 67] = 102
    assert [msg + 68] = 100
    assert [msg + 69] = 101
    assert [msg + 70] = 102
    assert [msg + 71] = 103
    assert [msg + 72] = 101
    assert [msg + 73] = 102
    assert [msg + 74] = 103
    assert [msg + 75] = 104
    assert [msg + 76] = 102
    assert [msg + 77] = 103
    assert [msg + 78] = 104
    assert [msg + 79] = 105
    assert [msg + 80] = 103
    assert [msg + 81] = 104
    assert [msg + 82] = 105
    assert [msg + 83] = 106
    assert [msg + 84] = 104
    assert [msg + 85] = 105
    assert [msg + 86] = 106
    assert [msg + 87] = 107
    assert [msg + 88] = 105
    assert [msg + 89] = 106
    assert [msg + 90] = 107
    assert [msg + 91] = 108
    assert [msg + 92] = 106
    assert [msg + 93] = 107
    assert [msg + 94] = 108
    assert [msg + 95] = 109
    assert [msg + 96] = 107
    assert [msg + 97] = 108
    assert [msg + 98] = 109
    assert [msg + 99] = 110
    assert [msg + 100] = 108
    assert [msg + 101] = 109
    assert [msg + 102] = 110
    assert [msg + 103] = 111
    assert [msg + 104] = 109
    assert [msg + 105] = 110
    assert [msg + 106] = 111
    assert [msg + 107] = 112
    assert [msg + 108] = 110
    assert [msg + 109] = 111
    assert [msg + 110] = 112
    assert [msg + 111] = 113

    let (hash) = RMD(msg, 112)
    return (hash=hash)
end