// util function to convert u8 to u16
pub fn low_to_high(x: u8) -> u16 {
    x.into()
}

// util function to convert u16 to u8
pub fn high_to_low(x: u16) -> u8 {
    x.try_into().unwrap()
}



