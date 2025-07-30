# Functional Shell Cookbook

Real-world examples and recipes for common data processing tasks.

## Quick Reference

```bash
# Get help anytime
map --help
filter --help

# Test operations safely
echo "test input" | map operation
seq 1 5 | filter even
```

## 📁 File Management

### Renaming and File Operations

```bash
# Add .bak extension to all files
ls *.txt | map append ".bak"

# Remove extensions from filenames
ls *.jpg | map strip_ext

# Convert relative paths to absolute paths
find . -name "*.log" | map abspath

# Get just the filename from full paths
find /var/log -name "*.log" | map basename

# Get parent directory names
find . -type f | map dirname

# Batch rename: make all filenames uppercase
ls | map to_upper
```

### File Filtering

```bash
# Find only regular files (not directories or links)
find . | filter is_file

# Find only directories
ls -1 | filter is_dir

# Find files that actually exist (broken symlinks excluded)
cat file_list.txt | filter exists

# Find executable files
ls -1 | filter is_executable

# Find files with specific extensions
ls | filter has_ext "txt"
```

## 📊 Data Processing

### Numbers and Math

```bash
# Add tax to prices
cat prices.txt | map mul 1.08

# Convert Celsius to Fahrenheit: F = C * 9/5 + 32
echo "25" | map mul 9 | map div 5 | map add 32

# Get even/odd numbers
seq 1 100 | filter even
seq 1 100 | filter odd

# Extract numbers greater than a threshold
cat data.txt | filter gt 100

# Round numbers (using integer arithmetic)
cat decimals.txt | map add 0.5 | map mul 1  # Basic rounding
```

### Text Processing

```bash
# Convert text case
cat file.txt | map to_upper
cat file.txt | map to_lower

# Clean up text
cat messy.txt | filter non_empty  # Remove empty lines
cat file.txt | map strip          # Remove whitespace

# Add prefixes/suffixes
cat urls.txt | map prepend "https://"
cat commands.txt | map append " &"

# Filter lines containing specific text
cat log.txt | filter contains "ERROR"
cat file.txt | filter starts_with "#"  # Comments
cat file.txt | filter ends_with ".com" # Domains

# Get string lengths
cat words.txt | map len
```

## 🔍 Log Analysis

### Common Log Processing

```bash
# Extract error lines from logs
cat app.log | filter contains "ERROR"

# Find logs from specific time periods
cat access.log | filter contains "2024-01-15"

# Get unique error types (requires sort/uniq afterward)
cat error.log | filter contains "ERROR" | map to_upper

# Extract just the filenames from log paths
cat file_paths.log | map basename

# Find large log files
find /var/log -name "*.log" | filter exists | map abspath
```

### Web Server Logs

```bash
# Extract domains from URLs
cat access.log | map get_domain  # Note: You'd need a custom operation

# Find 404 errors
cat access.log | filter contains "404"

# Get client IPs (assuming standard format)
# This would need more complex parsing, but you can start with:
cat access.log | filter contains "GET"
```

## 🗂️ CSV and Structured Data

### Basic CSV Processing

```bash
# Skip header line and process data
tail -n +2 data.csv | map operation

# Extract specific columns (if comma-separated)
# Note: This requires custom operations or awk
cut -d',' -f2 data.csv | map to_upper

# Clean CSV data
cat data.csv | filter non_empty | map strip
```

## 🔧 System Administration

### Process and System Info

```bash
# Process running processes list
ps aux | tail -n +2 | map get_process_name  # Custom operation needed

# Clean up file lists
find . -type f | filter exists | map abspath

# Backup file lists
ls important_files/ | map append ".$(date +%Y%m%d)"
```

### Package Management

```bash
# Find installed packages (example for different systems)
dpkg -l | filter contains "install" | map get_package_name

# List configuration files
find /etc -name "*.conf" | filter is_file | map basename
```

## 🌐 Network and URLs

### URL Processing

```bash
# Add protocol to domains
cat domains.txt | map prepend "https://"

# Extract domains from emails
cat emails.txt | map extract_domain  # Custom operation needed

# Clean URLs
cat urls.txt | map strip | filter non_empty
```

## 🔄 Combining Operations

### Common Patterns

```bash
# Chain multiple operations
find . -name "*.txt" | filter exists | map basename | map to_upper

# Filter then transform
cat data.txt | filter non_empty | map append ".processed"

# Transform then filter
seq 1 100 | map mul 2 | filter gt 50

# Complex file processing
find . -type f | filter is_file | map abspath | filter contains "important"
```

## 🎯 Performance Tips

### Efficient Processing

```bash
# For large files, filter early to reduce processing
cat huge_file.txt | filter contains "keyword" | map to_upper

# Use specific types for better performance
find . -type f | filter is_file  # Better than generic filtering

# Combine operations when possible
# Instead of: cat file | map strip | map to_upper
# Consider: cat file | map "strip_and_upper"  # If you create custom operation
```

## 🔧 Custom Operations

### Creating Your Own

You can extend functional-shell by adding operations to the appropriate files in `lib/operations/`:

```bash
# Add to lib/operations/string
function domain_extract {
    local email="$1"
    echo "${email#*@}"  # Extract domain from email
}

# Add to lib/operations/other  
function timestamp {
    date +%s
}
```

## 🚨 Common Pitfalls

### What to Avoid

```bash
# Don't process binary files
file * | filter contains "text" | map basename  # Check file type first

# Be careful with large datasets
# Use head/tail to test first:
head -100 large_file.txt | map operation

# Remember filter security restrictions
# These won't work in filter (use map instead):
echo "test" | filter reverse  # ❌ Not in allowlist
echo "test" | map reverse     # ✅ Works
```

## 🔗 Integration with Other Tools

### Combining with Standard Unix Tools

```bash
# Pipe to sort/uniq
cat data.txt | map to_lower | sort | uniq

# Use with xargs
find . -name "*.bak" | filter exists | xargs rm

# Combine with awk/sed for complex processing
cat data.txt | map to_upper | awk '{print NR ": " $0}'

# Use with grep for regex filtering
cat file.txt | map to_lower | grep "pattern"
```

## 📚 When to Use Native Tools

For some tasks, native Unix tools are more appropriate:

```bash
# For regex: use grep instead of multiple filter operations
cat file.txt | grep "pattern" | map to_upper

# For field extraction: use cut/awk
cut -d',' -f2 data.csv | map strip

# For sorting: use sort
cat data.txt | map to_lower | sort -u

# For math aggregation: use awk
seq 1 100 | awk '{sum+=$1} END {print sum}'
```

Remember: functional-shell excels at simple, composable operations. For complex logic, consider awk, sed, or custom scripts.