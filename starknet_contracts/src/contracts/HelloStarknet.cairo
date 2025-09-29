/// Simple contract for managing balance.
#[starknet::contract]
pub mod HelloStarknet {
    
    use starknet_contracts::interfaces::IHelloStarknet::IHelloStarknet;
    // use starknet::storage::{StoragePointerReadAccess, StoragePathEntry, StoragePointerWriteAccess, Map };
    use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess, StoragePointerReadAccess, StoragePointerWriteAccess };
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        balance: felt252,
        balances: Map<ContractAddress, felt252>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        Balance : BalanceIncreased,
    }

    #[derive(Drop, starknet::Event)]
    pub struct BalanceIncreased {
        pub caller: ContractAddress,
        pub amount: felt252,
    }

    #[abi(embed_v0)]
    impl HelloStarknetImpl of IHelloStarknet<ContractState> {
        fn increase_balance(ref self: ContractState, amount: felt252) {
            assert(amount != 0, 'Amount cannot be 0');
            let caller = get_caller_address();

            let updated_amount = self.balance.read() + amount;
            self.balance.write(updated_amount);

            // let unique_balance = self.balances.entry(caller).read();

            let unique_balance = self.balances.read(caller);
            // self.balances.entry(caller).write(unique_balance + amount);
            self.balances.write(caller, unique_balance + amount);

            // self.balance.write(self.balance.read() + amount);

            self.emit(BalanceIncreased{caller, amount});
        }

        fn get_balance(self: @ContractState) -> felt252 {
            self.balance.read()
        }
    }
}