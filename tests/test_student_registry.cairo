// // Write test for the StudentRegistry contract here
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
use starknet::{ContractAddress};
use cairo_bootcamp_3::student_registry::{IStudentRegistryDispatcher, IStudentRegistryDispatcherTrait};

pub mod Accounts {
    use starknet::ContractAddress;
    use core::traits::TryInto;

    pub fn zero() -> ContractAddress {
        0x0000000000000000000000000000000000000000.try_into().unwrap()
    }

    pub fn admin() -> ContractAddress {
        'admin'.try_into().unwrap()
    }

    pub fn student1() -> ContractAddress {
        'student1'.try_into().unwrap()
    }

    pub fn student2() -> ContractAddress {
        'student2'.try_into().unwrap()
    }

}

fn deploy(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let constructor_args = array![Accounts::admin().into()];
    let (contract_address, _) = contract.deploy(@constructor_args).unwrap();
    contract_address
}

#[test]
fn test_can_add_student_correctly() {
    let contract_address = deploy("StudentRegistry");

    let contract_dispatcher = IStudentRegistryDispatcher { contract_address };

    let result0 =  contract_dispatcher.add_student(
        'Alice',
        Accounts::student1(),
        12,
        30,
        true,
    );
    assert(result0 == true, 'Student added successfully');
}

#[test]
#[should_panic(expected: ('ZERO ADDRESS!',))]
fn test_address_can_not_be_zerro() {
    let contract_address = deploy("StudentRegistry");

    let contract_dispatcher = IStudentRegistryDispatcher { contract_address };

    let result0 =  contract_dispatcher.add_student(
        'Alice',
        Accounts::zero(),
        12,
        30,
        true,
    );
    assert(result0 == false, 'Student address is zero');
}

#[test]
#[should_panic(expected: ('ADMIN CANNOT BE STUDENT',))]
fn test_cannot_add_admin() {
    let contract_address = deploy("StudentRegistry");

    let contract_dispatcher = IStudentRegistryDispatcher { contract_address };

    let result0 =  contract_dispatcher.add_student(
        'Alice',
        Accounts::admin(),
        12,
        30,
        true,
    );
    assert(result0 == false, 'Admin cannot be student');
}

#[test]
#[should_panic(expected: ('STUDENT ALREADY REGISTERED',))]
fn test_cannot_add_registered_student() {
    let contract_address = deploy("StudentRegistry");

    let contract_dispatcher = IStudentRegistryDispatcher { contract_address };

    let result0 =  contract_dispatcher.add_student(
        'Alice',
        Accounts::student1(),
        12,
        30,
        true,
    );
    assert(result0 == true, 'Student added successfully');

    let contract_address = deploy("StudentRegistry");

    let contract_dispatcher = IStudentRegistryDispatcher { contract_address };

    let result0 =  contract_dispatcher.add_student(
        'Alice',
        Accounts::student1(),
        12,
        30,
        true,
    );
    assert(result0 == false, 'STUDENT ALREADY REGISTERED');
}

#[test]
#[should_panic(expected: ('AGE CANNOT BE ZERO!',))]
fn test_age_can_not_be_zero() {
    let contract_address = deploy("StudentRegistry");

    let contract_dispatcher = IStudentRegistryDispatcher { contract_address };

    let result0 =  contract_dispatcher.add_student(
        'Alice',
        Accounts::student1(),
        0,
        30,
        true,
    );
    assert(result0 == false, 'Student added unsuccessfully');
}

#[test]
fn test_can_get_student() {
    let contract_address = deploy("StudentRegistry");

    let contract_dispatcher = IStudentRegistryDispatcher { contract_address };

    let result0 =  contract_dispatcher.add_student(
        'Alice',
        Accounts::student1(),
        12,
        30,
        true,
    );

    assert(result0 == true, 'Student added successfully');

    let (name, account, age, xp, is_active) = contract_dispatcher.get_student(Accounts::student1());
    
    assert(name == 'Alice', 'Name should match');
    assert(account == Accounts::student1(), 'Account should match');
    assert(age == 12, 'Age should match');
    assert(xp == 30, 'XP should match');
    assert(is_active == true, 'Is active should match');
}

#[test]
#[should_panic(expected: ('ZERO ADDRESS!',))]
fn test_can_not_get_address_zerro() {
    let contract_address = deploy("StudentRegistry");

    let contract_dispatcher = IStudentRegistryDispatcher { contract_address };

    contract_dispatcher.get_student(Accounts::zero());
}

#[test]
fn test_can_delete_student() {
    let contract_address = deploy("StudentRegistry");

    let contract_dispatcher = IStudentRegistryDispatcher { contract_address };

    let result0 =  contract_dispatcher.add_student(
            'Alice',
            Accounts::student1(),
            12,
            30,
            true,
    );
    assert(result0 == true, 'Student added successfully');

    let res = contract_dispatcher.delete_student(Accounts::student1());
    assert(res == true, 'Student deleted successfully');

    let (name, account, age, xp, is_active) = contract_dispatcher.get_student(Accounts::student1());

    // Check if the student is effectively deleted
    assert(name == '', 'Name should be empty');
    assert(account == Accounts::zero(), 'Account should be zero address');
    assert(age == 0, 'Age should be 0');
    assert(xp == 0, 'XP should be 0');
    assert(!is_active, 'Is active should be false');
}

#[test]
fn test_update_student() {

    let contract_address = deploy("StudentRegistry");

    let contract_dispatcher = IStudentRegistryDispatcher { contract_address };

    let account1 = Accounts::student1();

    let result0 =  contract_dispatcher.add_student(
            'Alice',
            account1,
            12,
            30,
            true,
    );
    assert(result0 == true, 'Student added successfully');

    let result1 = contract_dispatcher.update_student(
        'Bob',
        Accounts::student1(),
        14,
        25,
        false,
    );

    assert(result1 == true, 'Student updated successfully');

    let (name, account, age, xp, is_active) = contract_dispatcher.get_student(Accounts::student1());

    // Check if the student is effectively deleted
    assert(name == 'Bob', 'Name should be empty');
    assert(account == Accounts::student1(), 'Account should be zero address');
    assert(age == 14, 'Age should be 0');
    assert(xp == 25, 'XP should be 0');
    assert(is_active == false, 'Is active should be false');
}

#[test]
#[should_panic(expected: ('ZERO ADDRESS!',))]
fn test_can_not_update_address_zero() {
    let contract_address = deploy("StudentRegistry");

    let contract_dispatcher = IStudentRegistryDispatcher { contract_address };

    let account1 = Accounts::student1();

    let result0 =  contract_dispatcher.add_student(
            'Alice',
            account1,
            12,
            30,
            true,
    );
    assert(result0 == true, 'Student added successfully');

    let result1 = contract_dispatcher.update_student(
        'Bob',
        Accounts::zero(),
        14,
        25,
        true,
    );

    assert(result1 == false, 'Student updated unsuccessfully');
}



