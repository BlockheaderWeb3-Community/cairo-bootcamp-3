mod intro_logic;

fn main() {
    intro_to_bytearray();
    // If you don't specify typ in variable declaration, it will take it as felt
    let sum_u16: u16 = intro_logic::intro_to_u16(5,10)
    println("sum result: {}", sum_u16)
}