fn f(s: &mut String) -> &mut String {
    return s;
  }

  let mut x: &mut String = "hello";
  let y: &mut String = f(x)
  let z: &mut String = f(x) // Invalid