use snforge_std::{
    declare, ContractClassTrait, DeclareResultTrait, start_cheat_caller_address, spy_events,
    EventSpyAssertionsTrait
};
use starknet::{ContractAddress};
use cairo_bootcamp_3::counter_v2::{
    CounterV2, ICounterV2Dispatcher, ICounterV2SafeDispatcher, ICounterV2DispatcherTrait,
    ICounterV2SafeDispatcherTrait
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

// Deploys the given contract and returns the contract address
fn deploy(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let constructor_args = array![Accounts::owner().into()];
    let (contract_address, _) = contract.deploy(@constructor_args).unwrap();
    contract_address
}

#[test]
fn test_add_new_owner() {
    let contract_address = deploy("CounterV2");
    let owner = Accounts::owner();
    let account1 = Accounts::account1();

    let counter_v2_dispatcher = ICounterV2Dispatcher { contract_address };
    start_cheat_caller_address(contract_address, owner);

    let mut spy = spy_events();

    counter_v2_dispatcher.add_new_owner(account1);
    let owner_1 = counter_v2_dispatcher.get_current_owner();

    assert_eq!(owner_1, account1);

    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    CounterV2::Event::counter_add_new_owner(
                        CounterV2::counter_add_new_owner { new_owner: account1 }
                    )
                )
            ]
        );
}

#[test]
#[should_panic(expected: 'amount cannot be zero')]
fn test_set_count_should_panic_when_users_Sets_count_to_zero() {
    let contract_address = deploy("CounterV2");

    let counter_v2_dispatcher = ICounterV2Dispatcher { contract_address };

    counter_v2_dispatcher.set_count(0);
}


#[test]
fn test_set_count_succesfully() {
    let contract_address = deploy("CounterV2");
    let counter_v2_dispatcher = ICounterV2Dispatcher { contract_address };

    let mut spy = spy_events();

    counter_v2_dispatcher.set_count(20);

    let count_1 = counter_v2_dispatcher.get_count();

    assert_eq!(count_1, 20);

    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    CounterV2::Event::counter_set_count(CounterV2::counter_set_count { amount: 20 })
                )
            ]
        );

    spy = spy_events();

    counter_v2_dispatcher.set_count(40);

    let count_1 = counter_v2_dispatcher.get_count();

    assert_eq!(count_1, 60);

    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    CounterV2::Event::counter_set_count(CounterV2::counter_set_count { amount: 60 })
                )
            ]
        );
}

#[test]
fn test_increase_count_by_one() {
    let contract_address = deploy("CounterV2");
    let counter_v2_dispatcher = ICounterV2Dispatcher { contract_address };

    let mut spy = spy_events();

    let count_1 = counter_v2_dispatcher.get_count();

    assert_eq!(count_1, 0);

    counter_v2_dispatcher.increase_count_by_one();

    let count_2 = counter_v2_dispatcher.get_count();

    assert_eq!(count_2, 1);

    spy
        .assert_emitted(
            @array![
                (
                    contract_address,
                    CounterV2::Event::counter_increase_count_by_one(
                        CounterV2::counter_increase_count_by_one { total_amount: 2 }
                    )
                )
            ]
        );
}

#[test]
#[should_panic(expected: 'Should have panicked')]
fn test_add_new_owner_should_panic_when_called_from_unauthorised_address() {
    let contract_address = deploy("CounterV2");
    let account1 = Accounts::account1();

    let counter_v2_safe_dispatcher = ICounterV2SafeDispatcher { contract_address };

    start_cheat_caller_address(contract_address, account1);

    match counter_v2_safe_dispatcher.add_new_owner(account1) {
        Result::Ok(_) => core::panic_with_felt252('Should have panicked'),
        Result::Err(panic_data) => {
            assert(*panic_data.at(0) == 'caller not owner', *panic_data.at(0));
        }
    };
}

#[test]
#[should_panic(expected: '0 address')]
fn test_add_new_owner_should_panic_when_new_owner_is_zero_address() {
    let contract_address = deploy("CounterV2");
    let owner = Accounts::owner();
    let zero_address = Accounts::zero();

    let counter_v2_dispatcher = ICounterV2Dispatcher { contract_address };
    start_cheat_caller_address(contract_address, owner);

    counter_v2_dispatcher.add_new_owner(zero_address);
}

