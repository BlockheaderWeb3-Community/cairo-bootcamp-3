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

#[test]
fn test_add_student_successfully(){
    // deploying the student_registry contract
    let mut student_registry_calldata: Array<felt252> = array![Accounts::owner().into()];
    let student_registry_contract_address: ContractAddress = deploy_util("StudentRegistry", student_registry_calldata);
    let student_registry_instance = IStudentRegistryDispatcher { contract_address: student_registry_contract_address };
    
    let name = 'john';
    let account = Accounts::account1().into();
    let age = 18;
    let xp = 200;
    let is_active = true;

    let result = student_registry_instance.add_student(name, account, age, xp, is_active);
    assert!(result, "should be true");

    let student = student_registry_instance.get_student(0);
    assert_eq!(student, (0, name, account, age, xp, true), "student data doesnt match");
}

#[test]
#[should_panic(expected: 'ZERO ADDRESS!')]
fn test_add_student_should_panic_when_account_is_zero_address(){
        // deploying the student_registry contract
        let mut student_registry_calldata: Array<felt252> = array![Accounts::owner().into()];
        let student_registry_contract_address: ContractAddress = deploy_util("StudentRegistry", student_registry_calldata);
        let student_registry_instance = IStudentRegistryDispatcher { contract_address: student_registry_contract_address };
        
        let name = 'john';
        let account = Accounts::zero().into();
        let age = 18;
        let xp = 200;
        let is_active = true;
    
        let result = student_registry_instance.add_student(name, account, age, xp, is_active);
        assert!(!result, "should be false");
}


#[test]
#[should_panic(expected: 'age cannot be 0')]
fn test_add_student_should_panic_when_age_is_zero(){
    let mut student_registry_calldata: Array<felt252> = array![Accounts::owner().into()];
    let student_registry_contract_address: ContractAddress = deploy_util("StudentRegistry", student_registry_calldata);
    let student_registry_instance = IStudentRegistryDispatcher { contract_address: student_registry_contract_address };
    
    let name = 'john';
    let account = Accounts::account1().into();
    let age = 0;
    let xp = 200;
    let is_active = true;

    let result = student_registry_instance.add_student(name, account, age, xp, is_active);
    assert!(!result, "should be false");
}

#[test]
fn test_update_student_successfully(){
    let mut student_registry_calldata: Array<felt252> = array![Accounts::owner().into()];
    let student_registry_contract_address: ContractAddress = deploy_util("StudentRegistry", student_registry_calldata);
    let student_registry_instance = IStudentRegistryDispatcher { contract_address: student_registry_contract_address };
    
    let id = 0;
    let name = 'john';
    let account = Accounts::account1().into();
    let account2 = Accounts::account2().into();
    let age = 18;
    let xp = 200;
    let is_active = true;

    let result = student_registry_instance.add_student(name, account, age, xp, is_active);
    assert!(result, "should be true");


    let student = student_registry_instance.get_student(0);
    assert_eq!(student, (0, name, account, age, xp, true), "student data doesnt match");

    let update = student_registry_instance.update_student(id, name, account2, age, xp, is_active);
    assert!(update, "should be true");

    let student_update = student_registry_instance.get_student(0);
    assert_eq!(student, (0, name, account, age, xp, true), "student data doesnt match");
}

#[test]
#[should_panic(expected: 'ZERO ADDRESS!')]
fn test_update_student_should_panic_if_zero_address(){
    let mut student_registry_calldata: Array<felt252> = array![Accounts::owner().into()];
    let student_registry_contract_address: ContractAddress = deploy_util("StudentRegistry", student_registry_calldata);
    let student_registry_instance = IStudentRegistryDispatcher { contract_address: student_registry_contract_address };
    
    let id = 0;
    let name = 'john';
    let account = Accounts::account1().into();
    let account2 = Accounts::zero().into();
    let age = 18;
    let xp = 200;
    let is_active = true;

    let result = student_registry_instance.add_student(name, account, age, xp, is_active);
    assert!(result, "should be true");


    let student = student_registry_instance.get_student(0);
    assert_eq!(student, (0, name, account, age, xp, true), "student data doesnt match");

    let update = student_registry_instance.update_student(id, name, account2, age, xp, is_active);
    assert!(!update, "should be false");
}



