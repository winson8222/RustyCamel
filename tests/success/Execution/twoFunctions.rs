fn plus_one(n: i32) -> i32 {
    return n + 1;
}

fn while_loop(mut n: i32) -> i32 {
    let mut i: i32 = 0;
    let mut j: i32 = 0;
    while i < 3 {
        while j < 2 {
            j = j + 1;
            n = n + 1;
        }
        j = 0;
        i = i + 1;
    }
    return n;
}


fn main() {
    let mut x: i32 = while_loop(0);
    x = plus_one(x);
    x = plus_one(x);

    println!(x);
}

// show nested while loops and function calls
