# Starknet Testing

### Install and get started with Starknet Foundry
#### Environment Set up (Only when you are using Github Codespaces)
1. Go to Github Codespaces: [https://github.com/codespaces](https://github.com/codespaces)
2. Create a blank Codespace by selecting the "Blank" template: ![image](https://github.com/user-attachments/assets/e8c4b537-245d-46d1-a238-10daa3e20b6a)
3. Then proceed with the steps to install Starknet Foundry below 👇

Steps to install Starknet Foundry
1. Install Scarb: 
```bash
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh
```
Confirm scarb installation by running the command: 
```bash
scarb --version
```

2. Install Rust
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

3. Install the Starknet Foundry tool chain installer:
```bash
curl -L https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh | sh
```
4. Run the tool chain installer:
```bash
snfoundryup
```
Confirm Starknet Foundry installation by running:
```bash
sncast --version
```
or 
```bash
snforge --version
```

### Getting started with Starknet Foundry
- Start a new project using Starknet Foundry:
```bash
snforge init hello_starknet #project name
```
- Move into the project directory
```bash
cd hello_starknet #move into the newly created starknet foundry project directory
```
- Build project
```bash
scarb build
```
- Run tests
```
snforge test
```
> Uses `scarb` to build contracts first, then proceed to run tests using `snforge`
- Filter tests
```bash
snforge test test_increase_
```
- Run specific tests
```bash
snforge test hello_starknet::tests::test_increase_balance --exact
```

### Create a Starknet Account from the terminal

> Use this free RPC provider: https://free-rpc.nethermind.io/sepolia-juno/

1. Create an account contract by running this command on your terminal:
   ```bash
   sncast account create --url https://free-rpc.nethermind.io/sepolia-juno --name cohort_dev
   ```

2. Deploy the account contract:
   ```bash
   sncast account deploy --url https://free-rpc.nethermind.io/sepolia-juno --name cohort_dev --fee-token eth`
   ```

# Writing Tests for Cairo programs
Cairo tests are functions that verify that functionality of Cairo programs are working as expected.
The test functions perform the following actions:
- Set up any needed data or state.
- Run the code you want to test.
- Assert the results are what you expect.

### Declare and deploy Starknet Contract
1. Declare your contract:
   `sncast --account cohort_dev declare --url https://free-rpc.nethermind.io/sepolia-juno --fee-token eth --contract-name Counter`
   > Example of a contract name is `Counter`

2. Deploy your contract:
   `sncast --account cohort_dev deploy --url https://free-rpc.nethermind.io/sepolia-juno --fee-token eth --class-hash 0x70eef4488bd1858900685210e5afb64d827e6e2bebfd85b01ff8b46d4584471`

---
🥳🥳🥳 Congratulations on successfully deploying your first contract
---

### Super-charge your `sncast` by adding a profile
This approach simplifies interactions using `sncast` as you can simply run commands completely eliminating the need to to add `--url` and `--name` flags whenever you want to run each sncast command:
`sncast --profile <name_of_profile_on_snfoundry.toml> declare --contract-name <name_of_contract_to_be_deployed>`
Eg: `sncast -u https://free-rpc.nethermind.io/sepolia-juno/ account create -n cohort_dev --add-profile cohort_dev`. This command automatically creates a profile for you in the root of your project directory. Meaning you will find an auto-created file named `snfoundry.toml` file  with the following configurations:
```
[sncast.cohort_dev] 
account = "cohort_dev" 
accounts-file  = "~/.starknet_accounts/starknet_open_zeppelin_accounts.json" 
url = "https://free-rpc.nethermind.io/sepolia-juno/"
```

3. Install the Starknet Foundry tool chain installer:
```bash
curl -L https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh | sh
```
4. Run the tool chain installer:
```bash
snfoundryup
```
Confirm Starknet Foundry installation by running:
```bash
sncast --version
```
or 
```bash
snforge --version
```

### Interacting with Deployed Contracts

- **Invoke**: to execute the logic of a state-changing (writes) function within your deployed contracts from the terminal, run
  `sncast --url https://free-rpc.nethermind.io/sepolia-juno --account cohort_dev invoke --contract-address <your_contract_address> --function "<your_function_name>" --calldata 10`
  If you have configured your `snfoundry.toml` file, run:
  `sncast --profile <your_profile> invoke --contract-address <your_contract_address> --function "<your_function_name>" --calldata <fn_args>`

- **Call**: to execute the logic of a non-state-changing (reads) function within your deployed contracts from the terminal, run:
  `sncast --url https://free-rpc.nethermind.io/sepolia-juno --account cohort_dev call --contract-address <your_contract_address> --function "<your_function_name>"`

### Some important cheatcodes
- `cheat_caller_address` - changes the caller address for contracts
- `CheatSpan` -  enum used to specify for how long the target should be cheated for.
e.g
```
cheat_caller_address(contract_address, new_caller_address, CheatSpan::TargetCalls(1))
```

### Cheatcode techinques
- `precalculate_address` - Precalculate the address of a contract before deployment. Used to prank the constructor when the caller/deployer address is needed inside the constructor.
```rust
use snforge_std::{ContractClassTrait}

// Precalculate the address to obtain the contract address before the constructor call (deploy) itself
let contract_address = contract.precalculate_address(constructor_arguments);
```

## Resources
- [Universal Contract Deployer (UDC)](https://docs.openzeppelin.com/contracts-cairo/0.6.1/udc)
- Utilities - [Stark Utils app](https://stark-utils.vercel.app/converter), [Cairo Utils app](https://cairo-utils-web.vercel.app/)
- Using [`Result`](https://book.cairo-lang.org/ch09-02-recoverable-errors.html)
