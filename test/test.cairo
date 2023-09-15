// %builtins output pedersen

// from starkware.cairo.common.cairo_builtins import HashBuiltin
// from starkware.cairo.common.hash import hash2
// from lib.types import Keccak256Hash, IntsSequence, RLPItem

// // Implicit arguments: addresses of the output and pedersen
// // builtins.
// func main{output_ptr, pedersen_ptr: HashBuiltin*}() {
//     // The following line implicitly updates the pedersen_ptr
//     // reference to pedersen_ptr + 3.
//     let (res) = hash2{hash_ptr=pedersen_ptr}(3, 5);
//     assert [output_ptr] = res;

//     // Manually update the output builtin pointer.
//     let output_ptr = output_ptr + 1;

//     // output_ptr and pedersen_ptr will be implicitly returned.
//     return ();
// }

from lib.types import IntsSequence
from lib.blockheader_rlp_extractor import (
    decode_receipts_root,
    Keccak256Hash,
)

from starkware.cairo.common.alloc import alloc

// func test_decode_receipts_root(output_ptr) {
//     test_decode_receipts_root();
//     assert [output_ptr] = res;
//     let output_ptr = output_ptr + 1;
// }

func main{output_ptr, range_check_ptr}() -> () {
    alloc_locals;
    local block_rlp_len_bytes;
    local block_rlp_len;
    let (block_rlp: felt*) = alloc();
    %{
        from mocks.blocks import mocked_blocks
        from utils.block_header import build_block_header
        from utils.types import Data
        from web3 import Web3

        block = mocked_blocks[0]
        block_header = build_block_header(block)
        block_rlp = block_header.raw_rlp()
        assert block_header.hash() == block["hash"]
        block_rlp_formatted = Data.from_bytes(block_rlp).to_ints()

        ids.block_rlp_len_bytes = block_rlp_formatted.length
        ids.block_rlp_len = len(block_rlp_formatted.values)
        segments.write_arg(ids.block_rlp, block_rlp_formatted.values)
    %}
    let (receipts_root) = helper_test_decode_receipts_root(
        block_rlp_len_bytes, block_rlp_len, block_rlp
    );
    %{
        extracted = [ids.receipts_root.word_1, ids.receipts_root.word_2, ids.receipts_root.word_3, ids.receipts_root.word_4]
        l = list(map(lambda x: str(hex(x)[2:]), extracted))
        formatted_hash = '0x' + ''.join(l)
        assert Web3.toBytes(hexstr=formatted_hash) == block["receiptsRoot"]
    %}
    assert [output_ptr] = receipts_root;
    let output_ptr = output_ptr + 1;
    return ();
}

func helper_test_decode_receipts_root{range_check_ptr}(
    block_rlp_len_bytes: felt, block_rlp_len: felt, block_rlp: felt*
) -> (res: Keccak256Hash) {
    alloc_locals;
    local input: IntsSequence = IntsSequence(block_rlp, block_rlp_len, block_rlp_len_bytes);
    let (local receipts_root: Keccak256Hash) = decode_receipts_root(input);
    return (receipts_root,);
}