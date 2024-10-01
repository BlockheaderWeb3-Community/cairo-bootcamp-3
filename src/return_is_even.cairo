use crate::utils::addition;

pub fn run(x: u16, y: u16) -> bool {
    let result = addition(x, y);
    if result % 2 == 0 {
        true
    } else {
        false
    }
}

