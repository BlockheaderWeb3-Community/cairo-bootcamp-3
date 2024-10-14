use starknet::ContractAddress;
#[starknet::interface]
pub trait ICounter<T> {
    fn increase_count(ref self: T, amount: u32);
    fn get_count(self: @T) -> u32;
}

#[starknet::interface]
pub trait IOwnable<T> {
    fn add_owner(ref self: T, new_owner: ContractAddress);
    fn get_owner(self: @T) -> ContractAddress;
}

#[starknet::contract]
mod OwnableCounter {
    // import ICounter trait
    use super::{ICounter, IOwnable};
    use starknet::{ContractAddress};
    use crate::addition;

    use core::num::traits::zero::Zero;

    #[storage]
    struct Storage {
        count: u32,
        owner: ContractAddress
    }

    #[constructor]
    fn constructor(ref self: ContractState, new_owner: ContractAddress) {
        assert(new_owner.is_non_zero(), '');
        self.owner.write(new_owner)
    }

    #[abi(embed_v0)]
    impl CounterImpl of ICounter<ContractState> {
        fn increase_count(ref self: ContractState, amount: u32) {
            assert(amount != 0, 'Amount cannot be 0');
            let current_count: u32 = self.get_count();
            let sum: u32 = addition::add(current_count, amount);
            self.count.write(sum);
        }

        fn get_count(self: @ContractState) -> u32 {
            self.count.read()
        }
    }

    #[abi(embed_v0)]
    impl OwableImpl of IOwnable<ContractState> {
        fn add_owner(ref self: ContractState, new_owner: ContractAddress) {
            self.owner.write(new_owner)
        }

        fn get_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }
    }
}
// 0x041a78e741e5af2fec34b695679bc6891742439f7afb8484ecd7766661ad02bf - UDC


