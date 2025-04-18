#!/bin/bash

# Exit on any error
set -e

# Check if file argument is provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide a Rust file path"
    echo "Usage: ./run.sh path/to/file.rs"
    exit 1
fi

INPUT_FILE=$1
FILENAME=$(basename "$INPUT_FILE")
JSON_FILENAME="${FILENAME%.*}.json"

echo "=== Copying $FILENAME to tsParser/src/input ==="
cp "$INPUT_FILE" "tsParser/src/input/$FILENAME"

echo "=== Running TypeScript Parser ==="
cd tsParser
node dist/index.js "src/input/$FILENAME"
echo "=== Done ==="

echo "=== Copying JSON ==="
cp "src/output/$JSON_FILENAME" "../vm/lib/ast.json"

echo "=== Running OCaml VM ==="
cd ../vm
dune exec vm

echo "=== Done ==="