.PHONY: clean ci-bash ci-py fmt format install install-py-deps it-test it-test-install it-test-uninstall lint setup setup-py test version benchmark performance check-structure help all archive workflow uninstall install-system

# Default target
all: lint test

### Development

# Run shellcheck on all shell scripts
lint:
	shellcheck -x -e SC1091 cmd/map
	shellcheck -x -e SC1091 cmd/filter
	shellcheck -x lib/operations/*
	shellcheck -x lib/core/functions/*
	shellcheck -x install.sh
	shellcheck -x it-test-setup.sh
	shellcheck -x scripts/uninstall.sh
	shellcheck -x benchmark.sh

# Auto-format code using shellcheck diff output
format:
	shellcheck -x -f diff lib/operations/* | git apply --allow-empty
	shellcheck -x -f diff cmd/map | git apply --allow-empty
	shellcheck -x -f diff cmd/filter | git apply --allow-empty

# Alias for format target
fmt: format

# Run all Bats tests
test:
	bats -j 8 tests/

# Run comprehensive performance benchmark
benchmark:
	./benchmark.sh

# Alias for benchmark
performance: benchmark

# Setup development environment with required tools
setup:
	@echo "Setting up the development environment..."
	@echo "Installing required tools..."
	@if command -v brew >/dev/null 2>&1; then \
		brew install shellcheck bats-core; \
	else \
		echo "Please install shellcheck and bats-core manually"; \
	fi
	@echo "Setting up Python environment..."
	@if command -v poetry >/dev/null 2>&1; then \
		poetry install --only=test; \
	else \
		echo "Please install poetry for Python integration tests"; \
	fi

### Installation

# Run installation script (user-local by default)
install:
	./install.sh

# Install for system-wide access
install-system:
	./install.sh --system

# Install symlinks for development testing
it-test-install:
	./it-test-setup.sh install

# Remove development symlinks
it-test-uninstall:
	./it-test-setup.sh uninstall

# Remove installed files using uninstaller
uninstall:
	./scripts/uninstall.sh

# Remove installed files from system (legacy cleanup)
clean:
	@echo "Using modern uninstall script..."
	./scripts/uninstall.sh

### Testing & CI

# Run bash CI pipeline: lint and test
ci-bash: lint test

# Run Python CI pipeline: install deps, install locally, run integration tests
ci-py: install-py-deps it-test

# Install Python dependencies for testing
install-py-deps:
	poetry install --only=test

# Setup Python environment with specific version
setup-py:
	poetry env use python3.11

# Run integration tests with automatic setup and cleanup
it-test: it-test-install
	poetry run pytest -s tests/integration-tests/tests.py
	$(MAKE) it-test-uninstall

### Development & Release

# Show current version
version:
	@cat VERSION

# Check project structure
check-structure:
	@echo "-- Checking project structure..."
	@test -d cmd && echo "✓ cmd/ directory exists" || echo "✗ cmd/ directory missing"
	@test -d lib && echo "✓ lib/ directory exists" || echo "✗ lib/ directory missing"
	@test -d scripts && echo "✓ scripts/ directory exists" || echo "✗ scripts/ directory missing"
	@test -d tests && echo "✓ tests/ directory exists" || echo "✗ tests/ directory missing"
	@test -f VERSION && echo "✓ VERSION file exists" || echo "✗ VERSION file missing"
	@test -f cmd/map && echo "✓ cmd/map exists" || echo "✗ cmd/map missing"
	@test -f cmd/filter && echo "✓ cmd/filter exists" || echo "✗ cmd/filter missing"
	@test -f install.sh && echo "✓ install.sh exists" || echo "✗ install.sh missing"
	@test -f scripts/uninstall.sh && echo "✓ uninstall.sh exists" || echo "✗ uninstall.sh missing"
	@test -f benchmark.sh && echo "✓ benchmark.sh exists" || echo "✗ benchmark.sh missing"

# Create a release archive
archive:
	@echo "Creating release archive..."
	@VERSION=$$(cat VERSION); \
	tar --exclude='.git' --exclude='.github' --exclude='poetry.lock' --exclude='pyproject.toml' \
		--exclude='*.swp' --exclude='*.tmp' \
		-czf "functional-shell-$$VERSION.tar.gz" .
	@echo "Created: functional-shell-$$(cat VERSION).tar.gz"

### Information

# Show available targets
help:
	@echo "Functional Shell - Available Make Targets"
	@echo ""
	@echo "Development:"
	@echo "  all               Default target: lint + test"
	@echo "  lint              Run shellcheck on all shell scripts"
	@echo "  format (fmt)      Auto-format code using shellcheck"
	@echo "  test              Run all Bats tests"
	@echo "  benchmark         Run comprehensive performance benchmark"
	@echo "  check-structure   Verify project structure"
	@echo "  setup             Setup development environment (tools + deps)"
	@echo ""
	@echo "Installation:"
	@echo "  install           Install to user directory (~/.local)"
	@echo "  install-system    Install system-wide (/usr/local)"
	@echo "  uninstall         Remove installation using uninstall script"
	@echo ""
	@echo "Development Testing:"
	@echo "  it-test-install   Create symlinks for development testing"
	@echo "  it-test-uninstall Remove development symlinks"
	@echo "  it-test           Run integration tests (auto setup/cleanup)"
	@echo ""
	@echo "CI/Release:"
	@echo "  ci-bash           Run bash CI pipeline (lint + test)"
	@echo "  ci-py             Run Python CI pipeline (deps + integration test)"
	@echo "  version           Show current version"
	@echo "  archive           Create release archive"
	@echo ""
	@echo "Aliases:"
	@echo "  fmt               Alias for format"
	@echo "  performance       Alias for benchmark"
	@echo "  clean             Alias for uninstall (legacy)"
	@echo ""
	@echo "Use 'make <target>' to run any of these commands."

# Show quick development workflow
workflow:
	@echo "Typical Development Workflow:"
	@echo ""
	@echo "1. Setup environment:"
	@echo "   make setup"
	@echo ""
	@echo "2. Development cycle:"
	@echo "   make it-test-install    # Setup symlinks"
	@echo "   # ... make changes ..."
	@echo "   make lint              # Check code quality"
	@echo "   make test              # Run unit tests"
	@echo "   make it-test           # Run integration tests"
	@echo "   make benchmark         # Check performance"
	@echo ""
	@echo "3. Before commit:"
	@echo "   make ci-bash           # Full bash CI"
	@echo "   make check-structure   # Verify structure"
	@echo ""
	@echo "4. Installation testing:"
	@echo "   make install           # Test user install"
	@echo "   make uninstall         # Clean up"