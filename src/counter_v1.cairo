// trait - blueprint which specifies the function signatures we intend to build
// module - which houses:
//  - storage Struct
//  - impl block

#[starknet::interface]
pub trait ICounter<TContractState> {
    // get count - retrieve the count from storage
    // a read-only function
    fn get_count(self: @TContractState) -> u32;

    // set count
    fn set_count(ref self: TContractState, amount: u32);
}


#[starknet::contract]
pub mod Counter {
    #[storage]
    struct Storage {
        count: u32,
    }

    #[abi(embed_v0)]
    impl CounterImpl of super::ICounter<ContractState> {
        fn get_count(self: @ContractState) -> u32 {
            self.count.read()
        }

        fn set_count(ref self: ContractState, amount: u32) {
            let current_count: u32 = self.get_count();
            self.count.write(current_count + amount);
        }
    }
}
