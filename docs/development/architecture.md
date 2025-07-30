# Architecture

This document explains the internal architecture and design decisions of functional-shell.

## Overview

Functional Shell implements functional programming concepts (map and filter) as shell commands that operate on stdin/stdout streams. The architecture is designed for:

- **Modularity**: Operations are organized into categories
- **Extensibility**: Easy to add new operations  
- **Security**: Filter operations use an allowlist
- **Performance**: Minimal overhead for stream processing

## Core Components

### Executables (`cmd/`)

The main entry points that users interact with:

```bash
cmd/map     # Transform each line of input
cmd/filter  # Keep only lines that match a condition
```

**Key responsibilities:**
- Parse command line arguments
- Handle version/help flags
- Locate and source library files
- Delegate to core functions

**Path Resolution Logic:**
1. Check if symlinked → resolve real script location
2. Look for `../lib` relative to script (development mode)
3. Fall back to `~/.local/lib/functional-shell` (user install)
4. Fall back to `/usr/local/lib/functional-shell` (system install)

### Core Functions (`lib/core/functions/`)

The main processing logic:

```bash
lib/core/functions/_map     # Map implementation
lib/core/functions/_filter  # Filter implementation
```

**Map Function (`_map`)**:
- Validates function name format
- Checks if function exists
- Detects empty input (exits with code 1)
- Applies function to each line of stdin
- Preserves IFS for proper filename handling

**Filter Function (`_filter`)**:
- Uses allowlist of approved operations
- Validates function name against allowlist
- Detects empty input (exits with code 1)
- Only outputs lines where function returns "true"

### Operations (`lib/operations/`)

Modular operation implementations organized by category:

```bash
lib/operations/arithmetic      # add, sub, mul, pow, even, odd
lib/operations/comparison      # eq, ne, gt, lt, ge, le
lib/operations/file_and_dir    # is_file, is_dir, abspath, etc.
lib/operations/logical         # non_empty
lib/operations/string          # to_upper, reverse, contains, etc.
lib/operations/other           # id, identity
```

Each operation is a bash function that:
- Takes input as first parameter (`$1`)
- Takes optional arguments as subsequent parameters
- Returns result via stdout
- Uses consistent return values for filter operations

## Data Flow

### Map Operation
```
stdin → _map → operation_function → stdout
```

Example:
```bash
echo "hello" | map to_upper
# stdin: "hello"
# _map calls: to_upper "hello"  
# stdout: "HELLO"
```

### Filter Operation
```
stdin → _filter → operation_function → conditional stdout
```

Example:
```bash
seq 1 5 | filter even
# stdin: "1\n2\n3\n4\n5"
# _filter calls: even "1" → "false" (not output)
# _filter calls: even "2" → "true" (output)
# stdout: "2\n4"
```

## Design Decisions

### Security Model

**Map**: Uses function existence checking
- Allows any defined function
- Validates function name format (alphanumeric + underscore)
- Checks with `declare -f` before calling

**Filter**: Uses allowlist approach
- Only pre-approved functions allowed
- Prevents arbitrary code execution
- More restrictive for safety

### Error Handling

**Exit Codes:**
- `0`: Success
- `1`: Invalid arguments, empty input, or function not found
- `2`: Shell syntax errors

**Input Validation:**
- Empty stdin detection (both terminal and pipe)
- Function name format validation
- Argument count checking in operations

### Performance Optimizations

**IFS Handling:**
- Preserves original IFS for proper filename handling
- Handles filenames with spaces correctly

**Stream Processing:**
- Processes one line at a time (memory efficient)
- No buffering of entire input
- Works with large datasets

**Function Calls:**
- Direct function calls (not eval)
- Minimal subshell usage
- Efficient pipe handling

## File Organization

### Library Structure
```
lib/
├── core/
│   └── functions/
│       ├── _map        # Core map logic
│       └── _filter     # Core filter logic
└── operations/
    ├── arithmetic      # Math operations
    ├── comparison      # Comparison operations
    ├── file_and_dir    # File system operations
    ├── logical         # Logic operations
    ├── string          # String operations
    └── other           # Utility operations
```

### Operation Categories

**Arithmetic**: Pure mathematical operations
- Input/output: Numbers
- Examples: `add 5`, `mul 2`, `pow 3`

**Comparison**: Comparison operations  
- Input: Any value, argument: comparison value
- Output: "true" or "false"
- Examples: `eq "hello"`, `gt 10`

**File/Directory**: File system operations
- Input: File paths
- Output: Various (paths, "true"/"false", etc.)
- Examples: `is_file`, `abspath`, `dirname`

**String**: Text manipulation
- Input: Strings
- Output: Modified strings or "true"/"false"
- Examples: `to_upper`, `reverse`, `contains "text"`

**Logical**: Logic operations
- Input: Any value
- Output: "true" or "false"
- Examples: `non_empty`

## Extension Points

### Adding New Operations

1. **Choose category** or create new file in `lib/operations/`
2. **Implement function** following naming conventions
3. **Add to filter allowlist** (if applicable)
4. **Source in executables** (if new file)
5. **Add tests** and documentation

### Adding New Categories

1. **Create file** in `lib/operations/`
2. **Source in both executables** (`cmd/map` and `cmd/filter`)
3. **Update documentation**

## Testing Architecture

### Unit Tests (Bats)
- Test individual operations
- Source libraries directly
- Fast feedback loop

### Integration Tests (Python)
- Test full command line interface  
- Subprocess execution
- End-to-end validation

### Test Organization
```
tests/
├── fixture.bash           # Common test setup
├── arithmetic.bats        # Math operation tests
├── comparison.bats        # Comparison tests
├── file_and_dir.bats     # File operation tests
├── logical.bats          # Logic tests
├── string.bats           # String operation tests
└── integration-tests/
    └── tests.py          # End-to-end tests
```

## Installation Architecture

### Development Mode
- Symlinks in `~/.local/bin` → `cmd/`
- Library discovery via relative paths
- No file copying required

### User Installation
- Files copied to `~/.local/bin` and `~/.local/lib/functional-shell`
- Self-contained installation
- Installation manifest for clean uninstall

### System Installation  
- Files copied to `/usr/local/bin` and `/usr/local/lib/functional-shell`
- System-wide availability
- Requires elevated permissions

This architecture provides a clean separation of concerns while maintaining simplicity and extensibility.