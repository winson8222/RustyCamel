

let i: i32 = 5;
let y: i32 = i; 
i; 
y;
// Should succeed since i is integer with copy trait

let s : String = "hello";
let x : &String = &s; 
x;
s;
// should succeed since s is moved to x





