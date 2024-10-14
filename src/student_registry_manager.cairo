#[starknet::interface]
pub trait IStudentRegistryManager<TContractstate> {
    fn name(self: @TContractstate) -> felt252;
    fn change_name(ref self: TContractstate, new_name: felt252);
}

#[starknet::contract]
pub mod StudentRegistryManager {
    use core::starknet::ContractAddress;
    use super::IStudentRegistryManager;
    use crate::student_registry::StudentRegistryComponent;
    use openzeppelin::access::ownable::OwnableComponent;

    // Declare component
    component!(
        path: StudentRegistryComponent, storage: studentRegistry, event: StudentRegistryEvent
    );
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableMixinImpl = OwnableComponent::OwnableMixinImpl<ContractState>;
    impl InternalImpl = OwnableComponent::InternalImpl<ContractState>;

    // instantiate component's generic implementation
    // #[abi(embed_v0)] adds this implementation to the contract's ABI
    #[abi(embed_v0)]
    impl studentRegistryImpl =
        StudentRegistryComponent::StudentRegistry<ContractState>;

    // instantiate component's private implementation
    impl studentRegisterPrivateImpl = StudentRegistryComponent::Private<ContractState>;

    #[storage]
    struct Storage {
        name: felt252,
        #[substorage(v0)] // component's storage variable must be annotated with this attribute
        studentRegistry: StudentRegistryComponent::Storage,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        NameChanged: NameChanged,
        #[flat] // component's event must be annotated with this attribute
        StudentRegistryEvent: StudentRegistryComponent::Event,
        #[flat]
        OwnableEvent: OwnableComponent::Event
    }

    #[derive(Drop, starknet::Event)]
    struct NameChanged {
        previous_name: felt252,
        new_name: felt252,
    }

    #[constructor]
    fn constructor(ref self: ContractState, _name: felt252, _admin: ContractAddress) {
        self.name.write(_name);

        // initialize component
        self.studentRegistry.initializer(_admin);
    }

    #[abi(embed_v0)]
    impl ClassManagerImpl of IStudentRegistryManager<ContractState> {
        fn name(self: @ContractState) -> felt252 {
            self.name.read()
        }

        fn change_name(ref self: ContractState, new_name: felt252) {
            let previous_name = self.name.read();
            self.name.write(new_name.clone());
            self.emit(NameChanged { previous_name, new_name })
        }
    }
}
