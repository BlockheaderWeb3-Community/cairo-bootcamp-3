#[starknet::interface]
pub trait ICounter<TContractState> {
    fn get_count(self: @TContractState) -> u32;
    fn increment(ref self: TContractState);
    fn decrement(ref self: TContractState);
}