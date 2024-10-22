use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
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
}

// Deploys the given contract and returns the corresponding contract address
fn deploy_util(contract_name: ByteArray, constructor_calldata: Array<felt252>) -> ContractAddress {
    let contract = declare(contract_name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@constructor_calldata).unwrap();
    contract_address
}

#[test]
fn test_attack_counter_set_count() {

    let mut counterV2_calldata: Array<felt252> = array![Accounts::owner().into()];
    let counterV2_contract_address: ContractAddress = deploy_util("CounterV2", counterV2_calldata);
    let counter_instance = ICounterV2Dispatcher { contract_address: counterV2_contract_address };

    let count_1 = counter_instance.get_count();
    assert_eq!(count_1, 0);

    let mut attacker_calldata: Array<felt252> = array![];
    counterV2_contract_address.serialize(ref attacker_calldata);

    let attack_counter_address: ContractAddress = deploy_util("AttackCounterV2", attacker_calldata);
    let attacker_instance = IAttackCounterv2Dispatcher { contract_address: attack_counter_address };

    attacker_instance.attack_counter_set_count(5);

    let count_2 = counter_instance.get_count();
    println!("count 2____{}", count_2);
    assert_eq!(count_2, 5);

    assert_eq!(count_2, attacker_instance.counter_get_count());

    attacker_instance.attack_counter_set_count(5);

    let count_3 = counter_instance.get_count();
    println!("count 3____{}", count_3);
    assert_eq!(count_3, 10);
}

