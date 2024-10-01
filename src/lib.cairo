mod intro_to_felt;
mod intro_to_u8;
mod intro_to_u16;
mod intro_to_bytearray;

fn main() {
    intro_to_felt::run();
    intro_to_u8::run(5, 5);
    intro_to_u16::run(5, 5);
    intro_to_bytearray::run();
}

