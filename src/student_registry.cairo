use starknet::ContractAddress;
use crate::student_struct::Student;

#[starknet::interface]
pub trait IStudentRegistry<T> {
    // state-change function to add new student
    fn add_student(
        ref self: T, _name: felt252, _account: ContractAddress, _age: u8, _xp: u16, _is_active: bool
    ) -> bool;

    // read-only function to get student
    fn get_student(self: @T, student_id: u64) -> (u64, felt252, ContractAddress, u8, u16, bool);
    // fn get_all_students(self: @T) -> Span<Student>;
    fn get_all_students(self: @T) -> Span<Student>;
    // state-change function to update student data
    fn update_student(
        ref self: T,
        _id: u64,
        _name: felt252,
        _account: ContractAddress,
        _age: u8,
        _xp: u16,
        _is_active: bool
    ) -> bool;
}


#[starknet::contract]
pub mod StudentRegistry {
    use starknet::{ContractAddress, get_caller_address};
    use super::{IStudentRegistry, Student};
    use core::num::traits::Zero;

    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, Vec, VecTrait, MutableVecTrait
    };
    use crate::errors::Errors;

    #[storage]
    struct Storage {
        admin: ContractAddress,
        students_vector: Vec<Student>
    }


    #[constructor]
    fn constructor(ref self: ContractState, _admin: ContractAddress) {
        // validation to check if admin account has valid address and not 0 address
        assert(self.is_zero_address(_admin) == false, Errors::ZERO_ADDRESS);
        self.admin.write(_admin);
    }

    #[abi(embed_v0)]
    impl StudentRegistryImpl of IStudentRegistry<ContractState> {
        // state-change function to add new student
        fn add_student(
            ref self: ContractState,
            _name: felt252,
            _account: ContractAddress,
            _age: u8,
            _xp: u16,
            _is_active: bool
        ) -> bool {
            // validation to check if student account is valid address and  not a 0 address
            assert(!self.is_zero_address(_account), Errors::ZERO_ADDRESS);
            // validate student age
            assert(_age > 0, 'age cannot be 0');

            // set student vector length as new student Id
            let _id = self.students_vector.len();
            let student = Student {
                id: _id, name: _name, account: _account, age: _age, xp: _xp, is_active: _is_active
            };

            // append student data to the students vector
            self.students_vector.append().write(student);

            true
        }

        // read-only function to get student
        fn get_student(
            self: @ContractState, student_id: u64
        ) -> (u64, felt252, ContractAddress, u8, u16, bool) {
            // validation to check if account is valid
            assert(student_id > 0, 'id cannot < 0');
            let student = self.students_vector.at(student_id).read();
            (student.id, student.name, student.account, student.age, student.xp, student.is_active)
        }

        fn get_all_students(self: @ContractState) -> Span<Student> {
            // empty array to store students
            let mut all_students: Array<Student> = array![];

            // loop through the students vector and append each student data to the students array
            for i in 0
                ..self
                    .students_vector
                    .len() {
                        // append each student details to the students array
                        all_students.append(self.students_vector.at(i).read());
                    };

            all_students.span()
        }

        fn update_student(
            ref self: ContractState,
            _id: u64,
            _name: felt252,
            _account: ContractAddress,
            _age: u8,
            _xp: u16,
            _is_active: bool
        ) -> bool {
            // validation to check if account is valid
            assert(!self.is_zero_address(_account), Errors::ZERO_ADDRESS);
            let mut student_pointer = self.students_vector.at(_id);
            let new_student = Student {
                id: _id, name: _name, account: _account, age: _age, xp: _xp, is_active: _is_active
            };

            // update student data
            student_pointer.write(new_student);

            true
        }
    }


    #[generate_trait]
    impl Private of PrivateTrait {
        fn only_owner(self: @ContractState) {
            // get function caller
            let caller: ContractAddress = get_caller_address();

            // get admin of StudentRegistry contract
            let current_admin: ContractAddress = self.admin.read();

            // assertion logic
            assert(caller == current_admin, Errors::NOT_ADMIN);
        }

        fn is_zero_address(self: @ContractState, account: ContractAddress) -> bool {
            if account.is_zero() {
                return true;
            }
            return false;
        }
    }
}

