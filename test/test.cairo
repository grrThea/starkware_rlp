%builtins output range_check

from starkware.cairo.common.alloc import alloc
from lib.types import IntsSequence
from lib.blockheader_rlp_extractor import (
    decode_receipts_root,
    Keccak256Hash,
)

func main{output_ptr: Keccak256Hash* , range_check_ptr}() {
    alloc_locals;
    local block_rlp_len_bytes;
    local block_rlp_len;
    let (block_rlp: felt*) = alloc();
    let (hard_rlp: felt*) = alloc();
    // %{
    //     from web3 import Web3
    //     from mocks.blocks import mocked_blocks
    //     from utils.block_header import build_block_header
    //     from utils.types import Data

    //     block = mocked_blocks[0]
    //     block_header = build_block_header(block)
    //     block_rlp = block_header.raw_rlp()
    //     assert block_header.hash() == block["hash"]
    //     block_rlp_formatted = Data.from_bytes(block_rlp).to_ints()

    //     ids.block_rlp_len_bytes = block_rlp_formatted.length
    //     ids.block_rlp_len = len(block_rlp_formatted.values)
    //     segments.write_arg(ids.block_rlp, block_rlp_formatted.values)
    // %}
    %{
        block_rlp = b'\xf9\x02\x18\xa0\x03\xb0\x16\xcc\x93\x87\xcb<\xef\x86\xd9\xd4\xaf\xb5,7\x89R\x8cS\x0c\x00 \x87\x95\xac\x93|\xe0EYj\xa0\x1d\xccM\xe8\xde\xc7]z\xab\x85\xb5g\xb6\xcc\xd4\x1a\xd3\x12E\x1b\x94\x8at\x13\xf0\xa1B\xfd@\xd4\x93G\x94\xfb\xb6\x1b\x8b\x98\xa5\x9f\xbcK\xd7\x9c#!*\xdd\xbe\xfa\xeb(\x9f\xa0\xd4\\\xea\x1d\\\xaex8oy\xe0\xd5"\xe0\xa1\xd9\x1b-\xa9_\xf8K]\xe2X\xf2\xc9\x89=?I\xb1\xa0\x14\x07O%:\x03##\x1d4\x9a?\x9cdj\xf7q\xc1\xde\xc2\xf24\xbb\x80\xaf\xedT`\xf5r\xfe\xd1\xa0Zo[\x9a\xc7Z\xe1\xe1\xf8\xc4\xaf\xef\xb94~\x14\x1b\xc5\xc9U\xb2\xede4\x1d\xf3\xe1\xd5\x99\xfc\xad\x91\xb9\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x84v\xfe)\n\x83\xae\xce\x98\x83z\x12\x00\x83\x17\xed\xcf\x84a\x97\xc0$\x99\xd8\x83\x01\n\x0c\x84geth\x88go1.17.1\x85linux\xa0s-\x0e\xad\x04\x88:\x10\x97dc\xe5\xd4\xf7\x14\xc0\xb2\xa8\x1ata4\xe9\xc24\x1fY\xb6\xc7a\x0c\x03\x88?@\xadZ\t\xe2\xd5\x00\x18';
        ids.block_rlp_len_bytes = 539
        ids.block_rlp_len = 69
        segments.write_arg(ids.block_rlp, [17942930940933183180, 10630688908008413652, 12661074544460729427, 864726895158924156, 16160421152376605773, 16780068465932993973, 7473385843023090245, 1987365566732607810, 18248819419131476918, 1984847897903778775, 11250872762094254827, 2927235116766469468, 12571860411242042658, 16186457246499692536, 5430745597336979773, 4560371398778244901, 4180223512850766399, 11269249778585820866, 17452780617349289056, 17686478862929260379, 11152982928411641007, 17273895561864136137, 6175259058000229345, 15391611023919743232, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9545095912481861326, 10989761733450733549, 14953183967168469464, 9439837342822524276, 7532384104041296183, 3328588300275316088, 11561634209445742650, 1195534606310635284, 13885345432711804137, 13993844412326043916, 254522925965248994, 13959192])
    %} 
    let (receipts_root) = helper_test_decode_receipts_root(
        ids.block_rlp_len_bytes, ids.block_rlp_len, block_rlp
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

func helper_test_decode_receipts_root{range_check_ptr}(
    block_rlp_len_bytes: felt, block_rlp_len: felt, block_rlp: felt*
) -> (res: Keccak256Hash) {
    alloc_locals;
    local input: IntsSequence = IntsSequence(block_rlp, block_rlp_len, block_rlp_len_bytes);
    %{ print("inputttt~") %}
    
    %{ print(input) %}

    let (local receipts_root: Keccak256Hash) = decode_receipts_root(input);
    return (receipts_root,);
}