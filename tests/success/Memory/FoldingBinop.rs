fn manyBinops(n: i32) -> bool {
    let x : i32 = 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10;

    let mut y : i32 = x + 1;

    println!(y);
    y = y + 2;
    return n > 50;
}

let mut x: bool = manyBinops(10);

// case to check if the binop is folded