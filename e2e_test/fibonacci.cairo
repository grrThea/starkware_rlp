%builtins output pedersen

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import hash2

func main{output_ptr, pedersen_ptr: HashBuiltin*}() {
    let (res) = hash2{hash_ptr=pedersen_ptr}(1,2);
    assert [output_ptr] = res;
    let output_ptr = output_ptr + 1;
    return();
}

// %builtins output
// func main(output_ptr: felt*) -> (output_ptr: felt*) {
//     alloc_locals;

//     // Load fibonacci_claim_index and copy it to the output segment.
//     local fibonacci_claim_index;
//     %{ ids.fibonacci_claim_index = program_input['fibonacci_claim_index'] %}

//     assert output_ptr[0] = fibonacci_claim_index;
//     let res = fib(1, 1, fibonacci_claim_index);
//     assert output_ptr[1] = res;

//     // Return the updated output_ptr.
//     return (output_ptr=&output_ptr[2]);
// }

// func fib(first_element: felt, second_element: felt, n: felt) -> felt {
//     if (n == 0) {
//         return second_element;
//     }

//     return fib(
//         first_element=second_element, second_element=first_element + second_element, n=n - 1
//     );
// }

