pub fn add(x: i64, y: i64) -> i64 {
    x + y
}

pub fn mul(x: i64, y: i64) -> i64 {
    x * y
}

// x / y
pub fn div(x: i64, y: i64) -> i64 {
    x / y
}

pub fn sub(x: i64, y: i64) -> i64 {
    x - y
}

// x ** y
pub fn pow(x: i64, y: i64) -> i64 {
    let mut i = 0;
    let mut val: i64 = 1;

    let res: i64 = loop {
        if i == y {
            break val;
        }
        val *= x;
        i += 1
    };

    res
}

#[cfg(test)]
mod tests {
    use super::{add, div, pow};

    #[test]
    #[ignore]
    fn test_add() {
        // assert_eq!(add(5, 5), 10);
        assert!(add(5, 5) == 10, "add returns unexpected res");
        assert_lt!(add(4, 3), 8, "res should be lt 8");
    }

    #[test]
    #[should_panic(expected: 'Division by 0')]
    fn test_div_should_panic_when_divide_by_zero() {
        div(10, 0);
    }

    #[test]
    #[available_gas(2000000)]
    fn test_pow() {
        let res = pow(2, 10);
        assert_eq!(res, 1024);
    }
}
