// use crate::utils::low_to_high;
pub fn low_to_high(x: u8) -> u16 {
    x.into()
}

pub fn run(x: u8, y: u8) -> u16 {
    let result: u16 = low_to_high(x) + low_to_high(y);
    result
}
