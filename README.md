# functional-shell [![Build Status](https://travis-ci.org/simeg/functional-shell.svg)](https://travis-ci.org/simeg/functional-shell)

Use `map` and `filter` in your shell.

*This tool was written for learning and is not optimized for speed or compatibility.*

Tested with Bash 3 and 4.

# Examples

```bash
$ ls | map abspath
/Users/simon/repos/functional-shell/README.md
/Users/simon/repos/functional-shell/Makefile
...
```

```bash
$ ls | map abspath | map basename
README.md
Makefile
...
```

```bash
$ ls | map prepend 'file: '
file: README.md
file: Makefile
...
```

```bash
$ ls | filter is_file | map basename
TODO
...
```

```bash
$ seq 3 | map add 100
101
102
103
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

