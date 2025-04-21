fn take_ownership(s: String) -> String {
    return s;
}

fn borrow_string(s: &String) {
    s;
}

fn main() {
    let s: String = "hello";
    let x: String = take_ownership(s);
    x;

    borrow_string(&x);
    x;
    s; // this should fail because s is moved to x
}
