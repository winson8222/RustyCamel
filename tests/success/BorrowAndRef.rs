fn main() -> i32{
    let x : i32 = 5;
    let y : i32 = 10;
    // return x * y;
    let r : &i32 = &x;
    return *r;
    // let sum : i32 = *r + y;
}

main();