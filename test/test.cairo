%builtins output range_check

from starkware.cairo.common.alloc import alloc
from lib.types import IntsSequence
from lib.blockheader_rlp_extractor import (
    decode_receipts_root,
    Keccak256Hash,
)

func main{output_ptr: Keccak256Hash* , range_check_ptr}() {
    alloc_locals;
    // local block_rlp_len_bytes;
    // local block_rlp_len;
    let (block_rlp_len_bytes: felt) = alloc();
    let (block_rlp_len: felt) = alloc();
    let (block_rlp: felt*) = alloc();
    let (hard_rlp: felt*) = alloc();
    %{
        from web3 import Web3
        from blocks import mocked_blocks
        from utils.block_header import build_block_header
        from utils.types import Data

        block = mocked_blocks[0]
        block_header = build_block_header(block)
        block_rlp = block_header.raw_rlp()
        assert block_header.hash() == block["hash"]
        block_rlp_formatted = Data.from_bytes(block_rlp).to_ints()

        ids.block_rlp_len_bytes = block_rlp_formatted.length
        ids.block_rlp_len = len(block_rlp_formatted.values)
        segments.write_arg(ids.block_rlp, block_rlp_formatted.values)
    %}
    // %{
    //     block_rlp = b'\xf9\x02\x18\xa0\x03\xb0\x16\xcc\x93\x87\xcb<\xef\x86\xd9\xd4\xaf\xb5,7\x89R\x8cS\x0c\x00 \x87\x95\xac\x93|\xe0EYj\xa0\x1d\xccM\xe8\xde\xc7]z\xab\x85\xb5g\xb6\xcc\xd4\x1a\xd3\x12E\x1b\x94\x8at\x13\xf0\xa1B\xfd@\xd4\x93G\x94\xfb\xb6\x1b\x8b\x98\xa5\x9f\xbcK\xd7\x9c#!*\xdd\xbe\xfa\xeb(\x9f\xa0\xd4\\\xea\x1d\\\xaex8oy\xe0\xd5"\xe0\xa1\xd9\x1b-\xa9_\xf8K]\xe2X\xf2\xc9\x89=?I\xb1\xa0\x14\x07O%:\x03##\x1d4\x9a?\x9cdj\xf7q\xc1\xde\xc2\xf24\xbb\x80\xaf\xedT`\xf5r\xfe\xd1\xa0Zo[\x9a\xc7Z\xe1\xe1\xf8\xc4\xaf\xef\xb94~\x14\x1b\xc5\xc9U\xb2\xede4\x1d\xf3\xe1\xd5\x99\xfc\xad\x91\xb9\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x84v\xfe)\n\x83\xae\xce\x98\x83z\x12\x00\x83\x17\xed\xcf\x84a\x97\xc0$\x99\xd8\x83\x01\n\x0c\x84geth\x88go1.17.1\x85linux\xa0s-\x0e\xad\x04\x88:\x10\x97dc\xe5\xd4\xf7\x14\xc0\xb2\xa8\x1ata4\xe9\xc24\x1fY\xb6\xc7a\x0c\x03\x88?@\xadZ\t\xe2\xd5\x00\x18';
    //     block_rlp_len_bytes = 539
    //     block_rlp_len = 69
    // %} 
    let (receipts_root) = helper_test_decode_receipts_root(
        block_rlp_len_bytes, block_rlp_len, block_rlp
    ); 
    // %{
    //     hard_rlp = b'\xf9\x02\x18\xa0\x03\xb0\x16\xcc\x93\x87\xcb<\xef\x86\xd9\xd4\xaf\xb5,7\x89R\x8cS\x0c\x00 \x87\x95\xac\x93|\xe0EYj\xa0\x1d\xccM\xe8\xde\xc7]z\xab\x85\xb5g\xb6\xcc\xd4\x1a\xd3\x12E\x1b\x94\x8at\x13\xf0\xa1B\xfd@\xd4\x93G\x94\xfb\xb6\x1b\x8b\x98\xa5\x9f\xbcK\xd7\x9c#!*\xdd\xbe\xfa\xeb(\x9f\xa0\xd4\\\xea\x1d\\\xaex8oy\xe0\xd5"\xe0\xa1\xd9\x1b-\xa9_\xf8K]\xe2X\xf2\xc9\x89=?I\xb1\xa0\x14\x07O%:\x03##\x1d4\x9a?\x9cdj\xf7q\xc1\xde\xc2\xf24\xbb\x80\xaf\xedT`\xf5r\xfe\xd1\xa0Zo[\x9a\xc7Z\xe1\xe1\xf8\xc4\xaf\xef\xb94~\x14\x1b\xc5\xc9U\xb2\xede4\x1d\xf3\xe1\xd5\x99\xfc\xad\x91\xb9\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x84v\xfe)\n\x83\xae\xce\x98\x83z\x12\x00\x83\x17\xed\xcf\x84a\x97\xc0$\x99\xd8\x83\x01\n\x0c\x84geth\x88go1.17.1\x85linux\xa0s-\x0e\xad\x04\x88:\x10\x97dc\xe5\xd4\xf7\x14\xc0\xb2\xa8\x1ata4\xe9\xc24\x1fY\xb6\xc7a\x0c\x03\x88?@\xadZ\t\xe2\xd5\x00\x18';
    //     ids.block_rlp_len_bytes = 539
    //     ids.block_rlp_len = 68
    //     (segments.write_argids.block_rlp, block_rlp_formatted.values)
    // %} 
    // let (receipts_root) = helper_test_decode_receipts_root(
    //     539, 68, hard_rlp
    // );
      
    
    %{
        print("hello world");
        extracted = [ids.receipts_root.word_1, ids.receipts_root.word_2, ids.receipts_root.word_3, ids.receipts_root.word_4]
        l = list(map(lambda x: str(hex(x)[2:]), extracted))
        formatted_hash = '0x' + ''.join(l)
        assert Web3.toBytes(hexstr=formatted_hash) == block["receiptsRoot"]
    %}
    assert [output_ptr] = receipts_root;
    let output_ptr = output_ptr + 1;
    return ();
}

struct Location {
    row: felt,
    col: felt,
}

func helper_test_decode_receipts_root{range_check_ptr}(
    block_rlp_len_bytes: felt, block_rlp_len: felt, block_rlp: felt*
) -> (res: Keccak256Hash) {
    alloc_locals;
    local ptr: Location;
    assert ptr.row = 0;
    assert ptr.col = 2;

    local input: IntsSequence;
    assert input.element = block_rlp;
    assert input.element_size_words = block_rlp_len;
    assert input.element_size_bytes = block_rlp_len_bytes;
    // assert input.element = block_rlp;
    // assert input.element_size_words = block_rlp_len;
    // assert input.element_size_bytes = block_rlp_len_bytes;
    

    %{ print("inputttt~") %}
    %{ print(ids.input.element) %}
    %{ print(ids.input.element_size_words) %}
    %{ print(ids.input.element_size_bytes) %}

    let (local receipts_root: Keccak256Hash) = decode_receipts_root(input);
    return (receipts_root,);
}