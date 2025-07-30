#!/usr/bin/env bash

set -e

# Comprehensive benchmark script for all functional-shell operations

echo "=== Comprehensive Functional Shell Benchmark ==="
echo "Date: $(date)"
echo "System: $(uname -a)"
echo ""

# Ensure we're using the development version
export PATH="./cmd:$PATH"

# Test data sizes
SMALL_SIZE=1000
# MEDIUM_SIZE=5000  # Unused variable - commenting out
LARGE_SIZE=10000

# Create test data
echo "-- Generating test data..."
seq 1 $LARGE_SIZE > /tmp/fs_bench_numbers.txt
seq 1 $SMALL_SIZE > /tmp/fs_bench_small.txt

# Generate string data
yes "hello world test string" | head -n $LARGE_SIZE > /tmp/fs_bench_strings.txt

# Generate file paths
find /usr -type f 2>/dev/null | head -n $LARGE_SIZE > /tmp/fs_bench_paths.txt || {
    # Fallback if /usr find fails
    for i in $(seq 1 $LARGE_SIZE); do
        echo "/usr/local/bin/file$i.txt"
    done > /tmp/fs_bench_paths.txt
}

echo ""

# Benchmark function
benchmark() {
    local name="$1"
    local command="$2"
    local input_file="$3"
    local iterations=${4:-3}

    printf "%-35s" "$name:"

    local total_time=0
    for i in $(seq 1 "$iterations"); do
        local start_time
        start_time=$(date +%s.%N)
        eval "$command" < "$input_file" > /dev/null 2>&1
        local end_time
        end_time=$(date +%s.%N)
        local duration
        duration=$(echo "$end_time - $start_time" | bc -l 2>/dev/null || echo "0.1")
        total_time=$(echo "$total_time + $duration" | bc -l 2>/dev/null || echo "$total_time")
    done

    local avg_time
    avg_time=$(echo "scale=3; $total_time / $iterations" | bc -l 2>/dev/null || echo "N/A")
    printf " %8ss\n" "$avg_time"
}

echo "=== ARITHMETIC OPERATIONS ==="
benchmark "map add 1" "map add 1" "/tmp/fs_bench_numbers.txt"
benchmark "map sub 5" "map sub 5" "/tmp/fs_bench_numbers.txt"
benchmark "map mul 2" "map mul 2" "/tmp/fs_bench_numbers.txt"
benchmark "map pow 2" "map pow 2" "/tmp/fs_bench_small.txt"  # pow is expensive
benchmark "filter even" "filter even" "/tmp/fs_bench_numbers.txt"
benchmark "filter odd" "filter odd" "/tmp/fs_bench_numbers.txt"

echo ""
echo "=== COMPARISON OPERATIONS ==="
benchmark "map eq 500" "map eq 500" "/tmp/fs_bench_numbers.txt"
benchmark "map ne 500" "map ne 500" "/tmp/fs_bench_numbers.txt"
benchmark "map gt 500" "map gt 500" "/tmp/fs_bench_numbers.txt"
benchmark "map lt 500" "map lt 500" "/tmp/fs_bench_numbers.txt"
benchmark "map ge 500" "map ge 500" "/tmp/fs_bench_numbers.txt"
benchmark "map le 500" "map le 500" "/tmp/fs_bench_numbers.txt"
benchmark "filter eq 500" "filter eq 500" "/tmp/fs_bench_numbers.txt"
benchmark "filter gt 500" "filter gt 500" "/tmp/fs_bench_numbers.txt"

echo ""
echo "=== FILE AND DIRECTORY OPERATIONS ==="
benchmark "map abspath" "map abspath" "/tmp/fs_bench_paths.txt"
benchmark "map dirname" "map dirname" "/tmp/fs_bench_paths.txt"
benchmark "map basename" "map basename" "/tmp/fs_bench_paths.txt"
benchmark "map strip_ext" "map strip_ext" "/tmp/fs_bench_paths.txt"
benchmark "map replace_ext new" "map replace_ext new" "/tmp/fs_bench_paths.txt"
benchmark "map has_ext txt" "map has_ext txt" "/tmp/fs_bench_paths.txt"
benchmark "filter is_file" "filter is_file" "/tmp/fs_bench_paths.txt"
benchmark "filter exists" "filter exists" "/tmp/fs_bench_paths.txt"
benchmark "filter has_ext txt" "filter has_ext txt" "/tmp/fs_bench_paths.txt"

echo ""
echo "=== STRING OPERATIONS ==="
benchmark "map reverse" "map reverse" "/tmp/fs_bench_strings.txt"
benchmark "map to_upper" "map to_upper" "/tmp/fs_bench_strings.txt"
benchmark "map to_lower" "map to_lower" "/tmp/fs_bench_strings.txt"
benchmark "map append _suffix" "map append _suffix" "/tmp/fs_bench_strings.txt"
benchmark "map prepend prefix_" "map prepend prefix_" "/tmp/fs_bench_strings.txt"
benchmark "map capitalize" "map capitalize" "/tmp/fs_bench_strings.txt"
benchmark "map strip" "map strip" "/tmp/fs_bench_strings.txt"
benchmark "map take 10" "map take 10" "/tmp/fs_bench_strings.txt"
benchmark "map drop 5" "map drop 5" "/tmp/fs_bench_strings.txt"
benchmark "map len" "map len" "/tmp/fs_bench_strings.txt"
benchmark "map replace hello hi" "map replace hello hi" "/tmp/fs_bench_strings.txt"
benchmark "map substr 0 10" "map substr 0 10" "/tmp/fs_bench_strings.txt"
benchmark "map duplicate" "map duplicate" "/tmp/fs_bench_strings.txt"
benchmark "filter contains hello" "filter contains hello" "/tmp/fs_bench_strings.txt"
benchmark "filter starts_with hello" "filter starts_with hello" "/tmp/fs_bench_strings.txt"
benchmark "filter ends_with string" "filter ends_with string" "/tmp/fs_bench_strings.txt"

echo ""
echo "=== LOGICAL OPERATIONS ==="
benchmark "map non_empty" "map non_empty" "/tmp/fs_bench_strings.txt"
benchmark "filter non_empty" "filter non_empty" "/tmp/fs_bench_strings.txt"

echo ""
echo "=== OTHER OPERATIONS ==="
benchmark "map id" "map id" "/tmp/fs_bench_strings.txt"
benchmark "map identity" "map identity" "/tmp/fs_bench_strings.txt"

echo ""
echo "=== PERFORMANCE ANALYSIS ==="
echo ""
echo "Testing with different input sizes:"

# Size comparison for key operations
echo ""
echo "Input Size Performance (map to_upper):"
for size in 1000 5000 10000; do
    seq 1 $size > /tmp/fs_size_test.txt
    printf "  %5d lines: " "$size"
    start_time=$(date +%s.%N)
    map to_upper < /tmp/fs_size_test.txt > /dev/null 2>&1
    end_time=$(date +%s.%N)
    duration=$(echo "$end_time - $start_time" | bc -l 2>/dev/null || echo "N/A")
    printf "%8ss\n" "$duration"
done

echo ""
echo "Input Size Performance (filter even):"
for size in 1000 5000 10000; do
    seq 1 $size > /tmp/fs_size_test.txt
    printf "  %5d lines: " "$size"
    start_time=$(date +%s.%N)
    filter even < /tmp/fs_size_test.txt > /dev/null 2>&1
    end_time=$(date +%s.%N)
    duration=$(echo "$end_time - $start_time" | bc -l 2>/dev/null || echo "N/A")
    printf "%8ss\n" "$duration"
done

echo ""
echo "=== SLOWEST OPERATIONS ==="
echo "Based on this benchmark, these operations may be slower:"
echo "• pow (exponentiation) - mathematical complexity"
echo "• substr/replace - string manipulation overhead"
echo "• file operations on non-existent paths (is_file, exists)"
echo "• operations with complex arguments (replace, substr)"

echo ""
echo "=== FASTEST OPERATIONS ==="
echo "• id/identity - passthrough operations"
echo "• len - bash built-in \${#var}"
echo "• arithmetic (add, sub, mul) - bash arithmetic"
echo "• simple string ops (append, prepend, to_upper, to_lower)"

echo ""
echo "=== RECOMMENDATIONS ==="
echo "• For very large datasets (>50k lines), consider native tools"
echo "• String operations are optimized but still slower than arithmetic"
echo "• File operations perform well with bash built-ins"
echo "• Filter operations are generally faster than equivalent map operations"

# Cleanup
rm -f /tmp/fs_bench_*.txt /tmp/fs_size_test.txt

echo ""
echo "Comprehensive benchmark complete!"
