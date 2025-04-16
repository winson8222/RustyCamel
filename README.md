# RustyCamel

## How to run the project

1. Write the Rust code in [`test.rs`](./test.rs). For supported syntax, see [parser documentation](./tsParser/README.md)
2. Run the compiler and VM:
   ```bash
   ./compile_and_run.sh
   ```

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
└── compile_and_run.sh   # Build and run script
```