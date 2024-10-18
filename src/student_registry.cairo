use starknet::ContractAddress;
use cairo_bootcamp_3::student_struct::Student;

#[starknet::interface]
pub trait IStudentRegistry<T> {
    // state-change function to add new student
    fn add_student(
        ref self: T, _name: felt252, _account: ContractAddress, _age: u8, _xp: u16, _is_active: bool,id:u64,
    ) -> bool;

    // read-only function to get student
    fn get_student(self: @T, account: ContractAddress) -> (felt252, ContractAddress, u8, u16, bool);
    // fn get_all_students(self: @T) -> Span<Student>;
    fn update_student(
        ref self: T, _name: felt252, _account: ContractAddress, _age: u8, _xp: u16, _is_active: bool,_id:u64,
    ) -> bool;
    fn delete_student(ref self: T, _account: ContractAddress) -> bool;
}


#[starknet::contract]
pub mod StudentRegistry {
    use starknet::{ContractAddress, get_caller_address};
    use super::{IStudentRegistry, Student};
    use core::num::traits::Zero;

    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use cairo_bootcamp_3::errors::Errors;
    use cairo_bootcamp_3::accounts::Accounts;

    #[storage]
    struct Storage {
        admin: ContractAddress,
        students_map: Map::<ContractAddress, Student>,
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
            _is_active: bool,
            id: u64,
        ) -> bool {
            // validation to check if student account is valid address and  not a 0 address
            assert(!self.is_zero_address(_account), Errors::ZERO_ADDRESS);
            assert(_age > 0, 'age cannot be 0');
            let student = Student {id,
                name: _name, account: _account, age: _age, xp: _xp, is_active: _is_active
            };
            self.students_map.entry(_account).write(student);

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

        fn update_student(
            ref self: ContractState,
            _name: felt252,
            _account: ContractAddress,
            _age: u8,
            _xp: u16,
            _is_active: bool,
            _id: u64,
        ) -> bool {
            // validation to check if account is valid
            assert(!self.is_zero_address(_account), Errors::ZERO_ADDRESS);
            let old_student: Student = self.students_map.entry(_account).read();
            // validation to check if student exist
            assert(old_student.age > 0, Errors::STUDENT_NOT_REGISTERED);
            let new_student = Student {id:_id,
                name: _name, account: _account, age: _age, xp: _xp, is_active: _is_active
            };
            // update student info
            self.students_map.entry(_account).write(new_student);

            true
        }

        fn delete_student(ref self: ContractState, _account: ContractAddress) -> bool {
            // validation to check if account is valid
            assert(!self.is_zero_address(_account), Errors::ZERO_ADDRESS);
            let old_student: Student = self.students_map.entry(_account).read();
            // validation to check if student exist
            assert(old_student.age > 0, Errors::STUDENT_NOT_REGISTERED);
        let new_student = Student {id: 0,
                name: 0, account: Accounts::zero(), age: 0, xp: 0, is_active: false
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

