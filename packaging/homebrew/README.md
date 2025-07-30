# Homebrew Formula for Functional Shell

This directory contains the Homebrew formula for functional-shell.

## Publishing to Homebrew

### Option 1: Personal Tap (Recommended for testing)

1. Create a new repository named `homebrew-tap` on GitHub
2. Copy `functional-shell.rb` to that repository
3. Users can install with:
   ```bash
   brew tap your-username/tap
   brew install functional-shell
   ```

### Option 2: Submit to homebrew-core (For wider distribution)

Once the project is stable and has some adoption:

1. Fork https://github.com/Homebrew/homebrew-core
2. Add the formula to `Formula/functional-shell.rb`
3. Submit a pull request

Requirements for homebrew-core:
- Stable project with regular releases
- Notable usage/adoption
- Formula should be tested and working
- Must follow Homebrew guidelines

### Testing the Formula Locally

```bash
# Install from local file
brew install --build-from-source packaging/homebrew/functional-shell.rb

# Test the formula
brew test functional-shell

# Audit the formula
brew audit --strict functional-shell
```

### Updating the Formula

When releasing a new version:

1. Update the `url` with the new version tag
2. Update the `sha256` with the checksum of the new tarball:
   ```bash
   curl -L https://github.com/simeg/functional-shell/archive/v1.0.0.tar.gz | sha256sum
   ```
3. Update version references in tests if needed

### Formula Requirements

- The `url` should point to a stable release tarball
- The `sha256` must match the tarball checksum exactly
- Tests should cover basic functionality
- License should be specified correctly