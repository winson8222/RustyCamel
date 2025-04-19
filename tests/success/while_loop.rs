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

while_loop(0);