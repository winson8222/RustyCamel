fn declare_consts(n: i32) -> i32 {
    let mut i: i32 = 3;
    {
        let mut m: i32 = 7;
    }
    let mut o: i32 = 9;
    return n;
}


declare_consts(0);