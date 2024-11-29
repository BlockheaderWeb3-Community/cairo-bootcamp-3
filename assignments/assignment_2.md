fn main() {

    add();
    subtraction();
    multiply();
    division();

}

<!--Addition -->
pub fn add() -> u8 {
    let x: u8 = 24;
    let y: u8 = 40;
    let z: u8 = x + y;
    println!("The value of Z is: {}", z);
    z
}

 <!-- Subtraction -->
pub fn subtraction() -> u128 {
    let x: u128 = 404;
    let y: u128 = 40;
    let z: u128 = x - y;
    println!("The value of Z is: {}", z);
    z
}

<!--Multiplication -->
pub fn multiply() -> u128 {
    let x: u128 = 50;
    let y: u128 = 40;
    let z: u128 = x * y;
    println!("The value of Z is: {}", z);
    z
}

<!--Diision -->
pub fn division() -> u8 {
    let x: u8 = 400;
    let y: u8 = 40;
    let z: u8 = x / y;
    println!("The value of Z is: {}", z);
    z
}
