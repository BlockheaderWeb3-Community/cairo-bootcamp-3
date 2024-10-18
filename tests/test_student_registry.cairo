// Write test for the StudentRegistry contract here
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
use starknet::{ContractAddress};
use cairo_bootcamp_3::student_registry::{IStudentRegistryDispatcher, IStudentRegistryDispatcherTrait};
use cairo_bootcamp_3::accounts::Accounts;


fn deploy(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let constructor_arg = array![Accounts::admin().into()];
    let (contract_address, _) = contract.deploy(@constructor_arg).unwrap();
    contract_address
}

// invalid age 0 can't add to the student list
#[test]
#[should_panic(expected: 'age cannot be 0')]
fn add_new_student_with_age_less_than_one(){
    let contract_address = deploy("StudentRegistry");
    let contract_dispatcher = IStudentRegistryDispatcher {contract_address};
    contract_dispatcher.add_student('yunus',Accounts::account1(),0,20,true,88);
}

// valid student with correct data
#[test]
fn add_new_student_correct_data(){
    let contract_address = deploy("StudentRegistry");
    let contract_dispatcher = IStudentRegistryDispatcher {contract_address};
    contract_dispatcher.add_student('yunus',Accounts::account1(),4,20,true,88);
}


// zero address can't add to the student list
#[test]
#[should_panic(expected: 'ZERO ADDRESS!')]
fn add_new_student_with_zero_address(){
    let contract_address = deploy("StudentRegistry");
    let contract_dispatcher = IStudentRegistryDispatcher {contract_address};
    contract_dispatcher.add_student('yunus',Accounts::zero(),5,20,true,88);
}

// a valid address can be get the student list
#[test]
fn get_student_with_valid_address(){
    let contract_address = deploy("StudentRegistry");
    let contract_dispatcher = IStudentRegistryDispatcher {contract_address};
    contract_dispatcher.get_student(Accounts::account1());
}


//zero address can't get the student list
#[test]
#[should_panic(expected: 'ZERO ADDRESS!')]
fn get_student_with_zero_address(){
    let contract_address = deploy("StudentRegistry");
    let contract_dispatcher = IStudentRegistryDispatcher {contract_address};
    contract_dispatcher.get_student(Accounts::zero());
}

//update student with valid address
// and student age > 0
#[test]
#[should_panic(expected: 'STUDENT NOT REGISTERED!')]
fn update_student_with_valid_address(){
    let contract_address = deploy("StudentRegistry");
    let contract_dispatcher = IStudentRegistryDispatcher {contract_address};
    contract_dispatcher.update_student('yunus',Accounts::account1(),5,20,true,88);
}

#[test]
#[should_panic(expected: 'ZERO ADDRESS!')]
fn update_student_with_invalid_address(){
    let contract_address = deploy("StudentRegistry");
    let contract_dispatcher = IStudentRegistryDispatcher {contract_address};
    contract_dispatcher.update_student('yunus',Accounts::zero(),70,20,true,88);
}
//update student with zero age not valid
#[test]
#[should_panic(expected: 'STUDENT NOT REGISTERED!')]
fn update_student_age_with_zero(){
    let contract_address = deploy("StudentRegistry");
    let contract_dispatcher = IStudentRegistryDispatcher {contract_address};
    contract_dispatcher.update_student('yunus',Accounts::account1(),0,20,true,88);
}

#[test]
#[should_panic(expected: 'STUDENT NOT REGISTERED!')]
fn delete_student_with_valid_address(){
    let contract_address = deploy("StudentRegistry");
    let contract_dispatcher = IStudentRegistryDispatcher {contract_address};
    contract_dispatcher.delete_student(Accounts::account1());
}


#[test]
#[should_panic(expected: 'ZERO ADDRESS!')]
fn delete_student_with_invalid_address(){
    let contract_address = deploy("StudentRegistry");
    let contract_dispatcher = IStudentRegistryDispatcher {contract_address};
    contract_dispatcher.delete_student(Accounts::zero());
}