# Shell Completion

Functional Shell provides tab completion for both bash and zsh shells, making it easier to discover and use operations.

## What's Included

### Bash Completion
- Completes operation names for both `map` and `filter`
- Shows available operations based on command context
- Supports `--version` and `--help` flags

### Zsh Completion  
- Advanced completion with operation descriptions
- Context-aware suggestions
- Supports all command-line flags

## Installation

### Automatic Installation

Shell completion is automatically installed when you use the standard installation methods:

```bash
# One-line install (user-local)
curl -fsSL https://raw.githubusercontent.com/simeg/functional-shell/master/install.sh | bash

# Homebrew (when available)
brew install functional-shell

# System-wide install
curl -fsSL https://raw.githubusercontent.com/simeg/functional-shell/master/install.sh | bash -s -- --system
```

### Manual Installation

If you need to install completion manually:

#### Bash Completion

**User-local installation:**
```bash
mkdir -p ~/.local/share/bash-completion/completions
cp scripts/completion/bash_completion ~/.local/share/bash-completion/completions/functional-shell
```

**System-wide installation:**
```bash
sudo cp scripts/completion/bash_completion /usr/share/bash-completion/completions/functional-shell
```

#### Zsh Completion

**User-local installation:**
```bash
mkdir -p ~/.local/share/zsh/site-functions
cp scripts/completion/zsh_completion ~/.local/share/zsh/site-functions/_functional-shell

# Add to your ~/.zshrc if not already present:
fpath=(~/.local/share/zsh/site-functions $fpath)
autoload -Uz compinit && compinit
```

**System-wide installation:**
```bash
sudo cp scripts/completion/zsh_completion /usr/share/zsh/site-functions/_functional-shell
```

## Activation

### Bash

**After installation:**
- Restart your shell, or
- Run `source ~/.bashrc`, or  
- Run `source /usr/share/bash-completion/completions/functional-shell`

**Test completion:**
```bash
map <TAB>        # Shows all map operations
filter <TAB>     # Shows all filter operations
map to_u<TAB>    # Completes to "to_upper"
```

### Zsh

**After installation:**
- Restart your shell
- Or run `compinit` to reload completions

**Test completion:**
```bash
map <TAB>        # Shows operations with descriptions
filter is_<TAB>  # Shows operations starting with "is_"
map --<TAB>      # Shows available flags
```

## Available Operations

### Map Operations (40+ operations)
```bash
map <TAB>
```
Shows:
- **Arithmetic**: add, sub, mul, pow
- **String**: to_upper, to_lower, reverse, append, etc.
- **File**: abspath, dirname, basename, is_file, etc.
- **Comparison**: eq, ne, gt, lt, ge, le
- **Other**: id, identity

### Filter Operations (20+ operations)
```bash
filter <TAB>  
```
Shows:
- **Arithmetic**: even, odd
- **String**: contains, starts_with, ends_with
- **File**: is_file, is_dir, is_executable, exists, etc.
- **Comparison**: eq, ne, gt, lt, ge, le
- **Logical**: non_empty

## Troubleshooting

### Completion Not Working

**Check installation:**
```bash
# Bash
ls -la ~/.local/share/bash-completion/completions/functional-shell
ls -la /usr/share/bash-completion/completions/functional-shell

# Zsh  
ls -la ~/.local/share/zsh/site-functions/_functional-shell
ls -la /usr/share/zsh/site-functions/_functional-shell
```

**Check shell configuration:**

**Bash:**
```bash
# Make sure bash-completion is installed
which bash-completion

# Check if completions are loaded
complete -p map
```

**Zsh:**
```bash
# Check fpath includes completion directory
echo $fpath | grep site-functions

# Check if function is loaded
which _functional-shell
```

### Bash Completion Not Loading

**Install bash-completion package:**
```bash
# macOS
brew install bash-completion

# Ubuntu/Debian
sudo apt install bash-completion

# RHEL/Fedora
sudo dnf install bash-completion
```

**Add to ~/.bashrc:**
```bash
# macOS (if using Homebrew bash-completion)
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# Linux
[[ -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
```

### Zsh Completion Not Loading

**Check fpath in ~/.zshrc:**
```bash
# User-local completion
fpath=(~/.local/share/zsh/site-functions $fpath)

# System completion (usually automatic)
fpath=(/usr/share/zsh/site-functions $fpath)

# Initialize completion system
autoload -Uz compinit && compinit
```

### Development Setup

For development, use the development setup script:

```bash
make it-test-install  # Installs symlinks including completion
# Work on your changes
make it-test-uninstall  # Cleans up symlinks
```

This creates symlinks to the completion files so you can test changes without reinstalling.

## Customization

### Adding Custom Operations

If you add custom operations to the codebase:

1. **Update bash completion** in `scripts/completion/bash_completion`:
   ```bash
   _map_operations() {
       local operations=(
           # ... existing operations ...
           "your_new_operation"
       )
   }
   ```

2. **Update zsh completion** in `scripts/completion/zsh_completion`:
   ```bash
   _map_operations=(
       # ... existing operations ...
       'your_new_operation:Description of your operation'
   )
   ```

3. **Reinstall completion** or restart shell to pick up changes

### Shell-Specific Features

**Bash completion features:**
- Operation name completion
- Basic argument completion for some operations
- Flag completion (--version, --help)

**Zsh completion features:**
- Operation descriptions shown during completion
- Advanced argument completion
- Better context awareness
- More detailed help integration