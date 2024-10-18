use starknet::ContractAddress;

#[starknet::interface]
pub trait ICounter<T> {
    fn get_count(self: @T) -> u32;
    fn increase_count_by_one(ref self: T);
    fn decrease_count_by_one(ref self: T);
    fn set_count(ref self: T, amount: u32);
    fn get_owner(self: @T) -> ContractAddress;
}


#[starknet::contract]
pub mod counter3 {
    use starknet::{ContractAddress, get_caller_address};
    use core::num::traits::Zero;

    #[storage]
    struct Storage {
        count: u32,
        owner: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        assert(self.zero_account(owner) == false, 'zero account');
        self.owner.write(owner);
    }

    #[abi(embed_v0)]
    impl CounterImpl of super::ICounter<ContractState> {
        fn get_count(self: @ContractState) -> u32 {
            self.count.read()
        }
        fn set_count(ref self: ContractState, amount: u32) {
            assert(amount != 0, 'invalid amount');
            let total: u32 = self.count.read() + amount;
            assert(total <= 50, 'total amount > 50');
            self.get_caller();
            self.count.write(total);
        }
        fn increase_count_by_one(ref self: ContractState) {
            let total: u32 = self.count.read() + 1;
            assert(total <= 50, 'total amount > 50');
            self.get_caller();
            self.count.write(self.count.read() + 1);
        }
        fn decrease_count_by_one(ref self: ContractState) {
            self.get_caller();
            let total: u32 = self.count.read() - 1;
            assert(total != 0, 'u32_sub Overflow');
            self.count.write(self.count.read() - 1);
        }

        fn get_owner(self: @ContractState) -> ContractAddress {
            //self.get_caller();
            return self.owner.read();
        }
    }


    #[generate_trait]
    impl Private of PrivateTrait {
        fn get_caller(self: @ContractState) {
            let caller = get_caller_address();
            let owner = self.owner.read();
            assert(owner == caller, 'address not owner');
        }
        fn zero_account(self: @ContractState, account: ContractAddress) -> bool {
            if account.is_zero() {
                return true;
            }
            return false;
        }
    }
}
