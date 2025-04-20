
fn f() -> &String {
    let x: String = "hello";
    let a: &String = &x;
    return a;
}

fn main() -> &String {
   return f();
}

main();