pub fn low_to_high(x: u8) -> u16 {
    x.into()
}

pub fn high_to_low(x: u16) -> u8 {
    x.try_into().unwrap()
}