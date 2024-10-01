mod session_4;
mod intro_to_uint;
mod intro_to_felt;
mod sum_u8;
fn main() {
    let sum_1: u8 = intro_to_uint::run();
    let sum_2: u8 = sum_u8::run(2, 2);

    println!("result_1 {} | result_2 is {} ", sum_1, sum_2);

    session_4::main();
    intro_to_felt::run();
}
