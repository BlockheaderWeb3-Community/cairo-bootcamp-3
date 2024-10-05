#[starknet::interface]
trait ICounterV3<TContractState> {
    fn get_count(self: @TContractState) -> u32;
    fn set_count(ref self: TContractState, amount: u32);

    fn increment(ref self: TContractState);
    fn decrement(ref self: TContractState);
}


#[starknet::contract]
mod CounterV3 {
    use starknet::storage::StoragePointerWriteAccess;
    use starknet::storage::StoragePointerReadAccess;
    use starknet::get_caller_address;
    use starknet::{ContractAddress, contract_address_const};

    #[storage]
    struct Storage {
        owner: ContractAddress,
        count: u32
    }

    #[constructor]
    fn constructor(ref self: ContractState, _owner: ContractAddress) {
        self.owner.write(_owner);
    }


    fn set_new_owner(ref self: ContractState, new_owner: ContractAddress) {
        self.only_owner();

        self.not_address_zero(new_owner);

        self.owner.write(new_owner);
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn only_owner(ref self: ContractState) {
            if get_caller_address() != self.owner.read() {
                return;
            }
        }

        fn not_address_zero(ref self: ContractState, address: ContractAddress) {
            let zero_address: ContractAddress = contract_address_const();

            if (address == zero_address) {
                return;
            }
        }
    }

    #[abi(embed_v0)]
    impl CounterV3Impl of super::ICounterV3<ContractState> {
        fn get_count(self: @ContractState) -> u32 {
            self.count.read()
        }

        // state functions

        fn set_count(ref self: ContractState, amount: u32) {
            self.only_owner();

            assert(amount <= 50, 'exceeds 50');

            if amount > 50 {
                return;
            }

            if amount > 0 {
                self.count.write(amount);
            }
        }

        fn increment(ref self: ContractState) {
            self.only_owner();
            if self.count.read() == 50 {
                return;
            }

            self.count.write(self.count.read() + 1);
        }

        fn decrement(ref self: ContractState) {
            self.only_owner();
            if self.count.read() == 0 {
                return;
            }

            self.count.write(self.count.read() - 1);
        }
    }
}

