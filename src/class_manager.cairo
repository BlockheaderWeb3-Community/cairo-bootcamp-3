#[starknet::interface]
pub trait IClassManager<TContractstate> {
    fn name(self: @TContractstate) -> felt252;
    fn change_name(ref self: TContractstate, new_name: felt252);
}

#[starknet::contract]
pub mod ClassManager {
    use core::starknet::ContractAddress;
    use super::IClassManager;
    use crate::student_registry::StudentRegistryComponent;
    use openzeppelin::access::ownable::OwnableComponent;

    component!(
        path: StudentRegistryComponent, storage: studentRegistry, event: StudentRegistryEvent
    );
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    impl OwnableMixinImpl = OwnableComponent::OwnableMixinImpl<ContractState>;
    impl InternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[abi(embed_v0)]
    impl studentRegistryImpl =
        StudentRegistryComponent::StudentRegistry<ContractState>;
    impl studentRegisterPrivateImpl = StudentRegistryComponent::Private<ContractState>;

    #[storage]
    struct Storage {
        name: felt252,
        #[substorage(v0)]
        studentRegistry: StudentRegistryComponent::Storage,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        NameChanged: NameChanged,
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
        self.studentRegistry.initializer(_admin);
    }

    #[abi(embed_v0)]
    impl ClassManagerImpl of IClassManager<ContractState> {
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
