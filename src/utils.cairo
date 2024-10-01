pub fn low_to_high(x: u8) -> u16 {
    x.into()
}

pub fn high_to_low(x: u16) -> u8 {
    x.try_into().unwrap()
}

pub fn is_odd(x: u8) -> bool {
    if x % 2 == 0 {
        false
    } else {
        true
    }
}

pub fn sum_u16(x: u16, y: u16) -> u16 {
    x + y
}

pub fn return_is_even(x: u16, y: u16) -> bool {
    let result = sum_u16(x, y);
    if result % 2 == 0 {
        true
    } else {
        false
    }
}

