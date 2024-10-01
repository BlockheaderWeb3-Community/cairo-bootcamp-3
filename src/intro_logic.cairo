// Returns a felt252 datatype
// felt252 only takes 31 characters and single quotation
pub fn intro_to_felt() -> felt252 {
    let text = 'List of less than 32 characters';
    text
}

pub fn intro_to_bytearray() -> ByteArray {
    let x: ByteArray = "String as long as possible";
    x
}

// Integers are divided into uint and int
// uint: u8, u16, u32, u64, u128, u256
// int: i8, i16, i32, i64, i128, i256
// Max value of an int = (2^n) - 1
pub fn intro_to_u8(x: u8, y: u8) -> u8 {
    assert_le(x + y, 255)
    // x + y // Implicit return
    return x + y;
}

pub fn intro_to_u16(x: u8, y: u8) -> u16 {
    let sum: u8 = x + y
    // x + y // Implicit return
    return low_to_high(sum);
}

fn low_to_high(x: u8) -> u16 {
    x.into()
}

fn high_to_low(x: u16) -> u8 {
    x.try_into().unwrap()
}