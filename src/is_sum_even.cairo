mod sum;

pub fn return_is_even(x: u16, y: u16) -> bool {
    let sum: u16 = sum::sum(x, y)
    return sum % 2 == 0
}