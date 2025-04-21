fn f(mut f: String) -> String {
    let mut a : String = "hello";
    g(f);
    return a;
}

fn g(mut f: String) -> String {
    let mut b : String = "hello";
    f = "hello";
    return f;
}

fn main() {
    let k : String = "hello";
    
    let x : String = f(k);
    
    println!(x);
}

// case the check that ownership can be transferred from a function to another
// and the original variable can be used after the function call
//  testing the ownership visualisation to go across multiple functions