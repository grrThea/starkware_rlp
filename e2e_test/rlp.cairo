fn main() {
    test_rlp_decode_string()
}

fn test_rlp_decode_string() {
    let mut arr = ArrayTrait::new();
    //let rev = reverse_endianness(i);
    arr.append(12);

    let (res, len) = rlp_decode(arr.span()).unwrap();
    assert(len == 1, 'Wrong len');
    assert(res == RLPItem::Bytes(arr.span()), 'Wrong value');
} 

type Words64 = Span<u64>;

impl Words64TryIntoU256LE of TryInto<Words64, u256> {
    // @notice Converts a span of 64 bit little endian words into a little endian u256
    fn try_into(self: Words64) -> Option<u256> {
        if self.len() > 4 {
            return Option::None(());
        }

        let pows = array![
            0x10000000000000000, // 2 ** 64
            0x100000000000000000000000000000000, // 2 ** 128
            0x1000000000000000000000000000000000000000000000000 // 2 ** 192
        ];

        let mut output: u256 = (*self.at(0)).into();
        let mut i: usize = 1;
        loop {
            if i == self.len() {
                break Option::Some(output);
            }

            // left shift and add
            output = output | (*self.at(i)).into() * *pows.at(i - 1);

            i += 1;
        }
    }
}

#[generate_trait]
impl Words64Impl of Words64Trait {
    // @notice Slices 64 bit little endian words from a starting byte and a length
    // @param start The starting byte
    // The starting byte is counted from the left. Example: 0xabcdef -> byte 0 is 0xab, byte 1 is 0xcd...
    // @param len The number of bytes to slice
    // @return A span of 64 bit little endian words
    // Example: 
    // words: [0xabcdef1234567890, 0x7584934785943295, 0x48542576]
    // start: 5 | len: 17
    // output: [0x3295abcdef123456, 0x2576758493478594, 0x54]
    fn slice_le(self: Words64, start: usize, len: usize) -> Words64 {
        if len == 0 {
            return ArrayTrait::new().span();
        }

        let first_word_index = start / 8;
        // number of right bytes to remove
        let mut word_offset_bytes = 8 - ((start + 1) % 8);
        if word_offset_bytes == 8 {
            word_offset_bytes = 0;
        }

        let word_offset_bits = word_offset_bytes * 8;
        let pow2_word_offset_bits = pow2(word_offset_bits);
        let mask_second_word = pow2_word_offset_bits - 1;
        let reverse_words_offset_bits = 64 - word_offset_bits;

        let mut pow2_reverse_words_offset_bits = 0;
        if word_offset_bytes != 0 {
            pow2_reverse_words_offset_bits = pow2(reverse_words_offset_bits);
        }

        let mut output_words = len / 8;
        if len % 8 != 0 {
            output_words += 1;
        }

        let mut output = ArrayTrait::new();
        let mut i = first_word_index;
        loop {
            if i - first_word_index == output_words - 1 {
                break ();
            }
            let word = *self.at(i);
            let next = *self.at(i + 1);

            // remove bytes from the right
            let shifted = word / pow2_word_offset_bits;

            // get right bytes from the next word
            let bytes_to_append = next & mask_second_word;

            // apend bytes to the left of first word
            let mask_first_word = bytes_to_append * pow2_reverse_words_offset_bits;
            let new_word = shifted | mask_first_word;

            output.append(new_word);
            i += 1;
        };

        // Handling remainder (last word)

        let last_word = *self.at(i);
        let shifted = last_word / pow2_word_offset_bits;

        let mut len_last_word = len % 8;
        if len_last_word == 0 {
            len_last_word = 8;
        }

        if len_last_word <= 8 - word_offset_bytes {
            // using u128 because if len_last_word == 8 left_shift might overflow by 1
            // after subtracting 1 it's safe to unwrap
            let mask: u128 = left_shift(1_u128, len_last_word.into() * 8) - 1;
            let last_word_masked = shifted & mask.try_into().unwrap();
            output.append(last_word_masked);
        } else {
            let missing_bytes = len_last_word - (8 - word_offset_bytes);
            let next = *self.at(i + 1);

            // get right bytes from the next word
            let mask_second_word = pow2(missing_bytes * 8) - 1;
            let bytes_to_append = next & mask_second_word;

            // apend bytes to the left of first word
            let mask_first_word = bytes_to_append * pow2_reverse_words_offset_bits;
            let new_word = shifted | mask_first_word;

            output.append(new_word);
        }

        output.span()
    }
}

#[derive(Drop)]
enum RLPItem {
    Bytes: Words64,
    // Should be Span<RLPItem> to allow for any depth/recursion, not yet supported by the compiler
    List: Span<Words64>
}

#[derive(Drop, PartialEq)]
enum RLPType {
    String: (),
    StringShort: (),
    StringLong: (),
    ListShort: (),
    ListLong: (),
}

#[generate_trait]
impl RLPTypeImpl of RLPTypeTrait {
    fn from_byte(byte: Byte) -> Result<RLPType, felt252> {
        if byte <= 0x7f {
            Result::Ok(RLPType::String(()))
        } else if byte <= 0xb7 {
            Result::Ok(RLPType::StringShort(()))
        } else if byte <= 0xbf {
            Result::Ok(RLPType::StringLong(()))
        } else if byte <= 0xf7 {
            Result::Ok(RLPType::ListShort(()))
        } else if byte <= 0xff {
            Result::Ok(RLPType::ListLong(()))
        } else {
            Result::Err('Invalid byte')
        }
    }
}



fn rlp_decode(input: Words64) -> Result<(RLPItem, usize), felt252> {
    // It's guaranteed to fid in 32 bits, as we are masking with 0xff
    let prefix: u32 = (*input.at(0) & 0xff).try_into().unwrap();

    // It's guaranteed to be a valid RLPType, as we are masking with 0xff
    let rlp_type = RLPTypeTrait::from_byte(prefix.try_into().unwrap()).unwrap();
    match rlp_type {
        RLPType::String(()) => {
            let mut arr = array![prefix.into()];
            Result::Ok((RLPItem::Bytes(arr.span()), 1))
        },
        RLPType::StringShort(()) => {
            let len = prefix.into() - 0x80;
            let res = input.slice_le(6, len);

            Result::Ok((RLPItem::Bytes(res), 1 + len))
        },
        RLPType::StringLong(()) => {
            let len_len = prefix - 0xb7;
            let len_span = input.slice_le(6, len_len);
            // Enough to store 4.29 GB (fits in u32)
            assert(len_span.len() == 1 && *len_span.at(0) <= 0xffffffff, 'Len of len too big');

            // len fits in 32 bits, confirmed by previous assertion
            let len: u32 = reverse_endianness_u64(*len_span.at(0), Option::Some(len_len.into()))
                .try_into()
                .unwrap();
            let res = input.slice_le(6 - len_len, len);

            Result::Ok((RLPItem::Bytes(res), 1 + len_len + len))
        },
        RLPType::ListShort(()) => {
            let mut len = prefix - 0xc0;
            let mut in = input.slice_le(6, len);
            let res = rlp_decode_list(ref in, len)?;
            Result::Ok((RLPItem::List(res), 1 + len))
        },
        RLPType::ListLong(()) => {
            let len_len = prefix - 0xf7;
            let len_span = input.slice_le(6, len_len);
            // Enough to store 4.29 GB (fits in u32)
            assert(len_span.len() == 1 && *len_span.at(0) <= 0xffffffff, 'Len of len too big');

            // len fits in 32 bits, confirmed by previous assertion
            let len: u32 = reverse_endianness_u64(*len_span.at(0), Option::Some(len_len.into()))
                .try_into()
                .unwrap();
            let mut in = input.slice_le(6 - len_len, len);
            let res = rlp_decode_list(ref in, len)?;

            Result::Ok((RLPItem::List(res), 1 + len_len + len))
        }
    }
}