# Contributing to Functional Shell

Thank you for your interest in contributing to functional-shell! This guide will help you get started.

## Development Setup

### Prerequisites

- Bash 4.0+ (for the shell scripts)
- Git (for version control)
- Make (for build automation)

### Optional (for testing)

- [Bats](https://bats-core.readthedocs.io/) for shell testing
- Python 3.8+ and [Poetry](https://python-poetry.org/) for integration tests
- [shellcheck](https://github.com/koalaman/shellcheck) for linting

### Quick Start

1. Fork and clone the repository:
   ```bash
   git clone https://github.com/your-username/functional-shell.git
   cd functional-shell
   ```

2. Set up development environment:
   ```bash
   make setup  # Install development tools
   ```

3. Install for development (creates symlinks):
   ```bash
   make it-test-install
   export PATH="$HOME/.local/bin:$PATH"
   ```

4. Run tests:
   ```bash
   make test      # Bats tests
   make it-test   # Integration tests
   make lint      # Code quality
   ```

## Project Structure

```
functional-shell/
├── cmd/                    # Main executables
│   ├── map                 # map command
│   └── filter              # filter command
├── lib/                    # Core functionality
│   ├── core/functions/     # Core map/filter functions
│   └── operations/         # Operation implementations
├── tests/                  # Test suites
│   ├── *.bats             # Bats unit tests
│   └── integration-tests/  # Python integration tests
├── scripts/                # Utility scripts
│   ├── completion/        # Shell completions
│   └── uninstall.sh       # Uninstaller
├── packaging/              # Package definitions
│   ├── homebrew/          # Homebrew formula
│   └── debian/            # Debian package files
└── docs/                   # Documentation
```

## Making Changes

### Adding New Operations

1. **Choose the right category**: arithmetic, comparison, file_and_dir, logical, string, or other

2. **Add the function** to the appropriate file in `lib/operations/`:
   ```bash
   # Example: adding to lib/operations/string
   my_operation() {
       local input="$1"
       local arg="${2:-}"
       
       # Your implementation here
       echo "result"
   }
   ```

3. **For filter operations**, add to the allowlist in `lib/core/functions/_filter`:
   ```bash
   allowed_fns=(
       # ... existing operations ...
       my_operation
   )
   ```

4. **Add tests** in the appropriate `tests/*.bats` file:
   ```bash
   @test "string: map my_operation" {
       run echo "input" | _map my_operation
       assert_success
       assert_output "expected_output"
   }
   ```

5. **Update documentation** in `docs/reference/operations.md`

### Code Style

- Follow existing shell scripting patterns
- Use `set -e` for error handling
- Validate inputs and provide helpful error messages
- Use `local` for function variables
- Quote variables to handle spaces: `"$variable"`

### Testing

- **Unit tests**: Use Bats for testing individual operations
- **Integration tests**: Python tests that verify end-to-end functionality
- **Manual testing**: Test with symlinked development installation

```bash
# Run specific test categories
make test                    # All Bats tests
make it-test                # Integration tests
make lint                   # Code quality

# Development cycle
make it-test-install        # Set up symlinks
echo "test" | map to_upper  # Manual testing
make it-test-uninstall      # Clean up
```

## Submitting Changes

### Pull Request Process

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/my-new-operation
   ```

2. **Make your changes** and ensure tests pass:
   ```bash
   make ci-bash  # Full bash CI
   make ci-py    # Full Python CI
   ```

3. **Commit with clear messages**:
   ```bash
   git commit -m "Add string operation: my_operation"
   ```

4. **Push and create PR**:
   ```bash
   git push origin feature/my-new-operation
   ```

### PR Guidelines

- **Clear description**: Explain what the change does and why
- **Tests included**: All new functionality should have tests
- **Documentation updated**: Update relevant docs
- **Breaking changes**: Clearly marked and justified
- **One feature per PR**: Keep changes focused

### Commit Messages

Use clear, descriptive commit messages:

```
Add string operation: trim_whitespace

- Removes leading and trailing whitespace
- Available in both map and filter
- Includes comprehensive tests
```

## Development Tips

### Testing Your Changes

```bash
# Quick development cycle
make it-test-install

# Test specific operations
echo "  hello  " | map trim_whitespace
seq 1 10 | filter even

# Run full test suite
make ci-bash && make ci-py
```

### Debugging

- Use `set -x` in scripts for verbose output
- Check `$?` exit codes for debugging
- Use `declare -f function_name` to inspect functions

### Performance Considerations

- Operations should handle large inputs efficiently
- Avoid subshells in tight loops when possible
- Consider memory usage for string operations

## Code Review

We review all contributions for:

- **Functionality**: Does it work as intended?
- **Tests**: Are there adequate tests?
- **Documentation**: Is it properly documented?
- **Style**: Does it follow project conventions?
- **Security**: No unsafe practices or code injection risks

## Getting Help

- **Questions**: Open a discussion on GitHub
- **Bugs**: Open an issue with reproduction steps
- **Features**: Discuss in issues before implementing

Thank you for contributing to functional-shell!