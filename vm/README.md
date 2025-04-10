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

  ```
  let mut x = String::"hello";
  let y = &x
  let z = &mut x // Invalid
  ```

  - Borrows via function application

  ```
  let mut x = String::"hello";
  let y = f(&x)
  let z = f(&mut x)
  ```

  - TODO: reassign

- Move
  - Move via let declaration

  ```
  let mut x = String::"hello";
  let y = x
  let z = x // Invalid
  ```

  - Move via function application
  ```
  let mut x = String::"hello";
  let y = f(x)
  let z = f(x) // Invalid
  ```

  - TODO: reassign
