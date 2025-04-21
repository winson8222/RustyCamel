fn take_ownership(s: String) -> String {
    return s;  // s is moved out
}

fn borrow_string(s: &String) {
    s;
}

fn main() {
    let original: String = "hello";
    
    
    // Test function calls with borrows
    borrow_string(&original);
    
    // Test moving
    let owned: String = take_ownership(original);  // original is moved

}

main();