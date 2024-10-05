mod intro_to_felt;
mod intro_to_u8;
mod intro_to_u16;
mod intro_to_bytearray;
mod is_odd;
pub mod utils;

mod counterV2;
mod counterV3;


fn main() {
    intro_to_felt::run();
    intro_to_u8::run(5, 5);
    intro_to_u16::run(5, 5);
    intro_to_bytearray::run();
    is_odd::run(5);
}

