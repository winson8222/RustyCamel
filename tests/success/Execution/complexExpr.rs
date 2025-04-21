fn f(n : i32) -> i32 {
    if (n <= 0) {
        return 1;
    } else {
        let x : i32 = 5;
        return x * f(n - 1);
    }
}

fn g(n : i32) -> i32 {
    if (n <= 0) {
        return 1;
    } else {
        let x : i32 = 5;
        return  g(n - 1) + x;
    }
}

fn main() -> i32{
    let x : i32 = 200;
    let y : i32 = 100;
    let z: i32 =  ((x + y)/9) + (x * y) -x + (-y);
    return z + g(5) + f(5);
}


// to demostrate chain of function calls and binary operations