fn main() {
    let mut x: i32 = 0;
 
    while x < 10 {
        if x < 5 {
            branch();
        } else {
            branch2();
        }
        x = x + 1;
    }
}

fn branch() {
    println!("bran");
}

fn branch2() {
    println!("bran2");
}

// to demonstrate branching and while loop combination


