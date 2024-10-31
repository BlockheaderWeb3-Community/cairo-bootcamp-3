use starknet::{ContractAddress};
#[starknet::interface]
pub trait IAttackCounter<TContractState> {
    // get count - retrieve the count from storage
    // a read-only function
    fn counter_count(self: @TContractState);

    // set count
    fn attack_count(self: @TContractState,amount:u32);
    // set count by one
    fn attack_count_by_one(self: @TContractState);


    fn get_current_owner(self: @TContractState);


    // use attacker to add new owner
    fn attacker_add_new_owner(self: @TContractState, new_owner: ContractAddress);
}


#[starknet::contract]
pub mod AttackCounter {
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
    impl CounterImpl of super::IAttackCounter<ContractState> {
        fn counter_count(self: @ContractState) {
            let counter_addr = self.counter_address.read();
            ICounterV2Dispatcher { contract_address: counter_addr }.get_count();
        }

        fn attack_count(self: @ContractState,amount:u32) {
            let counter_addr = self.counter_address.read();
            let selector = selector!("set_count");
            let mut args: Array<felt252> = array![];
            let value = amount;
            value.serialize(ref args);
            call_contract_syscall(counter_addr, selector, args.span());
        }

        fn attack_count_by_one(self: @ContractState) {
            let counter_addr = self.counter_address.read();
            let selector = selector!("increase_count_by_one");
            let args: Array<felt252> = array![];
            call_contract_syscall(counter_addr, selector, args.span());
        }

        fn get_current_owner(self: @ContractState) {
            let counter_addr = self.counter_address.read();
            ICounterV2Dispatcher { contract_address: counter_addr }.get_current_owner();
        }

        fn attacker_add_new_owner(self: @ContractState, new_owner: ContractAddress) {
            let counter_addr = self.counter_address.read();
            let selector = selector!("add_new_owner");
            let mut args: Array<felt252> = array![];
            new_owner.serialize(ref args);
            call_contract_syscall(counter_addr, selector, args.span());
        }
    }
}
//

