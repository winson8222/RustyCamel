fn declare_consts(n: i32) -> i32 {
    let mut i: i32 = 3;
    let mut j: i32 = 4;
    let mut k: i32 = 5;
    {
        let mut l: i32 = 6;
        let mut m: i32 = 7;
        let mut n: i32 = 8;
    }
    let mut o: i32 = 9;
    let mut p: i32 = 10;
    return n;
}


declare_consts(0);