mod session_4;

fn main() {
    let sum_1: u8 = intro_to_uint();
    let sum_2: u8 = sum_u8(2, 2);

    println!("result_1 {} | result_2 is {} ", sum_1, sum_2);

    // run grade logic
    session_4::main();
}


// intro to felt
fn intro_to_felt() -> felt252 {
    let my_first_char: felt252 = 'GM';
    my_first_char
}

// intro to u8
fn intro_to_uint() -> u8 {
    let x: u8 = 10;
    let y: u8 = 20;
    x + y
}

// addition logic
fn sum_u8(x: u8, y: u8) -> u8 {
    x + y
}

