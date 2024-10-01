use crate::utils::low_to_high;
//converting from low to high
pub fn run(x: u8, y: u8) -> u16 {
    let result: u16 = low_to_high(x) + low_to_high(y);
    result
}

//converting from high to low
fn high_to_low(x: u16) -> u8 {
    x.try_into().unwrap()
}