#!/bin/bash

# Exit on any error
set -e

echo "=== Preparing Directories ==="
mkdir -p "tsParser/src/input"
mkdir -p "tsParser/src/output"


echo "=== Building TypeScript Parser ==="
cd tsParser
yarn install
yarn build
yarn generate-parser
yarn tsc

echo "=== Building Ocaml VM ==="
cd ../vm
dune build