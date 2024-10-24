// trait - blueprint which specifies the function signatures we intend to build
// module - which houses:
//  - storage Struct
//  - impl block

use starknet::ContractAddress;
#[starknet::interface]
pub trait ICounterV2<TContractState> {
    // get count - retrieve the count from storage
    // a read-only function
    fn get_count(self: @TContractState) -> u32;

    // set count
    fn set_count(ref self: TContractState, amount: u32);

    // add owner
    fn add_new_owner(ref self: TContractState, new_owner: ContractAddress);

    // increase count by one
    fn increase_count_by_one(ref self: TContractState);


    fn get_current_owner(self: @TContractState) -> ContractAddress;
}


#[starknet::contract]
pub mod CounterV2 {
    use core::num::traits::Zero;
    use super::ICounterV2;
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        count: u32,
        owner: ContractAddress
    }

    // relevant events added
    #[event]
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        CounterSetCount: CounterSetCount,
        CounterAddNewOwner: CounterAddNewOwner,
        CounterIncreaseCountByOne: CounterIncreaseCountByOne
    }


    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct CounterSetCount {
        pub amount: u32
    }

    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct CounterAddNewOwner {
        #[key]
        pub new_owner: ContractAddress
    }


    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct CounterIncreaseCountByOne {
        pub total_amount: u32
    }

    #[constructor]
    fn constructor(ref self: ContractState, _owner: ContractAddress) {
        // validation to check if owner is valid address and 0 address
        assert(self.is_zero_address(_owner) == false, '0 address');
        self.owner.write(_owner);
    }

    #[abi(embed_v0)]
    impl CounterV2Impl of super::ICounterV2<ContractState> {
        fn get_count(self: @ContractState) -> u32 {
            self.count.read()
        }
        // 0x10b2d12c2221b750cd11ee2a3bc23d950f68daad9f4db9fce89fed1bb7b840d
        //

        fn set_count(ref self: ContractState, amount: u32) {
            assert(amount != 0, 'amount cannot be zero');
            let current_count: u32 = self.get_count();
            self.count.write(current_count + amount);

            self.emit(Event::CounterSetCount(CounterSetCount { amount }));
        }

        fn add_new_owner(ref self: ContractState, new_owner: ContractAddress) {
            // validation to ensure only owner can invoke this function
            // self.only_owner(); // commentted out this line to execute sys calls

            // validation to check if new owner is 0 address
            assert(self.is_zero_address(new_owner) == false, '0 address');
            // assert that new owner is not the current owner
            assert(self.get_current_owner() != new_owner, 'same owner');

            self.owner.write(new_owner);

            self.emit(Event::CounterAddNewOwner(CounterAddNewOwner { new_owner: new_owner }));
        }


        // increase count by one
        fn increase_count_by_one(ref self: ContractState) {
            let current_count = self.get_count();
            let total_amount: u32 = current_count + 1;
            self.count.write(total_amount);

            self.emit(Event::CounterIncreaseCountByOne(CounterIncreaseCountByOne { total_amount }));
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
            let caller: ContractAddress = get_caller_address();

            // get owner of CounterV2 contract
            let current_owner: ContractAddress = self.owner.read();

            // assertion logic
            assert(caller == current_owner, 'caller not owner');
        }


        fn is_zero_address(self: @ContractState, account: ContractAddress) -> bool {
            if account.is_zero() {
                return true;
            }
            return false;
        }
    }
}
// 0x65f0904d094297f08575291f2da8600b60c12e764b63fdfef8c1044a3eaa34b
// 0x6f2f6eb269f9741d5bb9cb633bfb632a0d71e0622b195ef4c4e66e8f1fee9fe
// 0x000000000000000000000000000000000000000000000000000000000000000


