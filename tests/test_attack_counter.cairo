use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
use starknet::{ContractAddress};
use cairo_bootcamp_3::{
    counter::{ICounterDispatcher, ICounterDispatcherTrait},
    attack_counter::{IAttackCounterDispatcher, IAttackCounterDispatcherTrait}
};

// Deploys the given contract and returns the corresponding contract address
fn deploy_util(contract_name: ByteArray, constructor_calldata: Array<felt252>) -> ContractAddress {
    let contract = declare(contract_name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@constructor_calldata).unwrap();
    contract_address
}


// Instruct snforge to only run this function when the `snforge test` command is used
#[test]
fn test_can_attacker_counter_count() {
    // Deploy Counter contract and get the contract address

    let mut counter_calldata: Array<felt252> = array![];

    let counter_contract_address: ContractAddress = deploy_util("Counter", counter_calldata);

    // Get an instance of the deployed Counter contract
    let counter_instance = ICounterDispatcher { contract_address: counter_contract_address };

    // test that Counter contract's count value = 0
    // Get the initial value of count from storage
    let count_1 = counter_instance.get_count();
    // Assert that the inital count value is what is 0
    assert_eq!(count_1, 0);

    // setup AttackCounter contract calldata
    let mut attacker_calldata: Array<felt252> = array![];
    counter_contract_address.serialize(ref attacker_calldata);

    // deploy AttackCounter contract
    let attack_counter_address: ContractAddress = deploy_util("AttackCounter", attacker_calldata);

    // get AttackCounter contract instance
    let attacker_instance = IAttackCounterDispatcher { contract_address: attack_counter_address };

    // call attack count to modify Counter contract's count state value to 100
    attacker_instance.attack_count(100);

    // fetch Counter's 2nd count value
    let count_2 = counter_instance.get_count();
    println!("count 2____{}", count_2);
    // Assert that the 2nd count value was successfully set to 100
    assert_eq!(count_2, 100);

    // assert that Attacker's counter_count matches the counter's count state variable
    assert_eq!(count_2, attacker_instance.counter_count());

    // call attack count to modify Counter contract's count state value to 200
     attacker_instance.attack_count(100);

      // fetch Counter's 2nd count value
    let count_3 = counter_instance.get_count();
    println!("count 3____{}", count_3);
    // Assert that the 3rd count value was successfully set to 200
    assert_eq!(count_3, 200);
}
