#!/bin/bash

# Exit on any error
set -e


echo "=== Copying test.rs to tsParser/src/input ==="
cp test.rs tsParser/src/input/test.rs

echo "=== Running TypeScript Parser ==="
cd tsParser
node dist/index.js
echo "=== Done ==="

echo '=== Copying JSON ==='

cp src/output/ast.json ../vm/lib/ast.json

echo "=== Running OCaml VM ==="
cd ../vm
dune exec vm

echo "=== Done ==="