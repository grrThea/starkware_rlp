%builtins output pedersen

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import hash2

func main{output_ptr, pedersen_ptr: HashBuiltin*}() {
    let (res) = hash2{hash_ptr=pedersen_ptr}(1,2);
    assert [output_ptr] = res;
    let output_ptr = output_ptr + 1;
    return();
}
