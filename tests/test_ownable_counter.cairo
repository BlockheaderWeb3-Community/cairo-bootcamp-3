use snforge_std::{declare,ContractClassTrait,DeclareResultTrait};
use starknet::{ContractAddress};
use cairo_bootcamp_3::ownable_counter::{ICounterDispatcher,ICounterDispatcherTrait,IOwnableDispatcher, IOwnableDispatcherTrait};
use cairo_bootcamp_3::accounts::Accounts;

fn deploy(name:ByteArray)->ContractAddress{
 let contract = declare(name).unwrap().contract_class();
 let constructor_arg = array![Accounts::owner().into()];
 let (contract_address,_) = contract.deploy(@constructor_arg).unwrap();
 contract_address
}

#[test]
// ownable counter initial value
fn test_ownable_counter_get_count() {
    let contract_address = deploy("OwnableCounter");
    let counter_dispatcher = ICounterDispatcher { contract_address };
    let initial_count = counter_dispatcher.get_count();
    assert(initial_count==0,'intial value error');
}

// ownable counter initial value check for value > 0
#[test]
#[should_panic(expected: 'initial value check error')]
fn test_ownable_counter_get_count_value_greater_than_zero() {
    let contract_address = deploy("OwnableCounter");
    let counter_dispatcher = ICounterDispatcher { contract_address };
    let initial_count = counter_dispatcher.get_count();
    assert(initial_count==3, 'initial value check error');
}

// increase ownable counter with number > 0
#[test]
fn test_ownable_counter_set_count_with_non_zero_number() {
    let contract_address = deploy("OwnableCounter");
    let counter_dispatcher = ICounterDispatcher { contract_address };
    counter_dispatcher.increase_count(32);
    assert_eq!(counter_dispatcher.get_count(), 32);    
}

// increase ownable count with number <= 0
#[test]
#[should_panic(expected: 'Amount cannot be 0')]
fn test_ownable_counter_set_count_with_zero_number() {
    let contract_address = deploy("OwnableCounter");
    let counter_dispatcher = ICounterDispatcher { contract_address };
    counter_dispatcher.increase_count(0);
    assert_eq!(counter_dispatcher.get_count(), 0);    
}

// get ownable counter contract owner
#[test]
fn get_ownable_counter_contract_owner_valid_check() {
    let contract_address = deploy("OwnableCounter");
    let counter_dispatcher = IOwnableDispatcher { contract_address };
    let owner = counter_dispatcher.get_owner();
    assert_eq!(owner, Accounts::owner());
}


// get ownable counter contract owner
#[test]
#[should_panic(expected: 'address is not owner')]
fn get_ownable_counter_contract_owner_invalid_check() {
    let contract_address = deploy("OwnableCounter");
    let counter_dispatcher = IOwnableDispatcher { contract_address };
    let owner = counter_dispatcher.get_owner();
    assert(owner==Accounts::account1(),'address is not owner');
}

// add neww owner
#[test]
fn test_add_owner_with_valid_address(){
    let contract_address = deploy("OwnableCounter");
    let counter_dispatcher = IOwnableDispatcher { contract_address };
    counter_dispatcher.add_owner(Accounts::account1());

}