use starknet::ContractAddress;
#[derive(Drop, Serde, starknet::Store)]
pub struct Student {
    pub id: u64,
    pub name: felt252,
    pub account: ContractAddress,
    pub age: u8,
    pub xp: u16,
    pub is_active: bool
}
