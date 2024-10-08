mod calculator;

use calculator::div;

fn main() {
    let res = div(10, 0);
    println!("Res: {:?}", res);
}
