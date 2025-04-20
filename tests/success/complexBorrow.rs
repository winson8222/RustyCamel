// fn take_ownership(s: String) -> String {
//     return s;  // s is moved out
// }

// fn borrow_string(s: &String) -> &String {
//     return s;  // borrowed reference is returned
// }

// fn main() -> String {
//     let original: String = "hello";
    
    
//     // Test function calls with borrows
//     let borrowed: &String = borrow_string(&original);
    
//     // Test moving
//     let owned: String = take_ownership(original);  // original is moved
    
//     // This would fail if uncommented:
//     // let invalid = original;  // Error: original was moved
    
//     // Test dereferencing
//     let final_value: String = *borrowed;  // Dereference borrowed reference
//     return final_value;
// }

// main();