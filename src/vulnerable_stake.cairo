// VulnerableStake contract
// Both deposit and withdraw functions of this contract contains flawed logic
use starknet::ContractAddress;
#[starknet::interface]
pub trait IVulnerableStake<T> {
    fn deposit(ref self: T, amount: u256, stake_addr: ContractAddress);
    fn withdraw(ref self: T, amount: u256, reward_addr: ContractAddress);
}


#[derive(Debug, Drop, Serde, Copy, starknet::Store)]
pub struct StakerInfo {
    pub stake_addr: ContractAddress,
    pub reward_amount: u256,
    pub stake_amount: u256,
    pub unclaimed_rewards_own: u256,
}


#[starknet::contract]
pub mod VulnerableStake {
    use starknet::{ContractAddress, get_caller_address};
    use starknet::storage::{StoragePointerWriteAccess, StoragePathEntry, Map};
    use super::{StakerInfo, IVulnerableStake,};
    #[storage]
    struct Storage {
        staker_info: Map<ContractAddress, StakerInfo>,
    }

    #[abi(embed_v0)]
    impl StakeImpl of IVulnerableStake<ContractState> {
        fn deposit(ref self: ContractState, amount: u256, stake_addr: ContractAddress) {
            let staker_info = StakerInfo {
                stake_addr, reward_amount: 0, stake_amount: amount, unclaimed_rewards_own: 0
            };
            let caller = get_caller_address();
            self.staker_info.entry(caller).write(staker_info);
        }


        fn withdraw(ref self: ContractState, amount: u256, reward_addr: ContractAddress) {}
    }
}
