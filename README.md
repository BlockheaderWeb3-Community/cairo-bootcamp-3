# Starknet Testing

## Testing
- It is different from web2
- Write code that has no room for errors
- Can be upgradeded but with some conditions

## Categories of testing
1. Unit tests: 
    - Functions in your code are tested individually
    - Dependencies are mocked
    - Usually the largest number of tests in your codebase
    - (cairo-test, sn-foundry)
2. Integration tests:
    - Test how one contract interract with another using the public interface 
    - Fewer tests than unit tests
    - (cairo-test, sn-foundry)
3. E2E tests:
    - Simulates how the user will interact with dapp
    - Mostly concerned about how the UI integrates with the smart contract
    - (appium, cypress)

## Devnet
A local Starknet instance running on your machine
- Has pre-created accounts along with their private keys. Accounts are also pre-funded as well.
- Has a Sequencer to manage the state of network
- Exposes JSON RPC endpoints to interract with the network
- Runs on `localhost:5050`
- Dapps and CLI tools can interact with the local devnet

## Devnets
1. Starknet Devnet
2. Katana

## Tools for testing
1. Starknet Foundry
    _**Two main binaries:**_
    -  Snforge: Test runner
    -  Sncast: Starknet CLI
2. Starkli

# Writing Tests for Cairo programs
Cairo tests are functions that verify that functionality of Cairo programs are working as expected.
The test functions perform the following actions:
- Set up any needed data or state.
- Run the code you want to test.
- Assert the results are what you expect.

## Testing Cairo Programs

Test functions perform the following actions:
- Set up needed data or state
- Run the code to be tested
- Assert that result is what is expected
- Test in Cairo is a function annonated with the `#[test]` attribute
- When you run test with `scarb cairo-test`, Scarb runs all functions annoated with the `#[test]` attribute and output the results
- `#[cfg(test)]` instructs the compiler to compile the code in the module only when the test in being run.

### Asserting test results
- `assert!` - When you want to ensure a condition evaluates to true
- `assert_eq!` - Compares two arguments for equality
- `assert_ne!` - Compares two arguments for inequality
> _Note that in some languages and test frameworks, the parameters for equality assertion functions are called `expected` and `actual`, and the order in which we specify the arguments matters. However, in Cairo, they’re called `left` and `right`, and the order in which we specify the value we expect and the value the code produces doesn’t matter_

- `assert_lt!` checks if a given value is lower than another value, and reverts otherwise.
- `assert_le!` checks if a given value is lower or equal than another value, and reverts otherwise.
- `assert_gt!` checks if a given value is greater than another value, and reverts otherwise.
- `assert_ge!` checks if a given value is greater or equal than another value, and reverts

### Checking for panics
- `#[should_panic]`
-  ``#[should_panic(expected: ("Panic message",))]``

### Filtering tests
- use the `-f` flag followed name of the test to filter tests by name. It uses regular expression to match the test names

### Ignoring tests
- `#[ignore]` - Use this annotation on a test to ignore that test
- `scarb cairo-test --include-ignored ` - Use this command to run all tests, including those that are ignored

### Set gas limit for a for a test function execution
-   `#[available_gas(2000000)]`


## Starknet Foundry
- Starknet Foundry is a toolchain for developing Starknet smart contracts.
- It helps with writing, deploying, and testing starknet contracts.
- It is inspired by Foundry

## Install Starknet Foundry
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

## Getting started with Starknet Foundry
- Start a new project using Starknet Foundry:
```bash
snforge init hello_starknet #project name
```
- Move into the project directory
```bash
cd hello_starknet
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

## Unit Tests
- Testing standalone functions in your smart contract
- Test functions should be in same file as functions being tested
- Must be in a module annonated with `#[cfg(test)]`
- `snforge` will collect tests only from these places:
    - any files reachable from the package root (declared as mod in lib.cairo or its children) - these have to be in a module annotated with #[cfg(test)]
    - files inside the tests directory
- [How tests are collected](https://foundry-rs.github.io/starknet-foundry/testing/test-collection.html)

## Integration Tests
- Testing the interaction of your contract with the blockchain state and other contracts.
- `@array![]` - Serializing the constructor with `Serde`.
- `SafeDispatcher` - Used when testing contract functions that can panic. It returns a `Result` instead of panicking.
```rust
let (contract_address, _) = contract.deploy(@array![]).unwrap();
```
>Returns the address of the deployed contract and the serialized return value of the constructor.

### Notes: 
- **Contract Interfaces**
    - They defines the structure and behaviour of a contract
    - They serve as the contract's public ABI
    - Each time a contract interface is defined, two dispatchers are automatically created and exported by the compiler.
        1. The contract dispatcher. e.g `IERC20Dispatcher` (struct)
        2. The Library dispatcher. e.g `IERC20LibraryDispatcher` (struct)
    - Compiler also generates a trait `IERC20DispatcherTrait`, which allows us to call the functions defined inside the interface from the dispatcher struct
    - Contract dispatchers - Used to call functions from another contracts.
    - Library dispatchers - Used to call classes. Stateless, similar to delegate call in Solidity).

### 
- **Drop and Serde** are required to properly serialize arguments passed to the entrypoints and deserialize their outputs.

###
- [Desnap Operator](https://book.cairo-lang.org/ch04-02-references-and-snapshots.html#desnap-operator)
    - A desnap operator, denoted by `*`, is used to convert a snapshot back into a regular variable. It serves as the opposite of the snapshot operator.
    - It enables the reuse of the old value without taking ownership or modifying the original variable.
- [`.unwrap()`](https://book.cairo-lang.org/ch09-02-recoverable-errors.html)
    - It attempts to extract the value of type T from a `Result<T, E>` when it is in the Ok variant. 
    - If the `Result` is `Ok(x)`, the method returns the value x. However, if the Result is in the `Err` variant, the `.unwrap()` method panics with a default error message, terminating the program execution. 
    - It is used when you are confident that the `Result` will be `Ok` and you want to directly access its value, but it should be used with caution due to its potential to cause a panic if the `Result` is `Err`.

## Using Cheatcodes
- [Cheatcodes reference](https://foundry-rs.github.io/starknet-foundry/appendix/cheatcodes.html)
- When testing smart contracts, often there are parts of code that are dependent on a specific blockchain state. Instead of trying to replicate these conditions in tests, you can emulate them using **Cheatcodes**.
- By using cheatcodes, we can change various properties of transaction info, block info, etc.

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
