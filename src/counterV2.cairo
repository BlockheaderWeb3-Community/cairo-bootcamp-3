#[starknet::interface]
trait ICounterV2<TContractState> {
    fn get_count(self: @TContractState) -> u32;
    fn set_count(ref self: TContractState, amount: u32);

    fn increment(ref self: TContractState);
    fn decrement(ref self: TContractState);
}


#[starknet::contract]
mod CounterV2 {
    use starknet::storage::StoragePointerWriteAccess;
    use starknet::storage::StoragePointerReadAccess;
    use starknet::get_caller_address;
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        owner: ContractAddress,
        count: u32
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.owner.write(get_caller_address());
        self.count.write(0);
    }

    #[abi(embed_v0)]
    impl CounterV2Impl of super::ICounterV2<ContractState> {
        fn get_count(self: @ContractState) -> u32 {
            self.count.read()
        }

        fn set_count(ref self: ContractState, amount: u32) {
            if amount != 0 {
                self.count.write(amount);
            }
        }

        fn increment(ref self: ContractState) {
            self.count.write(self.count.read() + 1);
        }

        fn decrement(ref self: ContractState) {
            if self.count.read() == 0 {
                return;
            }

            self.count.write(self.count.read() - 1);
        }
    }
}

