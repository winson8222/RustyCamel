fn declare_consts(n: i32) -> i32 {
    let mut i: i32 = 3;
    if n > 0 {
        let mut j: i32 = 4;
        return j;
    } else {
        let mut l: i32 = 6;
        let mut m: i32 = 7;
        return l;
    }
}


declare_consts(3);
declare_consts(-1);


// case to check in a conditional block, different const declared in each block will be freed
// differently without affecting other blocks' variables (No double free)