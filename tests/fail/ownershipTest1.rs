#!/bin/bash

# Exit on error
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to run test and check expected outcome
run_test() {
    local test_file=$1
    local should_fail=$2
    local test_name=$(basename "$test_file" .rs)
    
    echo "=== Testing $test_name ==="
    
    # Run the compiler
    if ./run.sh "$test_file" > "test_outputs/${test_name}.log" 2>&1; then
        if [ "$should_fail" = true ]; then
            echo -e "${RED}❌ Test $test_name failed: Expected failure but succeeded${NC}"
            return 1
        else
            echo -e "${GREEN}✅ Test $test_name passed${NC}"
            return 0
        fi
    else
        if [ "$should_fail" = true ]; then
            echo -e "${GREEN}✅ Test $test_name passed (failed as expected)${NC}"
            return 0
        else
            echo -e "${RED}❌ Test $test_name failed: Expected success but failed${NC}"
            return 1
        fi
    fi
}

# Create output directory
mkdir -p test_outputs

# Run all tests
echo "=== Running Ownership Tests ==="

# Success cases
run_test "rsTests/success/copyType.rs" false
run_test "rsTests/success/validBorrow.rs" false

# Failure cases
run_test "rsTests/fail/doubleBorrow.rs" true
run_test "rsTests/fail/moveAfterMove.rs" true
run_test "rsTests/fail/useAfterMove.rs" true

# Print summary
echo "=== Test Summary ==="
echo "Total tests run: $(ls rsTests/*/*.rs | wc -l)"