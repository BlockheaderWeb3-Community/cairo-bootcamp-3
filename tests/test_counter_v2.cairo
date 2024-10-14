use snforge_std::{declare, ContractClassTrait, DeclareResultTrait, start_cheat_caller_address};
use starknet::{ContractAddress};
use cairo_bootcamp_3::counter_v2::{
    ICounterV2Dispatcher, ICounterV2SafeDispatcher, ICounterV2DispatcherTrait,
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
fn test_owner_was_set_correctly() {
    let contract_address = deploy("CounterV2");

    let counter_v2_dispatcher = ICounterV2Dispatcher { contract_address };

    let current_owner = counter_v2_dispatcher.get_current_owner();

    assert_eq!(current_owner, Accounts::owner());
}

#[test]
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

#[test]
#[should_panic(expected: 'same owner')]
fn test_add_new_owner_should_panic_when_new_owner_is_current_owner() {
    let contract_address = deploy("CounterV2");
    let owner = Accounts::owner();

    let counter_v2_dispatcher = ICounterV2Dispatcher { contract_address };
    start_cheat_caller_address(contract_address, owner);

    counter_v2_dispatcher.add_new_owner(owner);
}

