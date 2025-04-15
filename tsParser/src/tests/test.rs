// fn f() -> &&i32 {
//     let x: i32 = 5 + 10;
//     let ref_x: &i32 = &x;
//     &ref_x
// }

// f();
fn factorial(n: i32) -> i32 {
    -n
    // if n == 0 {
    //     1
    // } else {
    //     n * factorial(n - 1)
    // }
}

factorial(5);