# RustyCamel

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