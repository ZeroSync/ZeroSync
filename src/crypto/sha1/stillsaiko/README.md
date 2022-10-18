# SHA-1 in Cairo

This is a SHA-1 implementation in Cairo 0.10.

WARNING: USE THIS CODE ONLY WITH GREAT CAUTION. THERE WERE NO CODE AUDITS YET.

## Example Usage 

```Cairo
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from sha1 import sha1
func main{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    let (uint32_ptr) = alloc();
    // byte order is big endian
    assert [uint32_ptr] = 0x13370000;
    let hash = sha1(data_ptr = uint32_ptr, n_bytes = 2);
    %{ print(hex(ids.hash)) %}
    return ();
}
```
