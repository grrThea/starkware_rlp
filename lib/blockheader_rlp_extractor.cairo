from starkware.cairo.common.math import assert_le
from lib.extract_from_rlp import extract_data
from lib.types import Keccak256Hash, IntsSequence

func decode_receipts_root{range_check_ptr}(block_rlp: IntsSequence) -> (res: Keccak256Hash) {
    alloc_locals;
    let (local data: IntsSequence) = extract_data(
        4 + 32 + 1 + 32 + 1 + 20 + 1 + 32 + 1 + 32 + 1, 32, block_rlp
    );
    let receipts_root = data.element;
    local hash: Keccak256Hash = Keccak256Hash(
        word_1=receipts_root[0],
        word_2=receipts_root[1],
        word_3=receipts_root[2],
        word_4=receipts_root[3]
        );
    return (hash,);
}

