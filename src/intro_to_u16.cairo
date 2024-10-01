use crate::utils::low_to_high;
pub fn run(x: u8, y: u8) -> u16 {
    let result: u16 = low_to_high::run(x) + low_to_high::run(y);
    result
}
