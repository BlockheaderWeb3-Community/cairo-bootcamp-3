pub fn run(x: u8, y: u8) -> u8 {
    assert(x + y <= 255, 'exceeds');
    x + y
}
