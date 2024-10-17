use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
use starknet::{ContractAddress};
use cairo_bootcamp_3::aggregator::{IAggregatorDispatcher, IAggregatorDispatcherTrait};

pub mod Accounts {
    use starknet::ContractAddress;
    use core::traits::TryInto;

    pub fn zero() -> ContractAddress {
        0x0000000000000000000000000000000000000000.try_into().unwrap()
    }

    pub fn owner() -> ContractAddress {
        'owner'.try_into().unwrap()
    }

    pub fn account1() -> ContractAddress {
        'account1'.try_into().unwrap()
    }

    pub fn account2() -> ContractAddress {
        'account2'.try_into().unwrap()
    }

    pub fn account3() -> ContractAddress {
        'account3'.try_into().unwrap()
    }
    pub fn account4() -> ContractAddress {
        'account4'.try_into().unwrap()
    }
}

fn deploy(name: ByteArray) -> ContractAddress {
    // Deploy Ownable contract
    let ownable_contract = declare("Ownable").unwrap().contract_class();
    let (ownable_address, _) = ownable_contract.deploy(@array![Accounts::owner().into()]).unwrap();

    // Deploy Counter contract
    let counter_contract = declare("Counter").unwrap().contract_class();
    let (counter_address, _) = counter_contract.deploy(@array![]).unwrap();

    // Deploy KillSwitch contract
    let kill_switch_contract = declare("KillSwitch").unwrap().contract_class();
    let (kill_switch_address, _) = kill_switch_contract.deploy(@array![]).unwrap();

    // Deploy Aggregator contract
    let aggregator_contract = declare(name).unwrap().contract_class();
    let constructor_args = array![
        Accounts::owner().into(),
        ownable_address.into(),
        counter_address.into(),
        kill_switch_address.into()
    ];
    let (contract_address, _) = aggregator_contract.deploy(@constructor_args).unwrap();
    contract_address
}

#[test]
fn test_get_aggr_count() {
    // Deploy Counter contract and get the contract address
    let contract_address = deploy("Aggregator");

    // Get an instance of the deployed Counter contract
    let aggregator_dispatcher = IAggregatorDispatcher { contract_address };

    let initial_count = aggregator_dispatcher.get_counter_count();

    assert_eq!(initial_count, 0);

    aggregator_dispatcher.set_counter_count(5);
    let current_count = aggregator_dispatcher.get_counter_count();
    assert_eq!(current_count, 5);
}

#[test]
fn test_aggr_owner_was_set_correctly() {
    // Deploy Counter contract and get the contract address
    let contract_address = deploy("Aggregator");

    // Get an instance of the deployed Counter contract
    let aggregator_dispatcher = IAggregatorDispatcher { contract_address };

    let current_owner = aggregator_dispatcher.get_aggr_owner();
    assert_eq!(current_owner, Accounts::owner());
}


#[test]
fn test_counter() {}

#[test]
fn test_set_count_correctly() {
    let contract_address = deploy("Aggregator");
    let aggregator_dispatcher = IAggregatorDispatcher { contract_address };

    aggregator_dispatcher.set_counter_count(42);
    let count = aggregator_dispatcher.get_counter_count();
    assert_eq!(count, 42, "Count should be set to 42");
}

#[test]
#[should_panic(expected: ('Kill switch is off',))]
fn test_can_not_set_count_when_toggle_is_off() {
    let contract_address = deploy("Aggregator");
    let aggregator_dispatcher = IAggregatorDispatcher { contract_address };

    // Toggle the kill switch off
    aggregator_dispatcher.toggle_kill_switch();

    // This should panic because the kill switch is off
    aggregator_dispatcher.set_counter_count(10);
}



