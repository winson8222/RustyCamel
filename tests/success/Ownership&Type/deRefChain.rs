fn main() {
    let mut x: String = "hello";
    
    let mut y: &String = &x;

    let mut z: &&String = &y;

    let mut w: &&&String = &z;

    println!(***w);
}

// demostrate the deref chain

