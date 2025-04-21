fn take_ownership(s: String) -> String {
    return s;  
}

fn borrow_string(s: &String) {
    println(*s);  
}

fn main() -> String {
    let original: String = "hello";
    
    let owned: String = take_ownership(original);  // original is moved
    // borrow_string(&original);  // will fail
    
    return original;
}
