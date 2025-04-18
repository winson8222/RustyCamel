let s : String = "programminggggggggggggggg";

fn borrow(a: &String) -> &String {
    return a;
}

fn take(a: String) -> String {
    return a;
}

borrow(&s);
s;
take(s);
