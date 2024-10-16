use starknet::ContractAddress;
use crate::student_struct::Student;

#[starknet::interface]
pub trait IStudentRegistry<T> {
    // state-change function to add new student
    fn add_student(
        ref self: T, _name: felt252, _account: ContractAddress, _age: u8, _xp: u16, _is_active: bool
    ) -> bool;

    // read-only function to get student
    fn get_student(self: @T, account: ContractAddress) -> (felt252, ContractAddress, u8, u16, bool);
    // fn get_all_students(self: @T) -> Span<Student>;
    fn get_all_students(self: @T) -> Span<Student>;
    fn update_student(
        ref self: T, _name: felt252, _account: ContractAddress, _age: u8, _xp: u16, _is_active: bool
    ) -> bool;
}


#[starknet::contract]
pub mod StudentRegistry {
    use starknet::{ContractAddress, get_caller_address};
    use super::{IStudentRegistry, Student};
    use core::num::traits::Zero;

    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, Vec, VecTrait, MutableVecTrait,
        StoragePathEntry, Map
    };
    use crate::errors::Errors;

    #[storage]
    struct Storage {
        admin: ContractAddress,
        students_map: Map::<ContractAddress, Student>,
        students_vector: Vec<ContractAddress>,
        students_index: Map::<u64, ContractAddress>,
        total_no_of_students: u64
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
            assert(_age > 0, 'age cannot be 0');
            let student = Student {
                name: _name, account: _account, age: _age, xp: _xp, is_active: _is_active
            };

            // add new student to storage
            self.students_map.entry(_account).write(student);

            // keep track of student's account address
            self.students_vector.append().write(_account);

            // keep track of the student index
            self.students_index.entry(self.total_no_of_students.read()).write(_account);

            // increase student's count
            self.total_no_of_students.write(self.total_no_of_students.read() + 1);

            true
        }

        // read-only function to get student
        fn get_student(
            self: @ContractState, account: ContractAddress
        ) -> (felt252, ContractAddress, u8, u16, bool) {
            // validation to check if account is valid
            assert(!self.is_zero_address(account), Errors::ZERO_ADDRESS);
            let student = self.students_map.entry(account).read();
            (student.name, student.account, student.age, student.xp, student.is_active)
        }

        fn get_all_students(self: @ContractState) -> Span<Student> {
            // empty array to store students
            let mut all_students: Array<Student> = array![];

            // loop through the students vector containing the accounts of the student and use the
            // account to get and return the student details
            for i in 0
                ..self
                    .students_vector
                    .len() {
                        // append each student details to the students array
                        all_students
                            .append(
                                self.students_map.entry(self.students_vector.at(i).read()).read()
                            );
                    };

            all_students.span()
        }

        fn update_student(
            ref self: ContractState,
            _name: felt252,
            _account: ContractAddress,
            _age: u8,
            _xp: u16,
            _is_active: bool
        ) -> bool {
            // validation to check if account is valid
            assert(!self.is_zero_address(_account), Errors::ZERO_ADDRESS);
            let old_student: Student = self.students_map.entry(_account).read();
            // validation to check if student exist
            assert(old_student.age > 0, Errors::STUDENT_NOT_REGISTERED);
            let new_student = Student {
                name: _name, account: _account, age: _age, xp: _xp, is_active: _is_active
            };
            // update student info
            self.students_map.entry(_account).write(new_student);

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

