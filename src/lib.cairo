mod intro_to_felt;
mod intro_to_u8;
mod intro_to_u16;
mod intro_to_bytearray;
mod is_odd;
pub mod utils;
mod sum;
mod subtraction;
mod division;
mod multiplication;

fn main() {
    let sum_2: u8 = sum::sum_u8(2, 2);

    let res_sub = subtraction::sub(8, 5);
    let res_div = division::div(10, 5);
    let res_mult = multiplication::mult(10, 2);
    intro_to_felt::run();
    intro_to_u8::run(5, 5);
    intro_to_u16::run(5, 5);
    intro_to_bytearray::run();
    is_odd::run(5);

    println!("result_2: {} ",  sum_2);


    println!("The subtraction result is {}", res_sub);
    println!("The division result is {}", res_div);
    println!("The multiplication result is {}", res_mult);
}













// https://starklings.app/gostean