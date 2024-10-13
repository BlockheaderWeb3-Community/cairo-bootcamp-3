use crate::student_struct::Student;

#[starknet::interface]
pub trait IStudentRegistry<T> {
    // state-change function to add new student
    fn add_student(
        ref self: T,
        _fname: felt252,
        _lname: felt252,
        _phone_number: felt252,
        _age: u8,
        _is_active: bool
    ) -> bool;

    // read-only function to get student
    fn get_student(self: @T, index: u64) -> (felt252, felt252, felt252, u8, bool);
    // fn get_all_students(self: @T) -> Span<Student>;
    fn get_all_students(self: @T) -> Span<Student>;
    fn update_student(
        ref self: T, _index: u64, _fname: felt252, _lname: felt252, _phone_number: felt252, _age: u8
    ) -> bool;
    fn delete_student(ref self: T, _index: u64) -> bool;
}


#[starknet::contract]
pub mod StudentRegistry {
    use starknet::{ContractAddress, get_caller_address};
    use super::{IStudentRegistry, Student};
    use core::num::traits::Zero;

    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use crate::errors::Errors;

    #[storage]
    struct Storage {
        admin: ContractAddress,
        students_map: Map::<u64, Student>,
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
            _fname: felt252,
            _lname: felt252,
            _phone_number: felt252,
            _age: u8,
            _is_active: bool
        ) -> bool {
            assert(_age > 0, 'age cannot be 0');
            let student = Student {
                fname: _fname,
                lname: _lname,
                phone_number: _phone_number,
                age: _age,
                is_active: _is_active
            };

            // add new student to storage
            self.students_map.entry(self.total_no_of_students.read() + 1).write(student);

            // increase student's count
            self.total_no_of_students.write(self.total_no_of_students.read() + 1);

            true
        }

        // read-only function to get student
        fn get_student(self: @ContractState, index: u64) -> (felt252, felt252, felt252, u8, bool) {
            let student = self.students_map.entry(index).read();
            (student.fname, student.lname, student.phone_number, student.age, student.is_active)
        }

        fn get_all_students(self: @ContractState) -> Span<Student> {
            // empty array to store students
            let mut all_students: Array<Student> = array![];
            // total number of students
            let students_count = self.total_no_of_students.read();
            // counter
            let mut i = 1;

            // loop through all the students that have been created and return only the ones that
            // have not been deleted (only active students)
            while i < students_count + 1 {
                let current_student_data = self.students_map.entry(i).read();
                // return only active students
                if current_student_data.is_active {
                    all_students.append(current_student_data)
                };

                i += 1;
            };

            all_students.span()
        }

        fn update_student(
            ref self: ContractState,
            _index: u64,
            _fname: felt252,
            _lname: felt252,
            _phone_number: felt252,
            _age: u8,
        ) -> bool {
            let old_student: Student = self.students_map.entry(_index).read();
            // validation to check if student exist
            assert(old_student.age > 0, Errors::STUDENT_NOT_REGISTERED);
            let new_student = Student {
                fname: _fname,
                lname: _lname,
                phone_number: _phone_number,
                age: _age,
                is_active: old_student.is_active
            };
            // update student info
            self.students_map.entry(_index).write(new_student);

            true
        }

        // Note: Deleting a student only reset's the student data to the default values.
        // It does not remove the student account from the mapping, and therefore it does not reduce
        // the total number of students created
        fn delete_student(ref self: ContractState, _index: u64) -> bool {
            let student: Student = self.students_map.entry(_index).read();
            // validation to check if student exist
            assert(student.age > 0, Errors::STUDENT_NOT_REGISTERED);
            let deleted_student = Student {
                lname: 0, fname: 0, phone_number: 0, age: 0, is_active: false
            };
            // update student info
            self.students_map.entry(_index).write(deleted_student);

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

