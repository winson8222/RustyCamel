TODO:
- Optimization string pooling
- if else allow one non-return, one return (in function)
- ownership checking in tele
- builtin functions
- visualizer
- assign type check + ownership cehck 
- throw err if no type declr (function) (letdecl) etc
```
let mut x = "hello";
let a = "world";
x = a;
a; // invalid
```
- Report, specification, documentation 


# RustyCamel—A Rust Sublanguage Project

## How to run the project
There are two main scripts: 
1. [`build.sh`](/build.sh)
- Builds `tsParser` and `vm` code. 
2. [`run.sh <file_path>`](/run.sh)
- Parses the rust code given by the argument and executes the code.

Note: Make sure the node version is compatible

The process:
- [tsParser](./tsParser/) converts Rust code to JSON AST
- JSON file is copied to the [VM directory](./vm/)
- VM executes the compiled code

## Project Structure
```
RustyCamel/
├── test.rs              # Your Rust source code
├── tsParser/            # TypeScript-based Rust parser
├── vm/                  # OCaml virtual machine
└── build.sh 
└── run.sh 
```

## Rust Sublanguage Specification
### Syntax
- Only explicit returns in the following format are supported:
`return <expr>;`

## Types
- i32
- f64
- String
- bool
- &<`type`>

## Type Checking
- Let declarations
Example: 
`let x: i32 = "hello"; // fails as declared type is different from value type`

- Functions
  - Parameter types
  - Return type
  - Binary operations
    - Check that operand types are compatible
  - Unary operations
    - Check that operand type is compatible
  - Borrow 
    - Allow mutable borrow only if the borrowed expression is mutable
      Example: 
      ```
      let x: str = "hello";
      let y: &mut str = &mut x; // fails as x is not mutable
      ```
  - Conditional Expression
    - Check that the predicate has type `bool`
    - Check that if-else branches have the same type
  - (Re)Assignment
    - Check that the variable being reassigned is of mutable type
  - While
    - Check that the predicate has type `bool`

## Ownership Checking
Note:
- Conditional branches must have the same ownership updates

1. Borrows (Mutable/Immutable)
  1.1 Borrows via let declarations

  Example 1.1.1: 
  ```
  let mut x: mut String = "hello";
  let y: &mut String = &x;
  let z: &mut String = &mut x; // Invalid
  ```
  
  Example 1.1.2: 
  ```
  let mut x: mut String = "hello";
  let y: &mut String = &x;
  x; // Invalid
  ```

  Example 1.1.3:
  ```
  let mut x: mut String = "hello";
  let y: &String = &x;
  x; // Invalid
  ```

  1.2. Borrows via function application
  Example 1.2.1:
  ```
  let mut x: &mut String ="hello";
  let y = f(&x)
  let z = f(&mut x)
  ```
2. Move
  2.1. Move via let declaration

  Example 2.1.1:
  ```
  let mut x:&mut String = "hello";
  let y = x
  let z = x // Invalid
  ```
  2.2. Move via function application
  Example 2.2.1: 
  ```
  fn f(s: &mut String) -> &mut String {
    return s;
  }

  let mut x: &mut String = "hello";
  let y: &mut String = f(x)
  let z: &mut String = f(x) // Invalid
  ```

  2.3. Move parameter (non-ref / ref) out of function via return statement
  ```
  fn f(s: &String) -> &String {
    return s;
  }
  ```

  2.4. Move non-ref variable out of function via return statement
  ```
  fn f() {
    let s : String = "hello";
    return s;
  }
  ```

  2.5. Move reference to local variable via return statement (Invalid)
  ```
  fn f() {
    let s : String = "hello";
    let a : &String = &s;
    return a; // Cannot return value referencing a local variable (regardless of type)
  }
  ```

    ```
  fn f() -> &i32 {
    let a : i32 = 5;
    let b : &i32 = &a;
    return b; // Cannot return value referencing a local variable (regardless of type)
  }
  ```

  2.6. Move dereferenced variable via return statement (Invalid)
  ```
  fn f() {
    let s : String = "hello";
    let a : &String = &s;
    return *a; // Cannot move out of a shared reference
  }
  ```

  1. if deref 
  2. else 
    - if param 
    - else
      -  if ref
      -  else (non-ref)
