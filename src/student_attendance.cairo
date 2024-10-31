use starknet::ContractAddress;

#[starknet::interface]
pub trait IStudentAttendance<T> {
    fn mark_attendance(
        ref self: T, _student_account: ContractAddress, _date: felt252, _present: bool
    ) -> bool;

    fn get_attendance(self: @T, student_account: ContractAddress, date: felt252) -> bool;
}

#[starknet::component]
pub mod StudentAttendanceComponent {
    use OwnableComponent::InternalTrait;
    use starknet::ContractAddress;
    use core::num::traits::Zero;
    use openzeppelin::access::ownable::{OwnableComponent, OwnableComponent::InternalImpl};

    use super::{IStudentAttendance};
    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use crate::errors::Errors;

    #[storage]
    struct Storage {
        admin_account: ContractAddress,
        attendance_map: Map::<ContractAddress, Map<felt252, bool>>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        AttendanceMarked: AttendanceMarked
    }

    #[derive(Drop, starknet::Event)]
    struct AttendanceMarked {
        marked_student: ContractAddress,
    }

    #[embeddable_as(StudentAttendance)]
    pub impl StudenAttendanceImpl<
        TContractState,
        +HasComponent<TContractState>,
        +Drop<TContractState>,
        impl Ownable: OwnableComponent::HasComponent<TContractState>
    > of IStudentAttendance<ComponentState<TContractState>> {
        fn mark_attendance(
            ref self: ComponentState<TContractState>,
            _student_account: ContractAddress,
            _date: felt252,
            _present: bool
        ) -> bool {
            assert(self.is_zero_address(_student_account), Errors::ZERO_ADDRESS);

            // assert only owner
            let ownable_comp = get_dep_component!(@self, Ownable);
            ownable_comp.assert_only_owner();

            self.attendance_map.entry(_student_account).entry(_date).write(_present);

            self.emit(AttendanceMarked { marked_student: _student_account });

            true
        }

        fn get_attendance(
            self: @ComponentState<TContractState>, student_account: ContractAddress, date: felt252
        ) -> bool {
            let attendance = self.attendance_map.entry(student_account).entry(date).read();
            return attendance;
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
