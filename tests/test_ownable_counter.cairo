use starknet::{ContractAddress};

use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
use cairo_bootcamp_3::ownable_counter::{IOwnableCounterDispatcher};

pub mod Accounts {
    use starknet::ContractAddress;
    use starknet::contract_address_const;
    use core::traits::TryInto;

    pub fn zero() -> ContractAddress {
        0x0000000000000000000000000000000000000000.try_into().unwrap()
    }

    pub fn admin() -> ContractAddress {
        contract_address_const::<'admin'>()
    }

    pub fn owner() -> ContractAddress {
        contract_address_const::<'owner'>()
    }
}

fn deploy_contract(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let constructor_args = array![Accounts::admin().into()];
    let (contract_address, _) = contract.deploy(@constructor_args).unwrap();
    contract_address
}

#[test]
fn test_increase_count() {
    let contract_address = deploy_contract("OwnableCounter");

    let dispatcher = IOwnableCounterDispatcher { contract_address };

    let count = dispatcher.increase_count(234);

    assert(count == 234, 'count not increased');
}

#[test]
fn test_get_count() {
    let contract_address = deploy_contract("OwnableCounter");

    let dispatcher = IOwnableCounterDispatcher { contract_address };

    let count = dispatcher.increase_count(234);

    assert(count == 20, 'count not increased');

    let count = dispatcher.get_count();
    assert(count, 'count not retrieved');
}

#[test]
fn test_add_owner() {
    let contract_address = deploy_contract("OwnableCounter");

    let dispatcher = IOwnableCounterDispatcher { contract_address };

    let owner = dispatcher.add_owner(Accounts::owner());
    assert(owner == Accounts::owner(), 'owner not added');
}

#[test]
fn test_get_owner() {
    let contract_address = deploy_contract("OwnableCounter");

    let dispatcher = IOwnableCounterDispatcher { contract_address };

    let owner = dispatcher.add_owner(Accounts::owner());
    assert(owner == Accounts::owner(), 'owner not added');

    let owner = dispatcher.get_owner();
    assert(owner, 'owner not retrieved');
}
