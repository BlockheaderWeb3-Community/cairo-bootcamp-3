use snforge_std::{declare, ContractClassTrait, DeclareResultTrait, start_cheat_caller_address};
use starknet::{ContractAddress};
use cairo_bootcamp_3::student_registry::{IStudentRegistryDispatcher, IStudentRegistryDispatcherTrait};


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
fn contract_deployed_successfully() {
        // deploying the student_registry contract
        let mut student_registry_calldata: Array<felt252> = array![Accounts::owner().into()];
        let student_registry_contract_address: ContractAddress = deploy_util("StudentRegistry", student_registry_calldata);
        let student_registry_instance = IStudentRegistryDispatcher { contract_address: student_registry_contract_address };
    
        let owner = student_registry_instance.get_current_owner();

        assert_eq!(owner, Accounts::owner().into());
}

#[test]
#[should_panic(expected: 'Result::unwrap failed.')]
fn contract_deployment_should_panic_when_deployed_with_address_zero() {
        // deploying the student_registry contract
        let mut student_registry_calldata: Array<felt252> = array![Accounts::zero().into()];
        let student_registry_contract_address: ContractAddress = deploy_util("StudentRegistry", student_registry_calldata);
        let student_registry_instance = IStudentRegistryDispatcher { contract_address: student_registry_contract_address };
}


