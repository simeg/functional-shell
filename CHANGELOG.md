# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-07-29

### Added
- Complete project restructure with professional layout
- Version management with `--version` flags for both commands
- User-local installation by default (no sudo required)
- Comprehensive uninstall support with manifest tracking
- Homebrew formula for easy installation
- Shell completion for bash and zsh
- Debian package support
- Professional documentation structure
- CI/CD pipeline for automated releases
- 40+ operations across arithmetic, string, file, and comparison categories

### Changed
- **BREAKING**: Moved executables from root to `cmd/` directory
- **BREAKING**: Reorganized libraries from `fs/` to `lib/` structure
- **BREAKING**: Changed installation paths to use `functional-shell` subdirectory
- Install script now defaults to `~/.local` instead of `/usr/local`
- Improved error handling for empty input (exit code 1)
- Enhanced usage messages and help output

### Fixed
- Integration tests now pass in CI environments
- Proper exit codes for edge cases
- Path resolution works in all installation modes

### Security
- Filter operations use strict allowlist for security
- Input validation for all operation arguments

## [0.9.0] - 2024-07-28

### Added
- Basic `map` and `filter` commands
- Core operation set (arithmetic, string, file, comparison)
- Bats test suite
- Python integration tests
- Basic installation script
- GitHub Actions CI

### Changed
- Improved operation organization
- Better error messages

### Fixed
- File path handling with spaces
- Operation argument parsing

## [0.1.0] - 2024-07-01

### Added
- Initial implementation of functional shell utilities
- Basic map and filter operations
- Simple installation mechanism