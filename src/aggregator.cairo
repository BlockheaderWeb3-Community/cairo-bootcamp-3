use starknet::ContractAddress;

#[starknet::interface]
pub trait IAggregator<T> {
    // references Ownable methods
    fn get_ownable_owner(self: @T) -> ContractAddress;
    fn set_ownable_owner(ref self: T, new_owner: ContractAddress);

    // references Counter methods
    fn get_counter_count(self: @T) -> u32;
    fn set_counter_count(ref self: T, amount: u32);

    // references Counter functions
    fn get_aggr_owner(self: @T) -> ContractAddress;

    // killswitch
    fn toggle_kill_switch(ref self: T);
}

#[starknet::contract]
mod Aggregator {
    use cairo_bootcamp_3::{
        counter::{ICounterDispatcher, ICounterDispatcherTrait},
        ownable::{IOwnableDispatcher, IOwnableDispatcherTrait},
        kill_switch::{IKillSwitchDispatcher, IKillSwitchDispatcherTrait},
    };
    use super::{IAggregator};
    use starknet::{ContractAddress};


    #[storage]
    struct Storage {
        aggr_count: u32,
        aggr_owner: ContractAddress,
        ownable_addr: ContractAddress,
        counter_addr: ContractAddress,
        kill_switch_addr: ContractAddress,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        owner_addr: ContractAddress,
        ownable_addr: ContractAddress,
        counter_addr: ContractAddress,
        kill_switch_addr: ContractAddress
    ) {
        self.aggr_owner.write(owner_addr);
        self.ownable_addr.write(ownable_addr);
        self.counter_addr.write(counter_addr);
        self.kill_switch_addr.write(kill_switch_addr);
    }

    #[abi(embed_v0)]
    impl AggrImpl of IAggregator<ContractState> {
        // references Ownable contract methods
        // returns the address of the ownable contract
        fn get_ownable_owner(self: @ContractState,) -> ContractAddress {
            IOwnableDispatcher { contract_address: self.ownable_addr.read() }.get_owner()
        }

        fn set_ownable_owner(ref self: ContractState, new_owner: ContractAddress) {
            IOwnableDispatcher { contract_address: self.ownable_addr.read() }.set_owner(new_owner);
        }

        // references Counter contract methods
        fn get_counter_count(self: @ContractState) -> u32 {
            ICounterDispatcher { contract_address: self.counter_addr.read() }.get_count()
        }

        fn set_counter_count(ref self: ContractState, amount: u32) {
            let kill_switch = IKillSwitchDispatcher {
                contract_address: self.kill_switch_addr.read()
            };
            assert(kill_switch.get_state(), 'Kill switch is off');
            ICounterDispatcher { contract_address: self.counter_addr.read() }.set_count(amount);
        }

        fn get_aggr_owner(self: @ContractState) -> ContractAddress {
            self.aggr_owner.read()
        }

        fn toggle_kill_switch(ref self: ContractState) {
            let killswitch = IKillSwitchDispatcher {
                contract_address: self.kill_switch_addr.read()
            };
            killswitch.toggle();
        }
    }
}
// 0x166dc997ccec20d33b3792fa3a60a3c97c1781521ad5dfa02f270d08f4aef60 - ca

/// 0x16d60fafe0c39706e812ef96360ac03ee0feb8387efc9fddc70b5b1c6fd5a47 --- clash-hash


