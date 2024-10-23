use starknet::ContractAddress;

#[starknet::interface]
pub trait IOwnable<T> {
    fn set_owner(ref self: T, new_owner: ContractAddress) -> bool;
    fn get_owner(self: @T) -> ContractAddress;
}


#[starknet::contract]
mod Ownable {
    use core::num::traits::zero::Zero;
    use starknet::{get_caller_address, ContractAddress};
    use super::IOwnable;
    use cairo_bootcamp_3::errors;

    #[storage]
    struct Storage {
        owner: ContractAddress
    }

    #[constructor]
    fn constructor(ref self: ContractState, init_owner: ContractAddress) {
        assert(!init_owner.is_zero(), errors::Errors::ZERO_ADDRESS);
        self.owner.write(init_owner);
    }

    #[abi(embed_v0)]
    impl OwnerImpl of IOwnable<ContractState> {
        fn set_owner(ref self: ContractState, new_owner: ContractAddress) -> bool {
            assert(!new_owner.is_zero(), errors::Errors::ZERO_ADDRESS);
            let caller = get_caller_address();
            assert(caller == self.owner.read(), errors::Errors::NOT_OWNER);
            self.owner.write(new_owner);
            true
        }

        fn get_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }
    }
}
// 0x61d76e98e466baefad1eac405693d24fdbefd29faa895ab6af5509c9dd189db

// 0x65f0904d094297f08575291f2da8600b60c12e764b63fdfef8c1044a3eaa34b -- owner cohort_dev
// 0x2dd6cf710592d99869d8868deab6c7d99369f629deb5c9ab71648170031640a -- ownable CA

// 0x6331d7d1cb9bc762785d083570d0d594fcf57cf3e5384209b59435c3f7e6d8b -- justice

//__________________________________TODAY_______________________
// 0xdedef0be763547e8e505d12fac321d0de4e9bd51635ac5fa00ae61d12e463e
// 0x6f2f6eb269f9741d5bb9cb633bfb632a0d71e0622b195ef4c4e66e8f1fee9fe - deploy_dev account
// 0x2a601649affa4fb870f919058baeed96729b1d7be7282b978e5ba50852d7c77 - ownable ca


