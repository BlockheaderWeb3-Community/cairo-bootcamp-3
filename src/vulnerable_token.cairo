// NB
// this is not an ERC-20 token contract as it doesn't implement the ERC-20 standard
// This minimalistic VulnerableToken contract is a token contract whose `mint_token` method lacks
// the requisite access control to for the execution of critical operations like minting/burning of
// tokens; in our case here, we are targetting the increase total supply operation of the contract.
// It is being used here to showcase the security vulnerability of exposing critical functions
// without access control

#[starknet::interface]
pub trait IVulnerableToken<T> {
    fn mint_token(ref self: T);
    fn get_token_supply(self: @T) -> u256;
}

#[starknet::contract]
pub mod VulnerableToken {
    const MINT_AMOUNT: u256 = 1000;

    #[storage]
    struct Storage {
        total_supply: u256
    }


    #[abi(embed_v0)]
    impl VulnerableTokenImpl of super::IVulnerableToken<ContractState> {
        // increase token total supply by MINT_AMOUNT
        fn mint_token(ref self: ContractState) {
            let current_supply: u256 = self.total_supply.read();
            self.total_supply.write(current_supply + MINT_AMOUNT)
        }

        // get total supply of token
        fn get_token_supply(self: @ContractState) -> u256 {
            self.total_supply.read()
        }
    }
}

