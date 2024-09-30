fn main() {
let \_difference: u8 = sub_u8(3, 1);
println!("result_diff: {}", \_difference);

    let _product_: u8 = mul_u8(2, 5);
    println!("result_product: {}", _product_);


    let _divident_: u8 = div_u8(10, 5);
    println!("result_divident: {}", _divident_);

}

fn sub_u8(x: u8, y: u8) -> u8 {
x - y
}

fn mul_u8(x: u8, y: u8) -> u8 {
x \* y
}

fn div_u8(x: u8, y: u8) -> u8 {
x / y
}
