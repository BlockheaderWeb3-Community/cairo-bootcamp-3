use snforge_std::{declare, ContractClassTrait, DeclareResultTrait, start_cheat_caller_address};
use starknet::{ContractAddress};
use cairo_bootcamp_3::counter_v3::{ICounterDispatcher, ICounterDispatcherTrait};
use cairo_bootcamp_3::accounts::Accounts;


fn deploy(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let constructor_arg = array![Accounts::owner().into()];
    let (contract_address, _) = contract.deploy(@constructor_arg).unwrap();
    contract_address
}
// get counter inital value
#[test]
fn test_counter_get_count_intiial_valid_value() {
    let contract_address = deploy("counter3");
    let counter_dispatcher = ICounterDispatcher { contract_address };
    let initial_count = counter_dispatcher.get_count();
    assert_eq!(initial_count, 0);
}

//contract woner validation check before mutating contract data
#[test]
#[should_panic(expected: 'address not owner')]
fn test_counter_set_count_when_address_is_not_equal_to_owner() {
    let contract_address = deploy("counter3");
    let account1 = Accounts::account1();
    let counter_dispatcher = ICounterDispatcher { contract_address };
    start_cheat_caller_address(contract_address, account1);
    counter_dispatcher.set_count(50);
    assert_eq!(counter_dispatcher.get_count(), 55);
}


#[test]
fn test_counter_set_count_when_address_is_equal_to_owner() {
    let contract_address = deploy("counter3");
    let owner = Accounts::owner();
    let counter_dispatcher = ICounterDispatcher { contract_address };
    start_cheat_caller_address(contract_address, owner); 
    counter_dispatcher.set_count(50);
    assert_eq!(counter_dispatcher.get_count(), 50);
}
// set count should not be > 50
#[test]
#[should_panic(expected: 'total amount > 50')]
fn test_counter_set_count_when_amount_is_greater() {
    let contract_address = deploy("counter3");
    let account1 = Accounts::account1();
    let counter_dispatcher = ICounterDispatcher { contract_address };
    start_cheat_caller_address(contract_address, account1);
    counter_dispatcher.set_count(55);
    assert_eq!(counter_dispatcher.get_count(), 55);
}

// non owner can not increase count
#[test]
#[should_panic(expected: 'address not owner')]
fn not_owner_test_counter_decrease_count_by_one() {
    let contract_address = deploy("counter3");
    let account1 = Accounts::account1();
    let counter_dispatcher = ICounterDispatcher { contract_address };
    let initial_count = counter_dispatcher.get_count();
    assert_eq!(initial_count, 0);
    start_cheat_caller_address(contract_address, account1);
    counter_dispatcher.decrease_count_by_one();
}

// only owner can decrease count by one
//will panic whenever we try to decrease count by one and total count is less than or equal to zero
#[test]
#[should_panic(expected: 'u32_sub Overflow')]
fn owner_test_counter_decrease_count_by_one_when_count_is_less_than_or_equal_to_zero() {
    let contract_address = deploy("counter3");
    let owner = Accounts::owner();
    let counter_dispatcher = ICounterDispatcher { contract_address };
    let initial_count = counter_dispatcher.get_count();
    assert_eq!(initial_count, 0);
    start_cheat_caller_address(contract_address, owner);
    counter_dispatcher.decrease_count_by_one();
}

#[test]
fn get_owner(){
     let contract_address = deploy("counter3");
    let counter_dispatcher = ICounterDispatcher { contract_address };
    assert_eq!(counter_dispatcher.get_owner(), Accounts::owner());
}

// only owner can increase count by one
//will panic whenever we try to increase count by one and total count is greater or equal to 50
#[test]
fn owner_test_counter_increase_count_by_one_when_count_total_count_is_less_than_fifty() {
    let contract_address = deploy("counter3");
    let owner = Accounts::owner();
    let counter_dispatcher = ICounterDispatcher { contract_address };
    let initial_count = counter_dispatcher.get_count();
    assert_eq!(initial_count, 0);
    start_cheat_caller_address(contract_address, owner);
    counter_dispatcher.increase_count_by_one();
}

// only owner can increase count by one
//will panic when address is not owner
#[test]
#[should_panic(expected: 'address not owner')]
fn non_owner_test_counter_increase_count_by_one() {
    let contract_address = deploy("counter3");
    let owner = Accounts::account1();
    let counter_dispatcher = ICounterDispatcher { contract_address };
    let initial_count = counter_dispatcher.get_count();
    assert_eq!(initial_count, 0);
    start_cheat_caller_address(contract_address, owner);
    counter_dispatcher.increase_count_by_one();
}

//0x40608cd21b4d665f5f79ffbd0e3de9f0a56524aefff407c6a950ca299a36d34
//0x6c0b6d11653afe753d8320e0fbf9149487e40d099b8d6866f50e8ab841d80a5