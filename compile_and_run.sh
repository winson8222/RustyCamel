#!/bin/bash

# Exit on any error
set -e

echo "=== Building TypeScript Parser ==="
cd tsParser
yarn install
yarn build
yarn tsc
echo "=== Running TypeScript Parser ==="
node dist/index.js
echo "=== Done ==="

echo '=== Copying JSON ==='

cp src/tests/ast.json ../vm/lib/ast.json

echo "=== Running OCaml VM ==="
cd ../vm
dune build
dune exec vm

echo "=== Done ==="