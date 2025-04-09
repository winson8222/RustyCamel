## Formatting
1. Install [ocamlformat](https://github.com/ocaml-ppx/ocamlformat#installation)
2. run `dune fmt`

## Sample JSON
### Literal
{"tag": "blk", "body": {"tag": "lit", "val": 1}}

## Ownership Checking
- Two kinds of move: `let` decl and `function `
- 2 kinds of borrow: immutable borrow and mutable borrow

### Mutability
Let declaration: `let x = &mut z` 
Unary Expression: `let mut x = z`


### Move
`let x = y`
sym: x , expr: Var
let x = &y
expr: 

### Borrow
Immutable Borrow
```
let x = 1;
let y = &x
```

Mutable Borrow
*Notice how x also needs the `mut` keyword
```
let mut x = 1 
let y = &mut x
```

