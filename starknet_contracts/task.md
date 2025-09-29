# StarkNet Staking Contract Assignment

**Title:** Staking Stark Token on StarkNet — Earn ERC20 Rewards

**Summary**
Create a secure staking smart contract in **Cairo** for StarkNet where users stake the `Stark` token (an ERC20 on StarkNet) and receive rewards in another ERC20 token (e.g., `RewardToken`).
---

## Objectives

* Implement a gas‑efficient and secure staking contract.
* Support staking, unstaking, and reward distribution based on stake share and time.
* Write comprehensive unit tests and a deployment script using **Starknet Foundry (snforge)**.
* Provide clear documentation and a README explaining design choices and test results.

---


## Deliverables

1. `staking.cairo` — Cairo contract implementing staking functionality.
2. `stark_token.cairo` and `reward_token.cairo` — simple ERC20 tokens for local testing.
3.  (OPTIONAL) Deployment script to a StarkNet testnet (Sepolia or Testnet2).
4. `README.md` with instructions to run tests, deploy locally, and explanation of reward formula and security considerations.
5. Optional: small frontend demo (bonus).

---

## Functional Requirements

* Users can `stake(amount: u256)` Stark tokens by transferring them to the staking contract (use ERC20 `transfer_from`).
* Users can `unstake(amount: u256)` and receive their principal back.
* Rewards are paid in a separate ERC20 `RewardToken` and accrue over time.
* Reward calculation must be fair: rewards based on stake share and time. Implement one of the following approaches:

  * **Per-second reward rate**: fixed reward rate distributed proportionally to staked balance over time using `get_block_timestamp()`.
  * **Reward per token stored**: maintain cumulative reward per staked token and track each user’s paid rewards.
* Users can `claim_rewards()` to withdraw accumulated reward tokens.
* Owner/manager functions:

  * `fund_rewards(amount: u256, duration: u64)` to top up reward pool and set distribution duration.
  * `pause()` / `unpause()` (recommended) to halt staking in emergencies.
  * `recover_erc20(token: ContractAddress, amount: u256)` to rescue mistakenly sent tokens (with restrictions: cannot rescue staked or reward tokens while active distribution).
* Emit events: `Staked`, `Unstaked`, `RewardPaid`, `RewardsFunded`, `Paused`, `Unpaused`, `RecoveredTokens`.

---

## Non-functional & Security Requirements

* Protect against reentrancy (use `#[external(v0)]` best practices and checks‑effects‑interactions pattern).
* Correct use of ERC20 `transfer_from` & token approvals.
* Gas efficiency: minimize storage writes; use felt252/u256 carefully.
* Provide reasoning in README about edge cases (e.g., insufficient reward pool, rounding behavior, leftover rewards after distribution period).

---

## Test Cases (minimum)

1. **Staking and balances**

   * User stakes N tokens: contract balance increases, user stake recorded, total_staked updated.
2. **Unstaking and principal return**

   * User unstakes N tokens: receives N tokens back, balances updated.
3. **Reward accrual over time**

   * Fund rewards for a duration; advance block timestamp; verify `earned()` matches expected formula for single staker and multiple stakers.
4. **Multiple stakers, proportional rewards**

   * Two stakers stake different amounts at different times; simulate time progression and verify correct reward share.
5. **Claiming rewards**

   * After accrual, user calls `claim_rewards()` and receives correct `RewardToken` amount.
6. **Edge cases**

   * Staking 0 should revert.
   * Unstaking more than staked should revert.
   * Claiming with no rewards should not revert and pay zero.
7. **Security behaviors**

   * Attempted reentrancy should fail.
   * Owner-only functions revert for non-owners.

---

## Submission Instructions

* Create a Pull request on this repository.
* Include all source, tests, and README.

**Good luck building on StarkNet!**
