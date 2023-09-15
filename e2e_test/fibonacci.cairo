%builtins output
func main(output_ptr: felt*) -> (output_ptr: felt*) {
    alloc_locals;

    // Load fibonacci_claim_index and copy it to the output segment.
    local fibonacci_claim_index;
    %{ ids.fibonacci_claim_index = program_input['fibonacci_claim_index'] %}

    assert output_ptr[0] = fibonacci_claim_index;
    let res = fib(1, 1, fibonacci_claim_index);
    assert output_ptr[1] = res;

    // Return the updated output_ptr.
    return (output_ptr=&output_ptr[2]);
}

func fib(first_element: felt, second_element: felt, n: felt) -> felt {
    if (n == 0) {
        return second_element;
    }

    return fib(
        first_element=second_element, second_element=first_element + second_element, n=n - 1
    );
}
// %lang starknet
// %builtins pedersen range_check ecdsa

// from lib.address import address_words64_to_160bit, address_160bit_to_words64
// from lib.types import Address
// from starkware.cairo.common.alloc import alloc

// func main() {
//     alloc_locals;

// }

// func test_address_words64_to_160bit{range_check_ptr}() -> () {
//     alloc_locals;

//     let (ipt: felt*) = alloc();
//     %{
//         from utils.types import Data

//         example_addr = '0x9cB1e11D87013e70038f80381A70b6a6C4eCf519'

//         arr = Data.from_hex(example_addr).to_ints().values
//         assert len(arr) == 3

//         segments.write_arg(ids.ipt, [arr[0], arr[1], arr[2]])
//     %}

//     local input: Address = Address(ipt[0], ipt[1], ipt[2]);
//     let (res) = address_words64_to_160bit(input);

//     // int(example_addr[2:], 16)
//     assert res = 894569402460634410951006940476311615390570312985;

//     return ();
// }

// func test_address_160bit_to_words64{range_check_ptr}() -> () {
//     alloc_locals;

//     // int(example_addr[2:], 16)
//     let (res) = address_160bit_to_words64(894569402460634410951006940476311615390570312985);
//     %{
//         from utils.types import Data

//         example_addr = '0x9cB1e11D87013e70038f80381A70b6a6C4eCf519'

//         output = list([ids.res.word_1, ids.res.word_2, ids.res.word_3])
//         expected_output = Data.from_hex(example_addr).to_ints().values

//         assert output == expected_output
//     %}
//     return ();
// }
