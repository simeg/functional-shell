# Debian Package for functional-shell

This directory contains the Debian packaging files for functional-shell.

## Building the Package

### Prerequisites

Install build dependencies:
```bash
sudo apt-get update
sudo apt-get install debhelper-compat devscripts build-essential
```

### Build Process

1. From the repository root:
   ```bash
   # Create source tarball
   tar --exclude='.git' --exclude='packaging' -czf ../functional-shell_1.0.0.orig.tar.gz .
   
   # Copy debian directory
   cp -r packaging/debian .
   
   # Build package
   debuild -us -uc
   ```

2. The built package will be in the parent directory:
   ```bash
   ls ../functional-shell_*.deb
   ```

### Installing the Package

```bash
sudo dpkg -i ../functional-shell_1.0.0-1_all.deb
sudo apt-get install -f  # Fix any dependency issues
```

### Testing the Package

```bash
# Verify installation
map --version
filter --version

# Test functionality
echo "hello" | map to_upper
seq 1 10 | filter even

# Check files
dpkg -L functional-shell
```

## Package Information

- **Package name**: functional-shell
- **Architecture**: all (shell scripts)
- **Dependencies**: bash (>= 4.0)
- **Suggests**: bash-completion
- **Section**: utils
- **Priority**: optional

## Files Installed

- `/usr/bin/map` - Main map executable
- `/usr/bin/filter` - Main filter executable
- `/usr/lib/functional-shell/` - Operation libraries
- `/usr/share/bash-completion/completions/functional-shell` - Bash completion
- `/usr/share/doc/functional-shell/` - Documentation

## Submitting to Debian

To submit to the official Debian repositories:

1. Ensure the package meets Debian standards:
   ```bash
   lintian ../functional-shell_*.deb
   ```

2. Follow the Debian New Maintainer process
3. Submit an Intent to Package (ITP) bug
4. Work with a Debian sponsor if needed

## Development

For development builds:
```bash
# Quick build for testing
dpkg-buildpackage -us -uc -b

# Clean build artifacts
debclean
```