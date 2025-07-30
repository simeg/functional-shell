# functional-shell ![CI](https://github.com/simeg/functional-shell/workflows/CI/badge.svg)

Use `map` and `filter` in your shell.

*This tool was written for learning and is not optimized for speed or
compatibility.*

Tested with Zsh and Bash 3/4/5.

![Banner](banner.png)

---

# Examples

```bash
$ find .
./README.md
./Makefile

$ find . | map abspath
/Users/simon/repos/functional-shell/README.md
/Users/simon/repos/functional-shell/Makefile
```

```bash
$ find . | map abspath | map basename
README.md
Makefile
```

```bash
$ find . | map prepend 'file: '
file: ./README.md
file: ./Makefile
```

```bash
$ find . | filter contains md
./README.md
```

```bash
$ find . | filter contains md | map abspath
/Users/simon/repos/functional-shell/README.md
```

```bash
$ seq 3 | map add 100
101
102
103
```

# Installation

## Quick Install

Install to your user directory (recommended):

```bash
/bin/bash <(curl -s https://raw.githubusercontent.com/simeg/functional-shell/master/install.sh)
```

This installs to `~/.local/bin` and `~/.local/lib/functional-shell`. Make sure `~/.local/bin` is in your PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Alternative Installation Methods

**System-wide installation:**
```bash
curl -s https://raw.githubusercontent.com/simeg/functional-shell/master/install.sh | bash -s -- --system
```

**Custom prefix:**
```bash
curl -s https://raw.githubusercontent.com/simeg/functional-shell/master/install.sh | bash -s -- --prefix /usr/local
```

**Manual installation:**
```bash
git clone https://github.com/simeg/functional-shell.git
cd functional-shell
./install.sh --help  # See all options
```

## Shell Completion

Tab completion is automatically installed and provides:
- Operation suggestions: `map <TAB>` → shows available operations
- Contextual help: Shows operation descriptions
- Works with both bash and zsh

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/simeg/functional-shell/master/scripts/uninstall.sh | bash
```

# Operations

### File and Directory operations
```
abspath             :: Path   → Path
dirname             :: Path   → Path
basename            :: Path   → Path
is_dir              :: Path   → Bool
is_file             :: Path   → Bool
is_link             :: Path   → Bool
is_executable       :: Path   → Bool
exists              :: Path   → Bool
has_ext ext         :: Path   → Bool
strip_ext           :: Path   → String
replace_ext new_ext :: Path   → Path
split_ext           :: Path   → Array
```
### Logical operations
```
non_empty           :: *      → Bool
```
### Arithmetic operations
```
add num             :: Int    → Int
sub num             :: Int    → Int
mul num             :: Int    → Int
even                :: Int    → Bool
odd                 :: Int    → Bool
pow num             :: Int    → Int
```
### Comparison operations
```
eq other            :: *      → Bool
equal other         :: *      → Bool
equals other        :: *      → Bool
ne other            :: *      → Bool
not_eq other        :: *      → Bool
not_equals other    :: *      → Bool
ge i                :: Int    → Bool
greater_equals i    :: Int    → Bool
gt i                :: Int    → Bool
greater_than i      :: Int    → Bool
le i                :: Int    → Bool
less_equals i       :: Int    → Bool
lt i                :: Int    → Bool
less_than i         :: Int    → Bool
```
### String operations
```
reverse             :: String → String
append suffix       :: String → String
strip               :: String → String
substr start end    :: String → String
take count          :: String → String
to_lower            :: String → String
to_upper            :: String → String
replace old new     :: String → String
prepend prefix      :: String → String
capitalize          :: String → String
drop count          :: String → String
split delimiter     :: String → Array
duplicate           :: String → Array
contains substring  :: String → Bool
starts_with pattern :: String → Bool
ends_with pattern   :: String → Bool
len                 :: String → Int
length              :: String → Int
```
### Other operations
```
id                  :: *      → *
identity            :: *      → *
```

# Performance

Functional-shell has been optimized for performance with modern bash built-ins and minimal subprocess overhead.

## Benchmark Testing

Run the comprehensive performance benchmark:

```bash
./benchmark.sh
```

This script tests all operations across different categories and input sizes (1K-10K lines), providing:
- Individual operation timing
- Performance analysis by category
- Input size scaling tests
- Optimization recommendations

## Performance Characteristics

**Fast Operations** (~0.01-0.2s for 10K lines):
- Arithmetic: `add`, `sub`, `mul` (bash built-in arithmetic)
- File operations: `basename`, `dirname` (bash parameter expansion)
- Simple operations: `id`, `len`, `append`, `prepend`

**Medium Operations** (~0.5-2s for 10K lines):
- String operations: `to_upper`, `to_lower`, `reverse` (using `tr`/`rev`)
- Comparisons: `eq`, `gt`, `lt` variants

**Slower Operations** (>2s for 10K lines):
- Complex string operations: `substr`, `replace` (complex parsing)
- File system checks: `is_file`, `exists` (system calls)
- Mathematical: `pow` (computational complexity)

## Optimization Notes

- **Bash 3.2 Compatibility**: Uses `tr` for case conversion instead of `${var^^}` syntax
- **Subprocess Minimization**: Operations use bash built-ins where possible
- **Large Datasets**: For >50K lines, consider native tools like `awk`, `sed`, `tr`
- **Filter vs Map**: Filter operations have slight overhead due to boolean result checking

## Comparison with Native Tools

For reference, native tools are typically faster for specialized tasks:
```bash
# For case conversion
echo "text" | tr '[:lower:]' '[:upper:]'  # vs map to_upper

# For filtering numbers
seq 1 100 | awk 'NR % 2 == 0'           # vs filter even
```

Functional-shell provides a consistent, composable interface at the cost of some performance compared to specialized tools.

