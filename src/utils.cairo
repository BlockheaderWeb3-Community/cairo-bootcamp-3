// util function to convert u8 to u16
pub fn low_to_high(x: u8) -> u16 {
    x.into()
}

// util function to convert u16 to u8
pub fn high_to_low(x: u16) -> u8 {
    x.try_into().unwrap()
}

  
  fn addition(a: u16, b: u16) -> u16 {
      let result = a + b;
      println!("Addition results____ {} ", result);
      return result;
  }
  
  fn substraction(a: u16, b: u16) -> u16 {
      let result = a - b;
      println!("substraction results____ {}", result);
      return result;
  }
  
  fn multiplication(x: u16, y: u16) -> u16 {
      let result = x * y;
      println!("multiplication results____ {}", result);
      return result;
  }
  
  fn division(x: u16, y: u16) -> u16 {
      let result = x / y;
      println!("Division results___ {}", result);
      return result;
  }