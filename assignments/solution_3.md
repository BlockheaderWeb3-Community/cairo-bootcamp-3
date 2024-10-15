fn main() {
    subtract(17,13);
    add(30,20);
    divide(10,2);
    multiply(5,3);
}

fn subtract(a: u16, b: u16) -> u16 {
    let result = a - b;
  println!("subtraction result here___{}",   result);
  return result;
}

fn add(a: u16, b: u16) -> u16 {
    let result = a + b;
   println!("Addition result here___{}",   result);
   return result;
}

fn divide(a: u16, b: u16) -> u16 {
    let result = a / b;
    println!("Division result here___{}",   result);
   return result;
}

fn multiply(a: u16, b: u16) -> u16 {
    let result = a * b;
   println!("Multiplication result here___{}",   result);
   return result;
}