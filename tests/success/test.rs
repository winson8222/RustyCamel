fnc take_ownership(s: String) -> String {
    return s;
}

fn main() {
    let s: String = "hello";
    let x: String = take_ownership(s);
    println!(x);
}
