# RustyCamel—A Rust Sublanguage Project

## How to run the project
## Prerequisites

Before running the project, make sure you have the following installed:

- [Node.js ≥ 18](https://nodejs.org/en/download) – required to run the Rust parser (powered by Tree-sitter).
- [OPAM](https://opam.ocaml.org/doc/Install.html) – OCaml’s package manager.

## One-Time Setup

1. **Initialize OPAM** (if this is your first time using it):

```bash
opam init -y
eval $(opam env)
```

2. **Install OCaml dependencies:**
```bash
cd vm
opam install . --deps-only -y
```

3. **Install Node.js dependencies:**
```bash
cd ../tsParser
yarn install
cd ..
```

## Building the Project
To build the full pipeline (TypeScript parser + OCaml VM), run: 
[`build.sh`](/build.sh)


## Running the Pipeline
Once built, run a Rust source file end-to-end using:
[`run.sh <path/to/code.rs>`](/run.sh)


## Project Structure
```
RustyCamel/
├── test.rs              # Your Rust source code
├── tsParser/            # TypeScript-based Rust parser
├── vm/                  # OCaml virtual machine
└── build.sh 
└── run.sh 
```

The process:
- [tsParser](./tsParser/) converts Rust code to JSON AST
- JSON file is copied to the [VM directory](./vm/)
- VM executes the compiled code


## Language Specification
See [`tsParser/README.md](/tsParser/README.md)