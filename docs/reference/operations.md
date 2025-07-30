# Operations Reference

Complete reference for all available operations in `map` and `filter`.

## Arithmetic Operations

### map arithmetic
| Operation | Description | Arguments | Example |
|-----------|-------------|-----------|---------|
| `add` | Add number to input | `<number>` | `echo 5 \| map add 3` → `8` |
| `sub` | Subtract number from input | `<number>` | `echo 5 \| map sub 3` → `2` |
| `mul` | Multiply input by number | `<number>` | `echo 5 \| map mul 3` → `15` |
| `pow` | Raise input to power | `<number>` | `echo 5 \| map pow 2` → `25` |

### filter arithmetic
| Operation | Description | Arguments | Example |
|-----------|-------------|-----------|---------|
| `even` | Filter even numbers | none | `seq 1 5 \| filter even` → `2, 4` |
| `odd` | Filter odd numbers | none | `seq 1 5 \| filter odd` → `1, 3, 5` |

## Comparison Operations

### map/filter comparison
| Operation | Aliases | Description | Arguments | Example |
|-----------|---------|-------------|-----------|---------|
| `eq` | `equal` | Equal to value | `<value>` | `echo 5 \| filter eq 5` → `5` |
| `ne` | `not_eq`, `not_equals` | Not equal to value | `<value>` | `echo 5 \| filter ne 3` → `5` |
| `gt` | `greater_than` | Greater than value | `<value>` | `seq 1 5 \| filter gt 3` → `4, 5` |
| `ge` | `greater_equals` | Greater than or equal | `<value>` | `seq 1 5 \| filter ge 3` → `3, 4, 5` |
| `lt` | `less_than` | Less than value | `<value>` | `seq 1 5 \| filter lt 3` → `1, 2` |
| `le` | `less_equals` | Less than or equal | `<value>` | `seq 1 5 \| filter le 3` → `1, 2, 3` |

## File and Directory Operations

### map file operations
| Operation | Description | Arguments | Example |
|-----------|-------------|-----------|---------|
| `abspath` | Get absolute path | none | `echo "." \| map abspath` → `/current/dir` |
| `dirname` | Get directory name | none | `echo "/path/file.txt" \| map dirname` → `/path` |
| `basename` | Get base name | none | `echo "/path/file.txt" \| map basename` → `file.txt` |
| `is_dir` | Test if directory | none | Returns `true` or `false` |
| `is_file` | Test if regular file | none | Returns `true` or `false` |
| `is_link` | Test if symbolic link | none | Returns `true` or `false` |
| `is_executable` | Test if executable | none | Returns `true` or `false` |
| `exists` | Test if path exists | none | Returns `true` or `false` |
| `has_ext` | Test if has extension | `[extension]` | `echo "file.txt" \| map has_ext` → `true` |
| `strip_ext` | Remove file extension | none | `echo "file.txt" \| map strip_ext` → `file` |
| `replace_ext` | Replace file extension | `<new_ext>` | `echo "file.txt" \| map replace_ext "md"` → `file.md` |
| `split_ext` | Split filename and extension | none | `echo "file.txt" \| map split_ext` → `file txt` |

### filter file operations
| Operation | Description | Arguments | Example |
|-----------|-------------|-----------|---------|
| `is_dir` | Filter directories | none | `find . \| filter is_dir` |
| `is_file` | Filter regular files | none | `find . \| filter is_file` |
| `is_link` | Filter symbolic links | none | `find . \| filter is_link` |
| `is_executable` | Filter executable files | none | `find . \| filter is_executable` |
| `exists` | Filter existing paths | none | `echo -e "/etc\n/nonexistent" \| filter exists` |
| `has_ext` | Filter files with extension | `[extension]` | `ls \| filter has_ext "txt"` |

## String Operations

### map string operations
| Operation | Description | Arguments | Example |
|-----------|-------------|-----------|---------|
| `reverse` | Reverse string | none | `echo "hello" \| map reverse` → `olleh` |
| `to_upper` | Convert to uppercase | none | `echo "hello" \| map to_upper` → `HELLO` |
| `to_lower` | Convert to lowercase | none | `echo "HELLO" \| map to_lower` → `hello` |
| `capitalize` | Capitalize first letter | none | `echo "hello" \| map capitalize` → `Hello` |
| `len` | Get string length | none | `echo "hello" \| map len` → `5` |
| `strip` | Remove whitespace | none | `echo " hello " \| map strip` → `hello` |
| `append` | Append text | `<text>` | `echo "hello" \| map append " world"` → `hello world` |
| `prepend` | Prepend text | `<text>` | `echo "world" \| map prepend "hello "` → `hello world` |
| `replace` | Replace text | `<old> <new>` | `echo "hello" \| map replace "ell" "ELL"` → `hELLo` |
| `substr` | Extract substring | `<start> [length]` | `echo "hello" \| map substr 1 3` → `ell` |
| `take` | Take first N characters | `<count>` | `echo "hello" \| map take 3` → `hel` |
| `drop` | Drop first N characters | `<count>` | `echo "hello" \| map drop 2` → `llo` |
| `duplicate` | Duplicate string N times | `<count>` | `echo "hi" \| map duplicate 3` → `hihihi` |
| `contains` | Test if contains text | `<text>` | Returns `true` or `false` |
| `starts_with` | Test if starts with text | `<text>` | Returns `true` or `false` |
| `ends_with` | Test if ends with text | `<text>` | Returns `true` or `false` |

### filter string operations
| Operation | Description | Arguments | Example |
|-----------|-------------|-----------|---------|
| `contains` | Filter strings containing text | `<text>` | `ls \| filter contains ".txt"` |
| `starts_with` | Filter strings starting with text | `<text>` | `ls \| filter starts_with "test"` |
| `ends_with` | Filter strings ending with text | `<text>` | `ls \| filter ends_with ".sh"` |

## Logical Operations

### map/filter logical
| Operation | Description | Arguments | Example |
|-----------|-------------|-----------|---------|
| `non_empty` | Test if non-empty | none | `echo -e "hello\n\nworld" \| filter non_empty` → `hello, world` |

## Other Operations

### map other
| Operation | Aliases | Description | Arguments | Example |
|-----------|---------|-------------|-----------|---------|
| `id` | `identity` | Return input unchanged | none | `echo "hello" \| map id` → `hello` |

## Operation Availability

### map vs filter
- **map operations**: Transform each input line and always produce output
- **filter operations**: Test each input line and only pass through lines that return "true"

Some operations are available in both `map` and `filter`:
- Comparison operations (`eq`, `ne`, `gt`, etc.)
- File test operations (`is_file`, `is_dir`, etc.)
- String test operations (`contains`, `starts_with`, `ends_with`)
- Logical operations (`non_empty`)

### Security Note
- **map**: Allows any defined operation (validated by function existence)
- **filter**: Uses an allowlist of approved operations for security

## Error Handling

### Invalid Operations
```bash
# map allows any defined function
echo "test" | map undefined_function
# Error: undefined_function is not a valid function for map

# filter has a strict allowlist
echo "test" | filter undefined_function  
# Error: undefined_function is not a valid function for filter
```

### Invalid Arguments
```bash
# Operations validate their arguments
echo "hello" | map take "not_a_number"
# May produce unexpected results or errors depending on the operation
```