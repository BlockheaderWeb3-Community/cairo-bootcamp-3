
pub fn sum_u16(x: u16, y: u16) -> u16 {
    x + y
}

pub fn run(x: u16, y: u16) -> bool {
    let result = sum_u16(x, y);
    if result % 2 == 0 {
        true
    } else {
        false
    }
}

