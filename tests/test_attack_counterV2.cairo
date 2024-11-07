use snforge_std::{declare, ContractClassTrait, DeclareResultTrait,};


use starknet::{ContractAddress};
use cairo_bootcamp_3::{
    counter_v2::{ICounterV2Dispatcher, ICounterV2DispatcherTrait},
    attack_counterV2::{IAttackCounterv2Dispatcher, IAttackCounterv2DispatcherTrait}
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

// Deploys the given contract and returns the corresponding contract address
fn deploy_util(contract_name: ByteArray, constructor_calldata: Array<felt252>) -> ContractAddress {
    let contract = declare(contract_name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@constructor_calldata).unwrap();
    contract_address
}

#[test]
fn test_attack_counter_set_count() {
    // deploying the CounterV2 contract
    let mut counterV2_calldata: Array<felt252> = array![Accounts::owner().into()];
    let counterV2_contract_address: ContractAddress = deploy_util("CounterV2", counterV2_calldata);
    let counter_instance = ICounterV2Dispatcher { contract_address: counterV2_contract_address };

    // assert counter is default when deploed
    let count_1 = counter_instance.get_count();
    assert_eq!(count_1, 0);

    // deploying the attcaker contract
    let mut attacker_calldata: Array<felt252> = array![];
    counterV2_contract_address.serialize(ref attacker_calldata);

    let attack_counter_address: ContractAddress = deploy_util("AttackCounterV2", attacker_calldata);
    let attacker_instance = IAttackCounterv2Dispatcher { contract_address: attack_counter_address };

    // use attcaker contract to set count
    attacker_instance.attack_counter_set_count(5);

    // assert the attck counter worked
    let count_2 = counter_instance.get_count();
    assert_eq!(count_2, 5);

    assert_eq!(count_2, attacker_instance.counter_get_count());

    // use attcaker contract to set count again
    attacker_instance.attack_counter_set_count(5);

    // assert the attck counter worked and it increased again
    let count_3 = counter_instance.get_count();
    assert_eq!(count_3, 10);
}

// test user should panic if the counter is zero address
#[test]
#[should_panic(expected: 'Result::unwrap failed.')]
fn test_attack_counter_set_count_should_panic_if_zero_Address() {
    // deploying the CounterV2 contract
    let mut counterV2_calldata: Array<felt252> = array![Accounts::owner().into()];
    let counterV2_contract_address: ContractAddress = deploy_util("CounterV2", counterV2_calldata);
    let counter_instance = ICounterV2Dispatcher { contract_address: counterV2_contract_address };

    // assert counter is default when deploed
    let count_1 = counter_instance.get_count();
    assert_eq!(count_1, 0);

    // trying to serialize wuth zero address to make the function panic
    let mut attacker_calldata: Array<felt252> = array![];
    Accounts::zero().serialize(ref attacker_calldata);
    deploy_util("AttackCounterV2", attacker_calldata);
}


#[test]
fn test_attack_counter_add_new_owner() {
    // deploying the CounterV2 contract
    let mut counterV2_calldata: Array<felt252> = array![Accounts::owner().into()];
    let counterV2_contract_address: ContractAddress = deploy_util("CounterV2", counterV2_calldata);
    let counter_instance = ICounterV2Dispatcher { contract_address: counterV2_contract_address };

    // assert owner is default owner set when deploed
    let owner_1 = counter_instance.get_current_owner();
    assert_eq!(owner_1, Accounts::owner().into());

    // deploying the attcaker contract
    let mut attacker_calldata: Array<felt252> = array![];
    counterV2_contract_address.serialize(ref attacker_calldata);

    let attack_counter_address: ContractAddress = deploy_util("AttackCounterV2", attacker_calldata);
    let attacker_instance = IAttackCounterv2Dispatcher { contract_address: attack_counter_address };

    // use attcaker contract to add new owner
    attacker_instance.attack_counter_add_new_owner(Accounts::account1().into());

    // assert that the attck contract has succesfully changed the owner
    let owner_2 = counter_instance.get_current_owner();
    assert_eq!(owner_2, Accounts::account1().into());

    assert_eq!(owner_2, attacker_instance.counter_get_current_owner());

    // use attcaker contract to add new owneragain
    attacker_instance.attack_counter_add_new_owner(Accounts::account2().into());

    // assert that the attck contract has succesfully changed the owner
    let owner_3 = counter_instance.get_current_owner();
    assert_eq!(owner_3, Accounts::account2().into());

    assert_eq!(owner_3, attacker_instance.counter_get_current_owner());
}

#[test]
fn test_attack_counter_increase_count_by_one() {
    // deploying the CounterV2 contract
    let mut counterV2_calldata: Array<felt252> = array![Accounts::owner().into()];
    let counterV2_contract_address: ContractAddress = deploy_util("CounterV2", counterV2_calldata);
    let counter_instance = ICounterV2Dispatcher { contract_address: counterV2_contract_address };

    // assert count is default when deploed
    let count_1 = counter_instance.get_count();
    assert_eq!(count_1, 0);

    // deploy attacker contract
    let mut attacker_calldata: Array<felt252> = array![];
    counterV2_contract_address.serialize(ref attacker_calldata);

    let attack_counter_address: ContractAddress = deploy_util("AttackCounterV2", attacker_calldata);
    let attacker_instance = IAttackCounterv2Dispatcher { contract_address: attack_counter_address };

    // use attacker contract to increae count by one
    attacker_instance.attack_counter_increase_count_by_one();

    // assert that the attack succefully incerased count
    let count_2 = counter_instance.get_count();
    assert_eq!(count_2, 1);

    assert_eq!(count_2, attacker_instance.counter_get_count());

    // call the attacker contract again to confirm
    attacker_instance.attack_counter_increase_count_by_one();

    // check if was successful
    let count_3 = counter_instance.get_count();
    assert_eq!(count_3, 2);
    assert_eq!(count_3, attacker_instance.counter_get_count());
}
