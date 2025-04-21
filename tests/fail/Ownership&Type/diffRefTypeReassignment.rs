fn main() {
    let x: i32 = 5;
    let y: i32 = 10;
    let r: &i32 = &x;
    r = &y;
}
