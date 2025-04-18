let mut x = 10;
let r1 = &x;
let r2 = &x;
// reference is not parsed properly now
let r3 = &mut x; // should fail