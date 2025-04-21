# RustyCamel—A Rust Sublanguage Project

## How to run the project
To set up the project for the first time, ensure you have [`node >= 18`](https://nodejs.org/en/download) and [`opam`](https://opam.ocaml.org/doc/Install.html) installed. This step should only be done once.

After the initial setup, there are two main scripts to interact with: 
1. [`build.sh`](/build.sh)
- Builds `tsParser` and `vm` code. 
2. [`run.sh <file_path>`](/run.sh)
- Parses the rust code given by the argument and executes the code.


## Project Structure
```
RustyCamel/
├── test.rs              # Your Rust source code
├── tsParser/            # TypeScript-based Rust parser
├── vm/                  # OCaml virtual machine
└── setup.sh 
└── build.sh 
└── run.sh 
```

The process:
- [tsParser](./tsParser/) converts Rust code to JSON AST
- JSON file is copied to the [VM directory](./vm/)
- VM executes the compiled code


## Rust Sublanguage Specification
### Syntax
Note: Only explicit returns in the following format are supported:
`return <expr>;`

## Types
- i32
- f64
- String
- bool
- &<`type`>
Note: All Let declarations and Function declarations must be typed explicitly. 
