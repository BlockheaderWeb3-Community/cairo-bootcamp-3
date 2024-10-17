#[starknet::interface]
pub trait ISwitchable<TContractState> {
    fn is_on(self: @TContractState) -> bool;
    fn switch(ref self: TContractState);
    fn off(ref self: TContractState);
}

#[starknet::contract]
pub mod Killswitch {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    pub struct Storage {
        switchable_value: bool,
    }

    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub struct SwitchEvent {}

    #[event]
    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        SwitchEvent: SwitchEvent,
    }

    #[abi(embed_v0)] // #[abi(embed_v0)]
    impl SwitchableImpl of super::ISwitchable<ContractState> {
        fn is_on(self: @ContractState) -> bool {
            self.switchable_value.read()
        }

        fn switch(ref self: ContractState) {
            self.switchable_value.write(!self.switchable_value.read());
            self.emit(Event::SwitchEvent(SwitchEvent {}));
        }

        fn off(ref self: ContractState) {
            self.switchable_value.write(false);
        }
    }
}
