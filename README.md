# SaveERC20 Staking Contract

This smart contract allows users to stake ERC20 tokens, earn rewards based on the staking duration, and withdraw their staked tokens along with the earned rewards.
Features

- Staking: Users can stake ERC20 tokens by transferring them to the contract.
- Rewards: Rewards are calculated based on the duration of the stake. The longer you stake, the higher the rewards.
- Withdrawal: Users can withdraw their staked tokens along with the rewards after the staking period.
- Owner Controls: The contract owner can withdraw funds from the contract.

## How to Use

    Deploy the Contract: Deploy the SaveERC20 contract with the ERC20 token address as a parameter.
    Stake Tokens: Call the deposit function with the amount of tokens you wish to stake.
    Check Your Stake: Use the myStake function to check your staked amount, start time, and earned rewards.
    Withdraw Tokens: Call the withdraw function to withdraw your staked tokens and rewards.

## Functions

- deposit(uint256 _amount): Stake the specified amount of ERC20 tokens.
- withdraw(): Withdraw your staked tokens and rewards.
- myStake(): View your staked amount, start time, and rewards.
- getContractBalance(): (Owner only) View the total balance of the contract.
- ownerWithdraw(uint256 _amount): (Owner only) Withdraw funds from the contract.

## License

This project is licensed under the **MIT License**.