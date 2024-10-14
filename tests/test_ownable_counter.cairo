use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
use starknet::{ContractAddress};
use cairo_bootcamp_3::ownable_counter::{
    IOwnableDispatcher, IOwnableSafeDispatcher, IOwnableDispatcherTrait,
    IOwnableSafeDispatcherTrait, ICounterDispatcher, ICounterSafeDispatcher, ICounterDispatcherTrait,
    ICounterSafeDispatcherTrait
};

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
}

fn deploy(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let constructor_args = array![Accounts::owner().into()];
    let (contract_address, _) = contract.deploy(@constructor_args).unwrap();
    contract_address
}


#[test]
fn test_add_new_owner() {
    let contract_address = deploy("OwnableCounter");

    let account1 = Accounts::account1();

    let owner_dispatcher = IOwnableDispatcher { contract_address };

    owner_dispatcher.add_owner(account1);

    assert(owner_dispatcher.get_owner() == account1, 'Owner was not set correctly');
}


#[test]
#[should_panic(expected: '0 address')]
fn test_add_new_owner_should_panic_when_new_owner_is_zero_address() {
    let contract_address = deploy("OwnableCounter");
    let zero_address = Accounts::zero();

    let owner_dispatcher = IOwnableDispatcher { contract_address };

    owner_dispatcher.add_owner(zero_address);
}

#[test]
fn test_get_owner() {
    let contract_address = deploy("OwnableCounter");

    let owner_dispatcher = IOwnableDispatcher { contract_address };

    assert(owner_dispatcher.get_owner() == Accounts::owner(), 'Owner not set correctly');
}


#[test]
fn test_increase_count() {
    let contract_address = deploy("OwnableCounter");
    let account1 = Accounts::account1();

    let owner_dispatcher = IOwnableDispatcher { contract_address };

    owner_dispatcher.add_owner(account1);

    let counter_dispatcher = ICounterDispatcher { contract_address };

    counter_dispatcher.increase_count(10);

    assert(counter_dispatcher.get_count() == 10, 'Count not set correctly');
}



#[test]
fn test_get_count() {
    let contract_address = deploy("OwnableCounter");

    let counter_dispatcher = ICounterDispatcher { contract_address };

    counter_dispatcher.increase_count(10);

    assert(counter_dispatcher.get_count() == 10, 'Count not set correctly');

}