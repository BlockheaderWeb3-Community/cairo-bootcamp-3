pub mod counter_v1;
pub mod counter_v2;
pub mod student_registry;
pub mod student_struct;
pub mod errors;
pub mod accounts;

<<<<<<< HEAD
mod sum;
mod subtraction;
mod division;
mod multiplication;

fn main() {
    let sum_2: u8 = sum::sum_u8(2, 2);

    let res_sub = subtraction::sub(8, 5);
    let res_div = division::div(10, 5);
    let res_mult = multiplication::mult(10, 2);


    println!("result_2: {} ",  sum_2);


    println!("The subtraction result is {}", res_sub);
    println!("The division result is {}", res_div);
    println!("The multiplication result is {}", res_mult);
}
=======
pub mod ownable_counter;
pub mod addition;
>>>>>>> refs/remotes/origin/main
