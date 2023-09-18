from mocks.blocks import mocked_blocks
from utils.block_header import build_block_header
from utils.types import Data
from web3 import Web3

block = mocked_blocks[0]
block_header = build_block_header(block)
block_rlp = block_header.raw_rlp()
assert block_header.hash() == block["hash"]
block_rlp_formatted = Data.from_bytes(block_rlp).to_ints()

block_rlp_len_bytes = block_rlp_formatted.length
block_rlp_len = len(block_rlp_formatted.values)

# print(block_rlp_len_bytes)
# print(block_rlp_len)
# print(block_rlp)

print(block_rlp_formatted)


# segments.write_arg(block_rlp, block_rlp_formatted.values)