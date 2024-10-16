use starknet::ContractAddress;

#[starknet::interface]
trait ICounterV3<TContractState> {
    // get count - retrieve the count from storage
    // a read-only function
    fn get_count(self: @TContractState) -> u32;
    // set count
    fn set_count(ref self: TContractState, amount: u32);
    // add owner
    fn add_new_owner(ref self: TContractState, new_owner: ContractAddress);
    // increase count by one
    fn increase_count_by_one(ref self: TContractState);
    // decrease count by one
    fn decrease_count_by_one(ref self: TContractState);
    // get current owner
    fn get_current_owner(self: @TContractState) -> ContractAddress;
}

#[starknet::contract]
mod CounterV3 {
    use core::num::traits::Zero;
    use super::ICounterV3;
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        count: u32,
        owner: ContractAddress
    }

    #[constructor]
    fn constructor(ref self: ContractState, _owner: ContractAddress) {
        self.owner.write(_owner)
    }

    #[abi(embed_v0)]
    impl CounterV3Impl of super::ICounterV3<ContractState> {
        fn get_count(self: @ContractState) -> u32 {
            self.count.read()
        }
        fn set_count(ref self: ContractState, amount: u32) {
            // can only be executed by the contract deployer (state-changing)
            self.only_owner();
            self.count.write(self.get_count() + amount)
        }
        fn add_new_owner(ref self: ContractState, new_owner: ContractAddress) {
            self.only_owner();

            assert(!self.is_zero_address(new_owner), '0 address');

            assert(self.get_current_owner() != new_owner, 'same owner');

            self.owner.write(new_owner);
        }

        // increase count by one
        fn increase_count_by_one(ref self: ContractState) {
            // can only be executed by the contract deployer (state-changing)
            assert(self.get_count() < 50, 'count too high');
            self.count.write(self.get_count() + 1)
        }

        // decrease count by one
        fn decrease_count_by_one(ref self: ContractState) {
            // can only be executed by the contract deployer (state-changing)
            self.count.write(self.get_count() - 1)
        }

        // util function to get current owner
        fn get_current_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn only_owner(self: @ContractState) {
            // get function caller
            let caller = get_caller_address();

            // get owner of CounterV2 contract
            let current_owner: ContractAddress = self.owner.read();

            // assertion logic
            assert(current_owner == caller, 'caller is not owner');
        }

        fn is_zero_address(self: @ContractState, account: ContractAddress) -> bool {
            if account.is_zero() {
                return true;
            }
            return false;
        }
    }
}

// 0xfae52025fdff77f2ab38dd5eaa9a23540fbf7131e896d8b5699e2642944e33
// 0x1fa34f58aa881cb66e01a2156adca02e948a44351072d20d7d381783447bc2e