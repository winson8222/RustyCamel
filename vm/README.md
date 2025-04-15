TODO: 
- Check scope logic. Seems like function always becomes a block
- We don't support lambda, const in the cur parser

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


two implementation ideas
(Chosen) 1. Add another sym - owenrship entry in cur frame (which can be diff from parnet frame in the case of block/function scope). This allows nested blocks to see the most "updated" ownership. parent simply doesnt know about the child frames so it's essentialy "restored" wihtout explciitly tracking brorows in the state. however, moving should modify in the parent frame. so we handle borrow and move differently. kind of counterintuitive that the parent state never changes for borrows, but correctness is guaranteed because we only have new frame for block/function, and that ahs to finish execution which must restore parent state (as if it never changed) before the code that follows can execute
2. Store all the borrows, change the sym recurisvely up parent frame. parent restores the ownership from before block/function. don't restore moving because move permanently affects parent
