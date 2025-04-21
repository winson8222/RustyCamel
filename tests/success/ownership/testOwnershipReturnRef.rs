fn borrow_string(s: &String) -> &String {
    return s;
}

fn main() {
    let mut x: String = "hello";

    let y: &String = borrow_string(&x);

    x;

    println!(*y);

}




