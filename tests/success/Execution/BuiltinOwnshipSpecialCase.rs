fn manyWords() -> String {
    let mut x: String = "hello1";
    let mut y: String = "world2";

    println!(x);
    println!(y);


    return "hello3";
}

fn main() {
    let mut x: String = "hello";
    let mut y: String = "world";

    {
        let mut x: String = "hello";
        let mut y: String = "world";

        println!(x);
        println!(y);
    }


    println!(x);
    println!(y);

    x = "hello4";
    y = "world4";

    println!(x);
    println!(y);

   let z: String = manyWords();

   println!(z);
}


// for special cases that ownership is not transferred for builtin functions