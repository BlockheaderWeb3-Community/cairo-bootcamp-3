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
    fn update_student(
        ref self: T, _name: felt252, _account: ContractAddress, _age: u8, _xp: u16, _is_active: bool
    ) -> bool;
    fn delete_student(ref self: T, _account: ContractAddress) -> bool;
}


#[starknet::component]
pub mod StudentRegistryComponent {
    use OwnableComponent::InternalTrait;
    use starknet::{ContractAddress};
    use super::{IStudentRegistry, Student};
    use core::num::traits::Zero;
    use openzeppelin::access::ownable::{OwnableComponent, OwnableComponent::InternalImpl};

    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use crate::errors::Errors;
    use cairo_bootcamp_3::accounts::Accounts;

    #[storage]
    struct Storage {
        admin: ContractAddress,
        students_map: Map::<ContractAddress, Student>,
        total_no_of_students: u64
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        StudentAdded: StudentAdded
    }

    #[derive(Drop, starknet::Event)]
    struct StudentAdded {
        new_student: Student,
    }

    #[embeddable_as(StudentRegistry)]
    impl StudentRegistryImpl<
        TContractState,
        +HasComponent<TContractState>,
        +Drop<TContractState>,
        impl Ownable: OwnableComponent::HasComponent<TContractState>
    > of IStudentRegistry<ComponentState<TContractState>> {
        // state-change function to add new student
        fn add_student(
            ref self: ComponentState<TContractState>,
            _name: felt252,
            _account: ContractAddress,
            _age: u8,
            _xp: u16,
            _is_active: bool
        ) -> bool {
            // assert only owner
            let ownable_comp = get_dep_component!(@self, Ownable);
            ownable_comp.assert_only_owner();

            // validation to check if student account is valid address and  not a 0 address
            assert(!self.is_zero_address(_account), Errors::ZERO_ADDRESS);
            assert(_age > 0, 'age cannot be 0');
            let student = Student {
                name: _name, account: _account, age: _age, xp: _xp, is_active: _is_active
            };
            self.students_map.entry(_account).write(student.clone());

            self.emit(StudentAdded { new_student: student.clone() });

            true
        }

        // read-only function to get student
        fn get_student(
            self: @ComponentState<TContractState>, account: ContractAddress
        ) -> (felt252, ContractAddress, u8, u16, bool) {
            // validation to check if account is valid
            assert(!self.is_zero_address(account), Errors::ZERO_ADDRESS);
            let student = self.students_map.entry(account).read();
            (student.name, student.account, student.age, student.xp, student.is_active)
        }

        fn update_student(
            ref self: ComponentState<TContractState>,
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

        fn delete_student(
            ref self: ComponentState<TContractState>, _account: ContractAddress
        ) -> bool {
            // validation to check if account is valid
            assert(!self.is_zero_address(_account), Errors::ZERO_ADDRESS);
            let old_student: Student = self.students_map.entry(_account).read();
            // validation to check if student exist
            assert(old_student.age > 0, Errors::STUDENT_NOT_REGISTERED);
            let new_student = Student {
                name: 0, account: Accounts::zero(), age: 0, xp: 0, is_active: false
            };
            // update student info
            self.students_map.entry(_account).write(new_student);
            true
        }
    }


    #[generate_trait]
    pub impl Private<
        TContractState,
        +HasComponent<TContractState>,
        +Drop<TContractState>,
        impl Ownable: OwnableComponent::HasComponent<TContractState>
    > of PrivateTrait<TContractState> {
        fn initializer(ref self: ComponentState<TContractState>, _admin: ContractAddress) {
            // validation to check if admin account has valid address and not 0 address
            assert(self.is_zero_address(_admin) == false, Errors::ZERO_ADDRESS);
            let mut ownable_comp = get_dep_component_mut!(ref self, Ownable);
            ownable_comp.initializer(_admin);
        }

        fn is_zero_address(
            self: @ComponentState<TContractState>, account: ContractAddress
        ) -> bool {
            if account.is_zero() {
                return true;
            }
            return false;
        }
    }
}

