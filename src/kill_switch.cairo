#[starknet::interface]
pub trait IKillSwitch<TContractState> {
    fn toggle(ref self: TContractState);
    fn get_state(self: @TContractState) -> bool;
}

#[starknet::contract]
mod KillSwitch {
    #[storage]
    struct Storage {
        is_on: bool,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        KillSwitchToggled: KillSwitchToggled,
    }

    #[derive(Drop, starknet::Event)]
    struct KillSwitchToggled {
        new_state: bool,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.is_on.write(true);
    }

    #[abi(embed_v0)]
    impl KillSwitchImpl of super::IKillSwitch<ContractState> {
        fn toggle(ref self: ContractState) {
            let current_state = self.is_on.read();
            let new_state = !current_state;
            self.is_on.write(new_state);
            self.emit(KillSwitchToggled { new_state });
        }

        fn get_state(self: @ContractState) -> bool {
            self.is_on.read()
        }
    }
}
/// 0x3e138694770f2a1586c403ff5c8283258346565e274a01989984fe023157c7d  class hash
///  0x58d629f09fc3a79331ed1689c1c6ab9c2f025c4f0caff879b1d5acf0eab44d9 KA


