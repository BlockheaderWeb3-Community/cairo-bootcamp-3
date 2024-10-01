mod intro_to_felt;
mod intro_to_u8;
mod intro_to_u16;
mod intro_to_bytearray;
mod is_odd;
mod return_is_even;
pub mod utils;

fn main() {
    intro_to_felt::run();
    intro_to_u8::run(5, 5);
    intro_to_u16::run(5, 5);
    intro_to_bytearray::run();
    is_odd::run(10);
    is_odd::run(5);
    return_is_even::run(10,5);
    return_is_even::run(10,10);
}

