%builtins output pedersen range_check

// The output of the AMM program.
struct AmmBatchOutput {
    // The balances of the AMM before applying the batch.
    token_a_before: felt,
    token_b_before: felt,
    // The balances of the AMM after applying the batch.
    token_a_after: felt,
    token_b_after: felt,
    // The account Merkle roots before and after applying
    // the batch.
    account_root_before: felt,
    account_root_after: felt,
}

func main{
    output_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}() {
    alloc_locals;

    // Create the initial state.
    local state: AmmState;
    %{
        # Initialize the balances using a hint.
        # Later we will output them to the output struct,
        # which will allow the verifier to check that they
        # are indeed valid.
        ids.state.token_a_balance = \
            program_input['token_a_balance']
        ids.state.token_b_balance = \
            program_input['token_b_balance']
    %}

    let (account_dict) = get_account_dict();
    assert state.account_dict_start = account_dict;
    assert state.account_dict_end = account_dict;

    // Output the AMM's balances before applying the batch.
    let output = cast(output_ptr, AmmBatchOutput*);
    let output_ptr = output_ptr + AmmBatchOutput.SIZE;

    assert output.token_a_before = state.token_a_balance;
    assert output.token_b_before = state.token_b_balance;

    // Execute the transactions.
    let (transactions, n_transactions) = get_transactions();
    let (state: AmmState) = transaction_loop(
        state=state,
        transactions=transactions,
        n_transactions=n_transactions,
    );

    // Output the AMM's balances after applying the batch.
    assert output.token_a_after = state.token_a_balance;
    assert output.token_b_after = state.token_b_balance;

    // Write the Merkle roots to the output.
    let (root_before, root_after) = compute_merkle_roots(
        state=state
    );
    assert output.account_root_before = root_before;
    assert output.account_root_after = root_after;

    return ();
}