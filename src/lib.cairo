mod intro_to_felt;

mod intro_to_u16;
mod intro_to_bytearray;
mod intro_to_u8;
pub mod utils;


fn main() {
    intro_to_felt::run();
    intro_to_bytearray::run();
    intro_to_u16::run(7, 7);
    intro_to_u8::run(8, 8);
    
}
