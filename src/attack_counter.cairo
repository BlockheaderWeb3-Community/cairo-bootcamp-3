// AttackCounter Contract
// Whereas a function is considered as a read-only function if its self is a snapshot of storage as
// depicted thus (self: @TContractState), it is not true that such a functin cannot modify state By
// leveraging syscalls like `call_contract_syscall`, such function can modify state In this
// contract, we showcase this possibility of using `call_contract_syscall` in our AttackCounter
// contract to modify the `count` state of our simple counter contract

#[starknet::interface]
pub trait IAttackCounter<TContractState> {
    // get count - retrieve the count from storage
    // a read-only function
    fn counter_count(self: @TContractState) -> u32;

    // set count
    fn attack_count(self: @TContractState, amount: u32);
}


#[starknet::contract]
pub mod AttackCounter {
    use super::IAttackCounter;
    use crate::counter::{ICounterDispatcher, ICounterDispatcherTrait};
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
        fn counter_count(self: @ContractState) -> u32 {
            let counter_addr = self.counter_address.read();
            ICounterDispatcher { contract_address: counter_addr }.get_count()
        }

        fn attack_count(self: @ContractState, amount: u32) {
            let counter_addr = self.counter_address.read();
            // let mut counter_current_count: u32 = self.counter_count();
            let selector = selector!("set_count");

            let mut args: Array<felt252> = array![];
            amount.serialize(ref args);
            call_contract_syscall(counter_addr, selector, args.span());
        }
    }
}
