pub mod Errors {
    pub const NOT_OWNER: felt252 = 'CALLER NOT OWNER';
    pub const NOT_ADMIN: felt252 = 'CALLER NOT ADMIN';
    pub const ZERO_ADDRESS: felt252 = 'ZERO ADDRESS!';
    pub const SAME_ADDRESS: felt252 = 'CANNOT BE SAME ADDRESS!';
    pub const ZERO_VALUE: felt252 = 'CANNOT BE ZERO_VALUE!';
    pub const EMPTY_NAME: felt252 = 'NAME CAN NOT BE EMPTY!';
    pub const ADMIN_NOT_ALLOWED: felt252 = 'ADMIN CAN NOT BE A STUDENT';
}
// sncast --profile intro account deploy --name intro --fee-token eth                                         
// sncast --account intro declare --url https://free-rpc.nethermind.io/sepolia-juno --fee-token eth --contract-name Counter 
//  sncast --account intro  deploy --url https://free-rpc.nethermind.io/sepolia-juno  --fee-token eth --class-hash 0x2ed891bb2417107e425e9c1d1f3ef13bec730d21d3340099de685c52679eaea


// 0x6067f56674b7b566c299d2e076d452cc0d6d28bde699247138ca09d125a6926