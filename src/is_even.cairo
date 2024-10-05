mod sum_u8;
pub fn run(x: u8, y: u8) -> bool {
    let mymod = sum_u8::run(x, y) % 2;
    if mymod == 0 {
        true
    } else {
        false
    }
}
