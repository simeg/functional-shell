# Basic Usage

Functional shell provides two main commands: `map` and `filter`.

## The `map` Command

Transform each line of input using an operation.

### Syntax
```bash
command | map <operation> [arguments...]
```

### Basic Examples

#### String Operations
```bash
# Convert to uppercase
echo "hello world" | map to_upper
# Output: HELLO WORLD

# Convert to lowercase  
echo "HELLO WORLD" | map to_lower
# Output: hello world

# Reverse strings
echo -e "hello\nworld" | map reverse
# Output:
# olleh
# dlrow

# Get string length
echo -e "hello\nworld" | map len
# Output:
# 5
# 5
```

#### Arithmetic Operations
```bash
# Add numbers
seq 1 5 | map add 10
# Output:
# 11
# 12
# 13
# 14
# 15

# Multiply numbers
seq 1 5 | map mul 2
# Output:
# 2
# 4
# 6
# 8
# 10

# Power operations
seq 1 3 | map pow 2
# Output:
# 1
# 4
# 9
```

#### File Operations
```bash
# Get absolute paths
find . -name "*.txt" | map abspath

# Get directory names
find . -name "*.txt" | map dirname

# Get base names
find . -type f | map basename
```

## The `filter` Command

Keep only lines that match a condition.

### Syntax
```bash
command | filter <operation> [arguments...]
```

### Basic Examples

#### Numeric Filtering
```bash
# Filter even numbers
seq 1 10 | filter even
# Output:
# 2
# 4
# 6
# 8
# 10

# Filter odd numbers
seq 1 10 | filter odd
# Output:
# 1
# 3
# 5
# 7
# 9
```

#### File Filtering
```bash
# Filter only files (not directories)
find . | filter is_file

# Filter only directories
find . | filter is_dir

# Filter executable files
find . -type f | filter is_executable

# Filter files that exist
echo -e "/etc/passwd\n/nonexistent" | filter exists
# Output: /etc/passwd
```

#### String Filtering
```bash
# Filter lines containing text
ls | filter contains ".txt"

# Filter lines starting with text
ls | filter starts_with "test"

# Filter lines ending with text
ls | filter ends_with ".sh"

# Filter non-empty lines
cat file.txt | filter non_empty
```

## Chaining Operations

Combine multiple operations for powerful transformations:

```bash
# Find text files, get their base names, convert to uppercase
find . -name "*.txt" | filter is_file | map basename | map to_upper

# Get numbers 1-20, filter evens, square them, then filter those > 50
seq 1 20 | filter even | map pow 2 | filter gt 50

# Process log files: get existing ones, filter by size, get their directory
echo -e "/var/log/app.log\n/var/log/system.log" | filter exists | filter is_file | map dirname
```

## Working with Arguments

Many operations accept additional arguments:

```bash
# String operations with arguments
echo "hello world" | map replace "world" "universe"
# Output: hello universe

echo "test" | map append "_suffix"  
# Output: test_suffix

echo "test" | map take 2
# Output: te

# Numeric comparisons
seq 1 10 | filter gt 5
# Output: 6, 7, 8, 9, 10

seq 1 10 | filter eq 3
# Output: 3
```

## Common Patterns

### Processing File Lists
```bash
# Get sizes of all .txt files
find . -name "*.txt" | filter is_file | map abspath | while read file; do
    echo "$file: $(wc -l < "$file") lines"
done
```

### Text Processing
```bash
# Clean up a list of emails
cat emails.txt | filter non_empty | map to_lower | map strip | sort | uniq
```

### Log Analysis
```bash
# Extract unique IP addresses from access logs
grep "GET" access.log | map substr 0 15 | sort | uniq
```

## Error Handling

### Invalid Operations
```bash
# This will show an error
echo "test" | map invalid_operation
# Error: invalid_operation is not a valid function for map

echo "test" | filter invalid_operation  
# Error: invalid_operation is not a valid function for filter
```

### Empty Input
```bash
# Commands exit with status 1 when no input is provided
map to_upper < /dev/null
echo $?  # 1

filter even < /dev/null
echo $?  # 1
```

## Getting Help

```bash
# Show version
map --version
filter --version

# Basic usage (no arguments shows usage)
map
filter
```