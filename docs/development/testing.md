# Testing Guide

This document covers the testing strategy and how to run tests for functional-shell.

## Test Structure

### Unit Tests (Bats)

Located in `tests/*.bats`, these test individual operations in isolation.

**Key files:**
- `tests/fixture.bash` - Common setup and utilities
- `tests/arithmetic.bats` - Math operations
- `tests/comparison.bats` - Comparison operations  
- `tests/file_and_dir.bats` - File system operations
- `tests/logical.bats` - Logic operations
- `tests/string.bats` - String operations

**Example test:**
```bash
@test "string: map to_upper" {
    run echo "hello" | _map to_upper
    assert_success
    assert_output "HELLO"
}
```

### Integration Tests (Python)

Located in `tests/integration-tests/tests.py`, these test the full command-line interface.

**What they test:**
- Complete map/filter commands via subprocess
- Error handling and exit codes
- Edge cases like empty input
- Cross-platform compatibility

**Example test:**
```python
def test_map__exits_w_code_1__when_no_input():
    code, _, _ = run(["map", "add"])
    assert code == 1
```

## Running Tests

### Quick Test Commands

```bash
# Run all unit tests
make test

# Run integration tests (auto-setup/cleanup)
make it-test

# Run both test suites
make ci-bash && make ci-py

# Lint code
make lint
```

### Manual Test Setup

For development where you want to run tests multiple times:

```bash
# Set up development environment
make it-test-install
export PATH="$HOME/.local/bin:$PATH"

# Run tests manually
bats tests/
poetry run pytest tests/integration-tests/

# Clean up when done
make it-test-uninstall
```

### Specific Test Categories

```bash
# Run specific Bats test files
bats tests/string.bats
bats tests/arithmetic.bats

# Run specific Python tests
poetry run pytest tests/integration-tests/tests.py::test_map__exits_w_code_1__when_no_input

# Run with verbose output
bats -t tests/
poetry run pytest -v tests/integration-tests/
```

## Writing Tests

### Adding Bats Tests

1. **Choose the right file** based on operation category
2. **Follow naming convention**: `category: command operation [condition]`
3. **Use fixture functions** for common setup

```bash
@test "string: map reverse" {
    run echo "hello" | _map reverse
    assert_success
    assert_output "olleh"
}

@test "string: filter contains [true]" {
    run echo "hello world" | _filter contains "world"
    assert_success
    assert_output "hello world"
}

@test "string: filter contains [false]" {
    run echo "hello" | _filter contains "world"
    assert_success
    refute_output
}
```

### Adding Integration Tests

Integration tests use the `run()` helper function:

```python
def test_new_operation():
    code, stdout, stderr = run(["map", "new_operation", "arg"])
    assert code == 0
    assert stdout == "expected_output\n"
    assert stderr == ""
```

### Test Data and Fixtures

**File fixtures** (for file operations):
```bash
# In tests/file_and_dir.bats
setup() {
    TEST_DIR="$(mktemp -d)"
    TEST_FILE="$TEST_DIR/test.txt"
    echo "content" > "$TEST_FILE"
    chmod +x "$TEST_FILE"
}

teardown() {
    rm -rf "$TEST_DIR"
}
```

**String fixtures** (for complex input):
```bash
@test "string: map operation with multiline" {
    input="line1\nline2\nline3"
    run echo -e "$input" | _map to_upper
    assert_success
    assert_output "LINE1
LINE2
LINE3"
}
```

## Testing Best Practices

### Unit Test Guidelines

1. **Test both success and failure cases**
2. **Use meaningful test names** that describe the scenario
3. **Test edge cases** like empty strings, special characters
4. **Keep tests focused** - one operation per test
5. **Use appropriate assertions**:
   - `assert_success` / `assert_failure`
   - `assert_output "expected"`
   - `refute_output` (for no output)

### Integration Test Guidelines

1. **Test the full command-line interface**
2. **Test error conditions** and exit codes
3. **Test with real subprocess execution**
4. **Cover edge cases** that unit tests might miss

### Testing New Operations

When adding a new operation, add tests for:

**Map operations:**
```bash
@test "category: map new_operation" {
    run echo "input" | _map new_operation
    assert_success
    assert_output "expected_output"
}

@test "category: map new_operation with argument" {
    run echo "input" | _map new_operation "arg"
    assert_success
    assert_output "expected_with_arg"
}
```

**Filter operations:**
```bash
@test "category: filter new_operation [true]" {
    run echo "matching_input" | _filter new_operation
    assert_success
    assert_output "matching_input"
}

@test "category: filter new_operation [false]" {
    run echo "non_matching_input" | _filter new_operation
    assert_success
    refute_output
}
```

## Continuous Integration

### GitHub Actions

The CI pipeline runs:
1. **Bash CI** (`make ci-bash`): lint + unit tests
2. **Python CI** (`make ci-py`): integration tests

### Local CI Simulation

Run the same checks locally:
```bash
# Full CI simulation
make ci-bash && make ci-py

# Check project structure
make check-structure

# Verify installation works
./install.sh --help
```

## Debugging Tests

### Debugging Bats Tests

```bash
# Run with verbose output
bats -t tests/string.bats

# Debug specific test
bats -f "string: map to_upper" tests/string.bats

# Add debug output to tests
@test "debug example" {
    echo "Debug: input is '$input'" >&3
    run echo "$input" | _map to_upper
    echo "Debug: output is '$output'" >&3
    assert_success
}
```

### Debugging Integration Tests

```python
def test_debug_example():
    code, stdout, stderr = run(["map", "to_upper"])
    print(f"Exit code: {code}")
    print(f"Stdout: {repr(stdout)}")
    print(f"Stderr: {repr(stderr)}")
    assert code == 0
```

### Common Issues

**Path issues:**
- Make sure symlinks are set up: `make it-test-install`
- Check PATH includes `~/.local/bin`

**Library loading:**
- Verify library files exist in expected locations
- Check sourcing in `cmd/map` and `cmd/filter`

**Test failures:**
- Check if new operations are added to filter allowlist
- Verify operation functions are exported
- Test manually: `echo "test" | ./cmd/map operation`

## Performance Testing

For performance-sensitive changes:

```bash
# Test with large input
seq 1 100000 | time map add 1
seq 1 100000 | time filter even

# Memory usage
/usr/bin/time -v echo "test" | map to_upper
```

## Test Coverage

Currently covered:
- ✅ All operations in all categories
- ✅ Both map and filter functionality  
- ✅ Error conditions and edge cases
- ✅ Command-line interface
- ✅ Installation and path resolution

Areas for expansion:
- Performance benchmarks
- Stress testing with very large inputs
- Cross-platform compatibility (Windows/WSL)
- Shell compatibility (different bash versions)