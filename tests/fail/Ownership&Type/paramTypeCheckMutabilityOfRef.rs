let s : String = "program";

fn borrow(a: &mut String) {
    println!(*a);
}


borrow(&s);
