# Installation Guide

This guide covers various ways to install functional-shell.

## Quick Install (Recommended)

### Homebrew (macOS/Linux)

```bash
# Once published to homebrew-core
brew install functional-shell

# Or from personal tap
brew tap simeg/tap
brew install functional-shell
```

### One-line Install Script

```bash
# Install to ~/.local (no sudo required)
curl -fsSL https://raw.githubusercontent.com/simeg/functional-shell/master/install.sh | bash

# System-wide installation (requires sudo)
curl -fsSL https://raw.githubusercontent.com/simeg/functional-shell/master/install.sh | bash -s -- --system
```

## Manual Installation

### From Source

1. Clone the repository:
   ```bash
   git clone https://github.com/simeg/functional-shell.git
   cd functional-shell
   ```

2. Install (choose one):
   ```bash
   # User-local installation (recommended)
   ./install.sh
   
   # System-wide installation
   ./install.sh --system
   
   # Custom prefix
   ./install.sh --prefix=/opt/functional-shell
   ```

### Verify Installation

```bash
# Check if commands are available
map --version
filter --version

# Test basic functionality
echo "hello world" | map to_upper
seq 1 10 | filter even
```

## Shell Integration

### PATH Configuration

If you installed to `~/.local/bin`, make sure it's in your PATH:

```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$HOME/.local/bin:$PATH"
```

### Shell Completion

Completion is automatically installed with Homebrew. For manual installations:

#### Bash
```bash
# Add to ~/.bashrc
source ~/.local/lib/functional-shell/completion/bash_completion
```

#### Zsh
```bash
# Add to ~/.zshrc
fpath=(~/.local/lib/functional-shell/completion $fpath)
autoload -Uz compinit && compinit
```

## Package Managers

### Coming Soon
- Debian/Ubuntu: `apt install functional-shell`
- RHEL/Fedora: `dnf install functional-shell`
- Arch Linux: `pacman -S functional-shell`
- Snap: `snap install functional-shell`

## Troubleshooting

### Command Not Found

1. Check if the executables exist:
   ```bash
   ls -la ~/.local/bin/map ~/.local/bin/filter
   # or
   ls -la /usr/local/bin/map /usr/local/bin/filter
   ```

2. Verify PATH includes the installation directory:
   ```bash
   echo $PATH | grep -o ~/.local/bin
   ```

3. Reload your shell configuration:
   ```bash
   source ~/.bashrc  # or ~/.zshrc
   ```

### Permission Errors

If you get permission errors during installation:

```bash
# Install to user directory instead
./install.sh

# Or fix directory permissions
sudo chown -R $(whoami) /usr/local/bin /usr/local/lib
```

### Library Loading Errors

If you see "source: file not found" errors:

1. Check library installation:
   ```bash
   ls -la ~/.local/lib/functional-shell/
   # or
   ls -la /usr/local/lib/functional-shell/
   ```

2. Reinstall with verbose output:
   ```bash
   bash -x install.sh
   ```

## Uninstallation

```bash
# Automatic uninstall
curl -fsSL https://raw.githubusercontent.com/simeg/functional-shell/master/scripts/uninstall.sh | bash

# Manual uninstall
rm -f ~/.local/bin/{map,filter}
rm -rf ~/.local/lib/functional-shell
```