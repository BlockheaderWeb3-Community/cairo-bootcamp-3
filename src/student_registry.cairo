use starknet::ContractAddress;
use crate::student_struct::Student;
use crate::events::{Event, StudentAdded};

#[starknet::interface]
trait IStudentRegistry<T> {
    // state-change function to add new student
    fn add_student(
        ref self: T, _name: felt252, _account: ContractAddress, _age: u8, _xp: u16, _is_active: bool
    );

    // read-only function to get student
    fn get_student(self: @T, account: ContractAddress) -> (felt252, ContractAddress, u8, u16, bool);

    fn update_student(ref self: T, _name: felt252, _account: ContractAddress, _age: u8);
}


#[starknet::contract]
mod StudentRegistry {
    use starknet::{ContractAddress, get_caller_address};
    use super::{IStudentRegistry, Student};
    use core::num::traits::Zero;
    #[event]
    use crate::events::{Event, StudentAdded};

    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use crate::errors::Errors::{NOT_ADMIN, ZERO_ADDRESS, EMPTY_NAME, ADMIN_NOT_ALLOWED};

    #[storage]
    struct Storage {
        admin: ContractAddress,
        students_map: Map::<ContractAddress, Student>,
    }


    #[constructor]
    fn constructor(ref self: ContractState, _admin: ContractAddress) {
        // validation to check if admin account has valid address and not 0 address
        assert(self.is_zero_address(_admin) == false, ZERO_ADDRESS);
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
        ) {
            // validation to check if student account is valid address and  not a 0 address
            let admin = self.admin.read();
            assert(!self.is_zero_address(_account), ZERO_ADDRESS);
            assert(_account != admin, ADMIN_NOT_ALLOWED);
            assert(_name != '', EMPTY_NAME);
            assert(_age > 0, 'age cannot be 0');
            let student = Student {
                name: _name, account: _account, age: _age, xp: _xp, is_active: _is_active
            };
            self.students_map.entry(_account).write(student);
            //TODO: student is not surposed to input _is_active
        }

        // read-only function to get student
        fn get_student(
            self: @ContractState, account: ContractAddress
        ) -> (felt252, ContractAddress, u8, u16, bool) {
            // validation to check if account is valid
            assert(!self.is_zero_address(account), ZERO_ADDRESS);
            let student = self.students_map.entry(account).read();
            (student.name, student.account, student.age, student.xp, student.is_active)
        }
        
        fn update_student(
            ref self: ContractState,
            _name: felt252,
            _account: ContractAddress,
            _age: u8,
        )  {
            let admin = self.admin.read();
            assert(!self.is_zero_address(_account), ZERO_ADDRESS);
            

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
            assert(caller == current_admin, NOT_ADMIN);
        }

        fn is_zero_address(self: @ContractState, account: ContractAddress) -> bool {
            if account.is_zero() {
                return true;
            }
            return false;
        }
    }
}

