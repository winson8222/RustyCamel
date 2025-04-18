fn shout(s: String) -> String {
    return "hello";
}

let s : String = "hello";
shout(s);      // s is moved here
let x : String = s; 

// should fail