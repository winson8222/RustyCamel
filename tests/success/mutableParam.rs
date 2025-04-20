fn f(mut f: String) -> String {
    f = "hello";
    return f;
}

fn main() -> i32 {
    let k : String = "hello";
    
    f(k);
    
    return 3;
}