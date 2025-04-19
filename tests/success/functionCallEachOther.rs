fn double(x: i32) -> i32 {
    return x * 2;
}

fn add_one(x: i32) -> i32 {
    let doubled: i32 = double(x);
    return doubled + 1;
}

add_one(5);
