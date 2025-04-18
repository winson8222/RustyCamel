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
echo "=== Running Expected Success Tests ==="
for test_file in rsTests/success/*.rs; do
    run_test "$test_file" false
done


echo "=== Running Expected Failure Tests ==="
for test_file in rsTests/fail/*.rs; do
    run_test "$test_file" true
done



# Print summary
echo "=== Test Summary ==="
echo "Total tests run: $(ls rsTests/*/*.rs | wc -l)"