fn main() {
    let sum_1: u8 = intro_to_uint();
    let sum_2: u8 = sum_u8(2, 2);

    let res_sub = sub(8, 5);
    let res_div = div(10, 5);
    let res_mult = mult(10, 2);

    println!("result_1___ result_2: {} {} ", sum_1, sum_2);


    println!("The subtraction result is {}", res_sub);
    println!("The division result is {}", res_div);
    println!("The multiplication result is {}", res_mult);
}


fn intro_to_felt() -> felt252 {
    let my_first_char: felt252 = 'GM';
    my_first_char
}

fn intro_to_uint() -> u8 {
    let x: u8 = 10;
    let y: u8 = 20;
    x + y 
}

fn sum_u8(x: u8, y: u8) -> u8 {
    x + y 
}

// / * -
fn sub(x: u8, y: u8) -> u8 {
    x - y
}

fn div(x: i8, y: i8) -> i8 {
    x / y
}

fn mult(x: u8, y: u8) -> u8 {
    x * y
}


// https://starklings.app/gostean