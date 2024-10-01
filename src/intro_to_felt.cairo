// Please note - Security considerations for felt252
// never use felt252 to perform arithmethic operations
// the max char length for felt252 is 31
pub fn run() -> felt252 {
    let x = 'SAY GM!';
    println!("x value here: {}", x);
    x
}