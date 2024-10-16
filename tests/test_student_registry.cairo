use starknet::{ContractAddress};

use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
use cairo_bootcamp_3::student_registry::{
    IStudentRegistryDispatcher, IStudentRegistryDispatcherTrait
};

pub mod Accounts {
    use starknet::ContractAddress;
    use starknet::contract_address_const;
    use core::traits::TryInto;

    pub fn zero() -> ContractAddress {
        0x0000000000000000000000000000000000000000.try_into().unwrap()
    }

    pub fn admin() -> ContractAddress {
        contract_address_const::<'admin'>()
    }

    pub fn student1() -> ContractAddress {
        contract_address_const::<'student1'>()
    }

    pub fn student2() -> ContractAddress {
        contract_address_const::<'student2'>()
    }
}

fn deploy_contract(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let constructor_args = array![Accounts::admin().into()];
    let (contract_address, _) = contract.deploy(@constructor_args).unwrap();
    contract_address
}

#[test]
fn test_add_student() {
    let contract_address = deploy_contract("StudentRegistry");

    let dispatcher = IStudentRegistryDispatcher { contract_address };

    let student = dispatcher.add_student('Paul', Accounts::student1(), 18, 40, true);

    assert(student == true, 'Student not added');
}

#[test]
fn test_get_student() {
    // add student
    let contract_address = deploy_contract("StudentRegistry");

    let dispatcher = IStudentRegistryDispatcher { contract_address };

    let student = dispatcher.add_student('Paul', Accounts::student1(), 18, 40, true);
    assert(student == true, 'Student not added');

    // get added student
    let (name, account, age, xp, is_active) = dispatcher.get_student(Accounts::student1());
    assert(name == 'Paul', 'name should match');
    assert(account == Accounts::student1(), 'account should match');
    assert(age == 18, 'age should match');
    assert(xp == 40, 'xp should match');
    assert(is_active == true, 'is_active should match');
}

#[test]
fn test_update_student() {
    let contract_address = deploy_contract("StudentRegistry");

    let dispatcher = IStudentRegistryDispatcher { contract_address };

    let student = dispatcher.add_student('Paul', Accounts::student1(), 19, 40, true);
    assert(student == true, 'student not updated');

    let student0 = dispatcher.update_student('Joseph', Accounts::student1(), 19, 35, true);
    assert(student0 == true, 'student not updated');
    let (name, account, age, xp, is_active) = dispatcher.get_student(Accounts::student1());

    assert(name == 'Joseph', 'name should match');
    assert(account == Accounts::student1(), 'account should match');
    assert(age == 19, 'age should match');
    assert(xp == 35, 'xp should match');
    assert(is_active == true, 'is_active should match');
}


#[test]
#[should_panic(expected: ('ZERO ADDRESS!',))]
fn test_not_update_zero_address() {
    let contract_address = deploy_contract("StudentRegistry");

    let dispatcher = IStudentRegistryDispatcher { contract_address };

    let student = dispatcher.add_student('Paul', Accounts::student1(), 18, 40, true);

    assert(student == true, 'Student not created');

    let student = dispatcher.update_student('Joseph', Accounts::zero(), 19, 35, true);
    assert(student == false, 'cannot update zero address');
}