fn main() {
    let mut x: String = "hello";
    let mut y: String = "world";

    let mut z: mut &String = mut &x;

    println!(*z);
}
