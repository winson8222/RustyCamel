## Formatting

1. Install [ocamlformat](https://github.com/ocaml-ppx/ocamlformat#installation)
2. run `dune fmt`

## Sample JSON

### Literal

{"tag": "blk", "body": {"tag": "lit", "val": 1}}

## Ownership Checking

### Currently supported

- Borrows (Mutable/Immutable)
  - Borrows via let declarations
  Example:
  ```
  let x: String = "hello";
  let y: &String = &x
  ```

  - Borrows via function application
  Example:
  ```
  let mut x = "hello";
  let y: String = f(&x); // x is borrowed
  ```

- Move
  - Move via let declaration

  ```
  let x: String = "hello";
  let y: String = x; // x is moved into y
  ```

  - Move via function application
  ```
  let x: String = "hello";
  let y: String = f(x); // x is moved
  ```
