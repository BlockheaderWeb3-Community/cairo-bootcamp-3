use snforge_std::{declare, ContractClassTrait, DeclareResultTrait, start_cheat_caller_address};
use starknet::{ContractAddress};
use cairo_bootcamp_3::student_registry::{
    IStudentRegistryDispatcher, IStudentRegistryDispatcherTrait
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

// deployment failed
#[test]
#[should_panic(expected: 'Result::unwrap failed.')]
fn contract_deployment_should_panic_when_deployed_with_address_zero() {
    // deploying the student_registry contract
    let mut student_registry_calldata: Array<felt252> = array![Accounts::zero().into()];
    let student_registry_contract_address: ContractAddress = deploy_util(
        "StudentRegistry", student_registry_calldata
    );
    let student_registry_instance = IStudentRegistryDispatcher {
        contract_address: student_registry_contract_address
    };
}

// successful deployment
#[test]
fn contract_deployed_successfully() {
    // deploying the student_registry contract
    let mut student_registry_calldata: Array<felt252> = array![Accounts::owner().into()];
    let student_registry_contract_address: ContractAddress = deploy_util(
        "StudentRegistry", student_registry_calldata
    );
    let student_registry_instance = IStudentRegistryDispatcher {
        contract_address: student_registry_contract_address
    };

    let owner = student_registry_instance.get_current_owner();

    assert_eq!(owner, Accounts::owner().into());
}

// student addition failed when user is passing zero address
#[test]
#[should_panic(expected: 'ZERO ADDRESS!')]
fn test_add_student_should_panic_when_account_is_zero_address() {
    // deploying the student_registry contract
    let mut student_registry_calldata: Array<felt252> = array![Accounts::owner().into()];
    let student_registry_contract_address: ContractAddress = deploy_util(
        "StudentRegistry", student_registry_calldata
    );
    let student_registry_instance = IStudentRegistryDispatcher {
        contract_address: student_registry_contract_address
    };

    let name = 'john';
    let account = Accounts::zero().into();
    let age = 18;
    let xp = 200;
    let is_active = true;

    let result = student_registry_instance.add_student(name, account, age, xp, is_active);
    assert!(!result, "should be false");
}

// student addition failed when users age is zero
#[test]
#[should_panic(expected: 'age cannot be 0')]
fn test_add_student_should_panic_when_age_is_zero() {
    let mut student_registry_calldata: Array<felt252> = array![Accounts::owner().into()];
    let student_registry_contract_address: ContractAddress = deploy_util(
        "StudentRegistry", student_registry_calldata
    );
    let student_registry_instance = IStudentRegistryDispatcher {
        contract_address: student_registry_contract_address
    };

    let name = 'john';
    let account = Accounts::account1().into();
    let age = 0;
    let xp = 200;
    let is_active = true;

    let result = student_registry_instance.add_student(name, account, age, xp, is_active);
    assert!(!result, "should be false");
}

// student added successfully
#[test]
fn test_add_student_successfully() {
    // deploying the student_registry contract
    let mut student_registry_calldata: Array<felt252> = array![Accounts::owner().into()];
    let student_registry_contract_address: ContractAddress = deploy_util(
        "StudentRegistry", student_registry_calldata
    );
    let student_registry_instance = IStudentRegistryDispatcher {
        contract_address: student_registry_contract_address
    };

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

// multipple students added succseefully
#[test]
fn test_add_multiple_student_successfully() {
    // deploying the student_registry contract
    let mut student_registry_calldata: Array<felt252> = array![Accounts::owner().into()];
    let student_registry_contract_address: ContractAddress = deploy_util(
        "StudentRegistry", student_registry_calldata
    );
    let student_registry_instance = IStudentRegistryDispatcher {
        contract_address: student_registry_contract_address
    };

    let name = 'john';
    let account = Accounts::account1().into();
    let age = 18;
    let xp = 200;
    let is_active = true;

    let name2 = 'car';
    let account2 = Accounts::account1().into();
    let age2 = 18;
    let xp2 = 200;
    let is_active2 = true;

    let name3 = 'john';
    let account3 = Accounts::account1().into();
    let age3 = 18;
    let xp3 = 200;
    let is_active3 = true;

    // Add first student
    let result = student_registry_instance.add_student(name, account, age, xp, is_active);
    assert!(result, "should be true");

    // Add second student
    let result2 = student_registry_instance.add_student(name2, account2, age2, xp2, is_active2);
    assert!(result2, "should be true");

    // Add third student
    let result3 = student_registry_instance.add_student(name3, account3, age3, xp3, is_active3);
    assert!(result3, "should be true");

    // Verify first student
    let student = student_registry_instance.get_student(0);
    assert_eq!(student, (0, name, account, age, xp, true), "first student data doesn't match");

    // Verify second student
    let student2 = student_registry_instance.get_student(1);
    assert_eq!(
        student2, (1, name2, account2, age2, xp2, true), "second student data doesn't match"
    );

    // Verify third student
    let student3 = student_registry_instance.get_student(2);
    assert_eq!(student3, (2, name3, account3, age3, xp3, true), "third student data doesn't match");
}

// update student should fail if address is zero address
#[test]
#[should_panic(expected: 'ZERO ADDRESS!')]
fn test_update_student_should_panic_if_zero_address() {
    let mut student_registry_calldata: Array<felt252> = array![Accounts::owner().into()];
    let student_registry_contract_address: ContractAddress = deploy_util(
        "StudentRegistry", student_registry_calldata
    );
    let student_registry_instance = IStudentRegistryDispatcher {
        contract_address: student_registry_contract_address
    };

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

// should update student successfully
#[test]
fn test_update_student_successfully() {
    let mut student_registry_calldata: Array<felt252> = array![Accounts::owner().into()];
    let student_registry_contract_address: ContractAddress = deploy_util(
        "StudentRegistry", student_registry_calldata
    );
    let student_registry_instance = IStudentRegistryDispatcher {
        contract_address: student_registry_contract_address
    };

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
    assert_eq!(student_update, (0, name, account2, age, xp, true), "student data doesnt match");
}

