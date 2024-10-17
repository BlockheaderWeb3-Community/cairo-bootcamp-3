#[starknet::interface]
pub trait ISwitchable<TContractState> {
    fn is_on(self: @TContractState) -> bool;
    fn switch(ref self: TContractState);
    fn off(ref self: TContractState);
}

#[starknet::contract]
pub mod Killswitch {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    pub struct Storage {
        switchable_value: bool,
    }

    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub struct SwitchEvent {}

    #[event]
    #[derive(Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        SwitchEvent: SwitchEvent,
    }

    #[abi(embed_v0)] // #[abi(embed_v0)]
    impl SwitchableImpl of super::ISwitchable<ContractState> {
        fn is_on(self: @ContractState) -> bool {
            self.switchable_value.read()
        }

        fn switch(ref self: ContractState) {
            self.switchable_value.write(!self.switchable_value.read());
            self.emit(Event::SwitchEvent(SwitchEvent {}));
        }

        fn off(ref self: ContractState) {
            self.switchable_value.write(false);
        }
    }
}

// kill switch
// 0x511109cfccaac33625817403733ac1d9cfa34f474feaa45d799f546f965a02 class hash 
// 0xf9e86eaa791bc192d50c892ee1c4a728b09849e5326c30a9de40854533c68b contract address

// counter
// 0x0128fe1941a77f17abba960d33e491036cb7c607b23cbbc49abecda8e80fc3c1 class hash
// 0x6c203b94329cb22aa7ad3deab2c2e16db846ee2b21d000e377ccd6218d18507 contract address

// Ownable 
// 0x00dedef0be763547e8e505d12fac321d0de4e9bd51635ac5fa00ae61d12e463e class hash
// 0x3733d53754c25529bfdfde8b3ddd0c777c0bb1837925eb9c1666040a956a4a8 contract address

// Aggregator
// 0xf07828bab2c6285fe8d614ff188feaeeab5cdcd3738f3c08fa919450ce7ba6 class hash 
//  contract address