#[starknet::contract]
pub mod Counter {
    // use starknet::ContractAddress;
    // use starknet::get_caller_address;
    use starknet_contracts::interfaces::ICounter::ICounter;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        count: u32,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        CountUpdated : CountUpdated,
    }

    #[derive(Drop, starknet::Event)]
    struct CountUpdated {
        old_value: u32,
        new_value: u32,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.count.write(0);
    }

    #[abi(embed_v0)]
    impl CounterImpl of ICounter<ContractState> {
        fn get_count(self: @ContractState) -> u32 {
            self.count.read()
        }

        fn increment(ref self: ContractState) {
            let old_value = self.count.read();
            let new_value = old_value + 1;
            self.count.write(new_value);
            self.emit(CountUpdated { old_value, new_value });
        }

        fn decrement(ref self: ContractState) {
            let old_value = self.count.read();
            assert(old_value > 0, 'Count cannot be negative');
            let new_value = old_value - 1;
            self.count.write(new_value);
            self.emit(CountUpdated { old_value, new_value });
        }
    }
}