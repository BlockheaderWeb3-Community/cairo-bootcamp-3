use starknet::ContractAddress;
#[event]
#[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
pub enum Event {

    StudentAdded: StudentAdded,
}

#[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
pub struct StudentAdded {
    #[key]
    pub name: felt252,
    pub account: ContractAddress,
    pub age: u8,
    pub xp: u16,
    pub is_active: bool
}