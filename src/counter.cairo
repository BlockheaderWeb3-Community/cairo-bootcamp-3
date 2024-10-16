#[starknet::interface]
pub trait ICounter<T> {
    fn get_count(self: @T) -> u32;
    fn set_count(ref self: T, amount: u32);
}

#[starknet::contract]
mod Counter {
    use cairo_bootcamp_3::{errors, addition};
    #[storage]
    struct Storage {
        count: u32,
    }

    #[abi(embed_v0)]
    impl ICounterImpl of super::ICounter<ContractState> {
        // increase count by the value passed in as argument
        fn set_count(ref self: ContractState, amount: u32) {
            assert(amount != 0, errors::Errors::ZERO_AMOUNT);
            let current_count: u32 = self.count.read();
            let result = addition::add(current_count, amount);
            self.count.write(result);
        }

        // get current count
        fn get_count(self: @ContractState) -> u32 {
            self.count.read()
        }
    }
}
// 0x0726aae552474f128529c982392e8490c496395c1a2d7879c029203ad12e97bb

//__________________________________TODAY_______________________ 
// 0x45f8e8b3d6ecf220d78fdc13a523ae8ecaa90581ee68baa958d8ba3181841e9 - counter ca