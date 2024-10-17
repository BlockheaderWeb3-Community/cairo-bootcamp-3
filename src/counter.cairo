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
// 0x0128fe1941a77f17abba960d33e491036cb7c607b23cbbc49abecda8e80fc3c1 --- class hash

/// 0x66043c0e51ad08ee2d9861a66c15de5b78ca483f5b211b5437a4c4c9fd4e3eb -- cohort_dev address
//__________________________________TODAY_______________________
// 0x20345aad7d3082f69cfda059f8e06d031a912107478fbc68df5dad4298bc8f1 - counter ca


