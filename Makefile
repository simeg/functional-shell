.PHONY: clean ci-bash ci-py fmt format install install-py-deps it-test it-test-install it-test-uninstall lint local-install local-install-ci setup setup-py test version package-debian check-structure help

### Bash

# Remove installed files from system
clean:
	rm /usr/local/bin/map
	rm /usr/local/bin/filter
	rm -rf /usr/local/lib/fs

# Run bash CI pipeline: lint and test
ci-bash: lint test

# Alias for format target
fmt: format

# Auto-format code using shellcheck diff output
format:
	shellcheck -x -f diff lib/operations/* | git apply --allow-empty
	shellcheck -x -f diff cmd/map | git apply --allow-empty
	shellcheck -x -f diff cmd/filter | git apply --allow-empty

# Run installation script
install:
	./install.sh

# Run shellcheck on all shell scripts
lint:
	shellcheck -x -e SC1091 cmd/map
	shellcheck -x -e SC1091 cmd/filter
	shellcheck -x lib/operations/*
	shellcheck -x lib/core/functions/*
	shellcheck -x install.sh
	shellcheck -x it-test-setup.sh
	shellcheck -x scripts/uninstall.sh

# Setup development environment with required tools
setup:
	@echo "Setting up the environment..."
	@brew install shellcheck bats parallel

# Run all Bats tests
test:
	bats -j 8 tests/



### Python

# Run Python CI pipeline: install deps, install locally, run integration tests
ci-py: install-py-deps it-test

# Setup Python environment with specific version
setup-py:
	poetry env use python3.11

# Install Python dependencies for testing
install-py-deps:
	poetry install --only=test

# Run integration tests with automatic setup and cleanup
it-test: it-test-install
	poetry run pytest -s tests/integration-tests/tests.py
	./it-test-setup.sh uninstall

# Install files to system paths with sudo (for CI)
local-install-ci:
	sudo cp -f ./map /usr/local/bin/
	sudo cp -f ./filter /usr/local/bin/
	sudo cp -rf ./fs /usr/local/lib/

# Install symlinks for integration testing
it-test-install:
	./it-test-setup.sh install

# Remove symlinks created for integration testing
it-test-uninstall:
	./it-test-setup.sh uninstall

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
	@test -d packaging && echo "✓ packaging/ directory exists" || echo "✗ packaging/ directory missing"
	@test -d docs && echo "✓ docs/ directory exists" || echo "✗ docs/ directory missing"
	@test -f VERSION && echo "✓ VERSION file exists" || echo "✗ VERSION file missing"
	@test -f cmd/map && echo "✓ cmd/map exists" || echo "✗ cmd/map missing"
	@test -f cmd/filter && echo "✓ cmd/filter exists" || echo "✗ cmd/filter missing"

# Build Debian package (requires build tools)
package-debian:
	@echo "-- Building Debian package..."
	tar --exclude='.git' --exclude='.github' --exclude='packaging' -czf ../functional-shell_$(shell cat VERSION).orig.tar.gz .
	cp -r packaging/debian .
	debuild -us -uc
	@echo "-- Package built: ../functional-shell_$(shell cat VERSION)-1_all.deb"

# Show available targets
help:
	@echo "Functional Shell - Available Make Targets"
	@echo ""
	@echo "Development:"
	@echo "  lint              Run shellcheck on all shell scripts"
	@echo "  format            Auto-format code using shellcheck"
	@echo "  test              Run all Bats tests"
	@echo "  it-test           Run integration tests (sets up and cleans up automatically)"
	@echo "  check-structure   Verify project structure"
	@echo ""
	@echo "Installation:"
	@echo "  install           Run installation script (user-local by default)"
	@echo "  it-test-install   Install symlinks for development testing"
	@echo "  it-test-uninstall Remove development symlinks"
	@echo ""
	@echo "CI/Release:"
	@echo "  ci-bash           Run bash CI pipeline (lint + test)"
	@echo "  ci-py             Run Python CI pipeline (deps + install + integration test)"
	@echo "  version           Show current version"
	@echo "  package-debian    Build Debian package"
	@echo ""
	@echo "Utilities:"
	@echo "  clean             Remove installed files from system"
	@echo "  setup             Setup development environment"
	@echo "  help              Show this help message"