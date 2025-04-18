let s : String = "programming";

fn borrow(a: &String) {
    a;
}

fn take(a: String) {
    a;
}

borrow(&s);
s;