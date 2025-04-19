let s : i32 = 5;

fn borrow(a: &i32) -> &i32 {
    return a;
}

fn take(a: i32) -> i32 {
    return a;
}

borrow(&s);

take(s);
s;
