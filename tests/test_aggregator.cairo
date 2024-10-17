use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
use starknet::{ContractAddress};
use cairo_bootcamp_3::killswitch::{IAggregatorDispatcher, IAggregatorDispatcherTrait};

pub mod Accounts {
    use starknet::ContractAddress;
    use core::traits::TryInto;

    pub fn zero() -> ContractAddress {
        0x0000000000000000000000000000000000000000.try_into().unwrap()
    }

    pub fn ownerAddress() -> ContractAddress {
        'ownerAddress'.try_into().unwrap()
    }

    pub fn counterAddress() -> ContractAddress {
        'counterAddress'.try_into().unwrap()
    }

    pub fn killSwitchAddress() -> ContractAddress {
        'killSwitchAddress'.try_into().unwrap()
    }
}

// Deploys the given contract and returns the contract address
fn deploy(name: ByteArray) -> ContractAddress {
    let constructor_args = array![
        Accounts::ownerAddress().into(),
        Accounts::counterAddress().into(),
        Accounts::killSwitchAddress().into()
    ];
    let (contract_address, _) = contract.deploy(@constructor_args).unwrap();
    contract_address
}
#[test]
fn test_owner_was_set_correctly() {
    let contract_address = deploy("Aggregator");

    let aggregator_dispatcher = IAggregatorDispatcher { contract_address };

    let current_owner = aggregator_dispatcher.get_ownable_owner();

    assert_eq!(current_owner, Accounts::owner());
}

