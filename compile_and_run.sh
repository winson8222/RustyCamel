#!/bin/bash

# Exit on any error
set -e

echo "=== Preparing Directories ==="
mkdir -p "tsParser/src/input"
mkdir -p "tsParser/src/output"

echo "=== Copying test.rs to tsParser/src/input ==="
cp test.rs tsParser/src/input/test.rs

echo "=== Building TypeScript Parser ==="
cd tsParser
yarn install
yarn build
yarn generate-parser
yarn tsc
echo "=== Running TypeScript Parser ==="
node dist/index.js
echo "=== Done ==="

echo '=== Copying JSON ==='

cp src/output/ast.json ../vm/lib/ast.json

echo "=== Running OCaml VM ==="
cd ../vm
dune build
dune exec vm

echo "=== Done ==="