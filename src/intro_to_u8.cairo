// integers are basically divided into 2:
// uint - u8, u16, u32, u64, u128, u256, usize
// int - i8, i16, i32, i64, i128, i256
pub fn run(x: u8, y: u8) -> u8 {
    // x + y // implicit return
    assert(x + y <= 255, 'exceeds');
    x + y
}