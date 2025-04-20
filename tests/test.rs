fn factorial(n: i32) -> i32 {
    let x: i32 = 5;
    if n == 0 {
        let y: i32= x;
        return 1;
    } else {
        return n * factorial(n - 1);
    }
}