use snforge_std::{declare, ContractClassTrait, DeclareResultTrait, start_cheat_caller_address};
use starknet::{ContractAddress};
use cairo_bootcamp_3::{
    attack_counter_v2::{IAttackCounterDispatcher, IAttackCounterDispatcherTrait},
    counter_v2::{ICounterV2Dispatcher, ICounterV2DispatcherTrait}
};
use cairo_bootcamp_3::accounts::{Accounts};



fn deploy(name: ByteArray, call_data: Array<felt252>) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@call_data).unwrap();
    contract_address
}


// test for set count through attacker counter 
#[test]
fn test_set_attack_counter() {
    // depoly counter_v2 and get the contract Address in return
    let mut counter_calldata: Array<felt252> = array![Accounts::owner().into()];
    let counter_contract_address: ContractAddress = deploy("CounterV2", counter_calldata);

    // counter_v2 instance
    let counter_v2_instance = ICounterV2Dispatcher { contract_address: counter_contract_address };

    // setting attacker call data
    let mut attacker_call_data: Array<felt252> = array![];
    counter_contract_address.serialize(ref attacker_call_data);

    // deploy attaker_counter_v2 to get it contract address in return
    let attack_counter_address: ContractAddress = deploy("AttackCounter", attacker_call_data);


    // assert that count initial value is 0
    let count_1 = counter_v2_instance.get_count();
    assert_eq!(count_1, 0);

    // get attacker_v2 
    let attacker_instance = IAttackCounterDispatcher { contract_address: attack_counter_address };

    // attack count and increase it by 100
    attacker_instance.attack_count(100);
    let count_2 = counter_v2_instance.get_count();
    assert_eq!(count_2, 100 );

    // attack count and increase it by 100 making it 200
    attacker_instance.attack_count(200);
    let count_3 = counter_v2_instance.get_count();
    assert_eq!(count_3, 300 );

    // attack count and increase it by 100 making it 300
    attacker_instance.attack_count(300);
    let count_4 = counter_v2_instance.get_count();
    assert_eq!(count_4, 600 );

}

#[test]
fn test_set_attack_counter_by_one() {
    // depoly counter_v2 and get the contract Address in return
    let mut counter_calldata: Array<felt252> = array![Accounts::owner().into()];
    let counter_contract_address: ContractAddress = deploy("CounterV2", counter_calldata);

    // counter_v2 instance
    let counter_v2_instance = ICounterV2Dispatcher { contract_address: counter_contract_address };

    // setting attacker call data
    let mut attacker_call_data: Array<felt252> = array![];
    counter_contract_address.serialize(ref attacker_call_data);

    // deploy attaker_counter_v2 to get it contract address in return
    let attack_counter_address: ContractAddress = deploy("AttackCounter", attacker_call_data);


    // assert that count initial value is 0
    let count_1 = counter_v2_instance.get_count();
    assert_eq!(count_1, 0);

    // get attacker_v2 
    let attacker_instance = IAttackCounterDispatcher { contract_address: attack_counter_address };

    // attack count and increase it by 1
    attacker_instance.attack_count_by_one();
    let count_2 = counter_v2_instance.get_count();
    assert_eq!(count_2, 1 );

    // attack count and increase it by 1 making it 2
    attacker_instance.attack_count_by_one();
    let count_3 = counter_v2_instance.get_count();
    assert_eq!(count_3, 2 );

    // attack count and increase it by 1 making it 3
    attacker_instance.attack_count_by_one();
    let count_4 = counter_v2_instance.get_count();
    assert_eq!(count_4, 3 );

}


#[test]
#[should_panic(expected: '0 address')]
fn test_add_new_owner_attack() {
    // depoly counter_v2 and get the contract Address in return
    let mut counter_calldata: Array<felt252> = array![Accounts::owner().into()];
    let counter_contract_address: ContractAddress = deploy("CounterV2", counter_calldata);

    // counter_v2 instance
    let counter_v2_instance = ICounterV2Dispatcher { contract_address: counter_contract_address };

    // setting attacker call data
    let mut attacker_call_data: Array<felt252> = array![];
    counter_contract_address.serialize(ref attacker_call_data);

    // deploy attaker_counter_v2 to get it contract address in return
    let attack_counter_address: ContractAddress = deploy("AttackCounter", attacker_call_data);


    // assert that count initial value is 0
    let count_1 = counter_v2_instance.get_current_owner();
    assert_eq!(count_1, Accounts::owner());

    // get attacker_v2 
    let attacker_instance = IAttackCounterDispatcher { contract_address: attack_counter_address };
    
    start_cheat_caller_address(counter_contract_address,Accounts::owner());

    //add a new owner with attacker counter
    attacker_instance.attacker_add_new_owner(Accounts::zero())
}



#[test]
#[should_panic(expected: 'same owner')]
fn test_add_new_owner_attack_same_owner() {
    // depoly counter_v2 and get the contract Address in return
    let mut counter_calldata: Array<felt252> = array![Accounts::owner().into()];
    let counter_contract_address: ContractAddress = deploy("CounterV2", counter_calldata);

    // counter_v2 instance
    let counter_v2_instance = ICounterV2Dispatcher { contract_address: counter_contract_address };

    // setting attacker call data
    let mut attacker_call_data: Array<felt252> = array![];
    counter_contract_address.serialize(ref attacker_call_data);

    // deploy attaker_counter_v2 to get it contract address in return
    let attack_counter_address: ContractAddress = deploy("AttackCounter", attacker_call_data);


    // assert that count initial value is 0
    let count_1 = counter_v2_instance.get_current_owner();
    assert_eq!(count_1, Accounts::owner());

    // get attacker_v2 
    let attacker_instance = IAttackCounterDispatcher { contract_address: attack_counter_address };
    
    start_cheat_caller_address(counter_contract_address,Accounts::owner());

    //add a new owner with attacker counter
    attacker_instance.attacker_add_new_owner(Accounts::owner())
}


#[test]
#[should_panic(expected: 'caller not owner')]
fn test_add_new_owner_attack_diffrent_address() {
    // depoly counter_v2 and get the contract Address in return
    let mut counter_calldata: Array<felt252> = array![Accounts::owner().into()];
    let counter_contract_address: ContractAddress = deploy("CounterV2", counter_calldata);

    // counter_v2 instance
    let counter_v2_instance = ICounterV2Dispatcher { contract_address: counter_contract_address };

    // setting attacker call data
    let mut attacker_call_data: Array<felt252> = array![];
    counter_contract_address.serialize(ref attacker_call_data);

    // deploy attaker_counter_v2 to get it contract address in return
    let attack_counter_address: ContractAddress = deploy("AttackCounter", attacker_call_data);


    // assert that count initial value is 0
    let count_1 = counter_v2_instance.get_current_owner();
    assert_eq!(count_1, Accounts::owner());

    // get attacker_v2 
    let attacker_instance = IAttackCounterDispatcher { contract_address: attack_counter_address };
    
    start_cheat_caller_address(counter_contract_address,Accounts::account1());

    //add a new owner with attacker counter
    attacker_instance.attacker_add_new_owner(Accounts::owner())
}

#[test]
fn test_add_new_owner_attack_current_owner_address() {
    // depoly counter_v2 and get the contract Address in return
    let mut counter_calldata: Array<felt252> = array![Accounts::owner().into()];
    let counter_contract_address: ContractAddress = deploy("CounterV2", counter_calldata);

    // counter_v2 instance
    let counter_v2_instance = ICounterV2Dispatcher { contract_address: counter_contract_address };

    // setting attacker call data
    let mut attacker_call_data: Array<felt252> = array![];
    counter_contract_address.serialize(ref attacker_call_data);

    // deploy attaker_counter_v2 to get it contract address in return
    let attack_counter_address: ContractAddress = deploy("AttackCounter", attacker_call_data);


    // assert that count initial value is 0
    let count_1 = counter_v2_instance.get_current_owner();
    assert_eq!(count_1, Accounts::owner());

    // get attacker_v2 
    let attacker_instance = IAttackCounterDispatcher { contract_address: attack_counter_address };
    
    start_cheat_caller_address(counter_contract_address,Accounts::owner());

    //add a new owner with attacker counter
    attacker_instance.attacker_add_new_owner(Accounts::account1())
}