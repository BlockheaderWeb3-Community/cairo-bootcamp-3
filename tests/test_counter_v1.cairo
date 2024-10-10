use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
use starknet::{ContractAddress};
use cairo_bootcamp_3::counter_v1::{ICounterDispatcher, ICounterDispatcherTrait};

// Deploys the given contract and returns the contract address
fn deploy(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    contract_address
}

// Instruct snforge to only run this function when the `snforge test` command is used
#[test]
fn test_can_set_count() {
    // Deploy Counter contract and get the contract address
    let contract_address = deploy("Counter");

    // Get an instance of the deployed Counter contract
    let counter_dispatcher = ICounterDispatcher { contract_address };

    // Get the initial value of count from storage
    let initial_count = counter_dispatcher.get_count();
    // Assert that the initial value is what is expected
    assert_eq!(initial_count, 0);

    // Set new count value
    counter_dispatcher.set_count(10);

    // Verify count was set correctly
    let current_count = counter_dispatcher.get_count();
    // Assert that the current value is what is expected
    assert_eq!(current_count, 10);
}

#[test]
fn test_get_count() {
    let contract_address = deploy("Counter");

    let counter_dispatcher = ICounterDispatcher { contract_address };

    let count_val = counter_dispatcher.get_count();

    assert_eq!(count_val, 0);
}

