// for any string exceeding 31 chars, use ByteArray
pub fn run() -> ByteArray {
    let description: ByteArray = "Cairo Bootcamp 3 2024 is holding as a hybrid class";
    println!("desc: {}", description);
    description
}
