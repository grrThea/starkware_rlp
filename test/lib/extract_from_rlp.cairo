

from lib.pow import pow
from lib.types import IntsSequence
from lib.bitshift import bitshift_right, bitshift_left
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.alloc import alloc


func extract_data{range_check_ptr}(start_pos: felt, size: felt, rlp: IntsSequence) -> (
    res: IntsSequence
) {
    alloc_locals;
    local rlp_print: IntsSequence;
    %{ 
        print("rlp");
        ids.rlp_print = rlp;
        print(ids.rlp_print);
    %}
    let (start_word, left_shift) = unsigned_div_rem(start_pos, 8);
    let (end_word_tmp, end_pos_tmp) = unsigned_div_rem(start_pos + size, 8);

    let (full_words, remainder) = unsigned_div_rem(size, 8);

    // end_pos is a bad name - it conflicts with start_pos
    // start_pos is absolute, and end_pos is relative inside the world
    local end_pos;
    local end_word;
    if (end_pos_tmp == 0) {
        end_pos = 8;
        end_word = end_word_tmp - 1;
    } else {
        end_pos = end_pos_tmp;
        end_word = end_word_tmp;
    }

        let (_, last_rlp_word_len_tmp) = unsigned_div_rem(rlp.element_size_bytes, 8);
        local last_rlp_word_len;
        if (last_rlp_word_len_tmp == 0) {
            last_rlp_word_len = 8;
        } else {
            last_rlp_word_len = last_rlp_word_len_tmp;
        }
    
    

        local right_shift = 8 - left_shift;
        let last_word_right_shift = last_rlp_word_len - left_shift;

        let (local new_words: felt*) = alloc();

        let (local new_words_len) = extract_data_rec(
            start_word=start_word,
            full_words=full_words,
            left_shift=left_shift,
            right_shift=right_shift,
            last_word_right_shift=last_word_right_shift,
            rlp=rlp,
            acc=new_words,
            acc_len=0,
            current_index=start_word,
        );

        local result_words_len;

        if (remainder == 0) {
            result_words_len = new_words_len;
            tempvar range_check_ptr = range_check_ptr;
        } else {
            local left_shift_above_8_bytes = is_le(8 + 1, remainder + left_shift);
            if (left_shift_above_8_bytes == 1) {
                let (local left_part) = bitshift_left(rlp.element[end_word - 1], left_shift * 8);

                local right_part;
                if (end_word == rlp.element_size_words - 1) {
                    local is_last_word_right_shift_negative = is_le(last_word_right_shift + 8, 7);
                    if (is_last_word_right_shift_negative == 1) {
                        let (local right_part_tmp) = bitshift_left(
                            rlp.element[end_word], (-8) * last_word_right_shift
                        );
                        right_part = right_part_tmp;
                        tempvar range_check_ptr = range_check_ptr;
                    } else {
                        let (local right_part_tmp) = bitshift_right(
                            rlp.element[end_word], 8 * last_word_right_shift
                        );
                        right_part = right_part_tmp;
                        tempvar range_check_ptr = range_check_ptr;
                    }
                } else {
                    let (local right_part_tmp) = bitshift_right(rlp.element[end_word], 8 * right_shift);
                    right_part = right_part_tmp;
                    tempvar range_check_ptr = range_check_ptr;
                }

                local final_word = left_part + right_part;
                let (local final_word_shifted) = bitshift_right(final_word, 8 * (8 - remainder));

                let (local divider: felt) = pow(2, remainder * 8);
                let (_, final_word_masked) = unsigned_div_rem(final_word_shifted, divider);
                assert new_words[new_words_len] = final_word_masked;
            } else {
                local final_word_shifted;
                if (end_word == rlp.element_size_words - 1) {
                    let (local final_word_shifted_tmp) = bitshift_right(
                        rlp.element[end_word], 8 * (last_rlp_word_len - end_pos)
                    );
                    final_word_shifted = final_word_shifted_tmp;
                    tempvar range_check_ptr = range_check_ptr;
                } else {
                    let (local final_word_shifted_tmp) = bitshift_right(
                        rlp.element[end_word], 8 * (8 - end_pos)
                    );
                    final_word_shifted = final_word_shifted_tmp;
                    tempvar range_check_ptr = range_check_ptr;
                }

                let (local divider: felt) = pow(2, 8 * (end_pos - left_shift));
                let (_, final_word_masked) = unsigned_div_rem(final_word_shifted, divider);
                assert new_words[new_words_len] = final_word_masked;
            }
            result_words_len = new_words_len + 1;
            tempvar range_check_ptr = range_check_ptr;
        }

    local result: IntsSequence = IntsSequence(new_words, result_words_len, size);
    return (result,);
}

func extract_data_rec{range_check_ptr}(
    start_word: felt,
    full_words: felt,
    left_shift: felt,
    right_shift: felt,
    last_word_right_shift: felt,
    rlp: IntsSequence,
    acc: felt*,
    acc_len: felt,
    current_index: felt,
) -> (new_acc_size: felt) {
    alloc_locals;

    if (current_index == full_words + start_word) {
        return (acc_len,);
    }
    let (local left_part) = bitshift_left(rlp.element[current_index], left_shift * 8);
    local right_part;
    if (current_index == rlp.element_size_words - 2) {
        local is_last_word_right_shift_negative = is_le(last_word_right_shift, -1);
        if (is_last_word_right_shift_negative == 1) {
            let (local right_part_tmp) = bitshift_left(
                rlp.element[current_index + 1], (-8) * last_word_right_shift
            );
            right_part = right_part_tmp;
            tempvar range_check_ptr = range_check_ptr;
        } else {
            let (local right_part_tmp) = bitshift_right(
                rlp.element[current_index + 1], 8 * last_word_right_shift
            );
            right_part = right_part_tmp;
            tempvar range_check_ptr = range_check_ptr;
        }
        tempvar range_check_ptr = range_check_ptr;
    } else {
        if (current_index == rlp.element_size_words - 1) {
            right_part = 0;
            tempvar range_check_ptr = range_check_ptr;
        } else {
            let (local right_part_tmp) = bitshift_right(
                rlp.element[current_index + 1], 8 * right_shift
            );
            right_part = right_part_tmp;
            tempvar range_check_ptr = range_check_ptr;
        }
        tempvar range_check_ptr = range_check_ptr;
    }

    local new_word = left_part + right_part;
    let (local divider: felt) = pow(2, 64);

    local range_check_ptr = range_check_ptr;

    let (_, new_word_masked) = unsigned_div_rem(new_word, divider);

    local range_check_ptr = range_check_ptr;

    assert acc[current_index - start_word] = new_word_masked;

    return extract_data_rec(
        start_word=start_word,
        full_words=full_words,
        left_shift=left_shift,
        right_shift=right_shift,
        last_word_right_shift=last_word_right_shift,
        rlp=rlp,
        acc=acc,
        acc_len=acc_len + 1,
        current_index=current_index + 1,
    );
}

