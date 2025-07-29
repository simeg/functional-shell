.PHONY: clean ci-bash ci-py fmt format install install-py-deps it-test it-test-install it-test-uninstall lint local-install local-install-ci setup setup-py test update-sha256

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
	shellcheck -x -f diff fs/operations/* | git apply --allow-empty
	shellcheck -x -f diff
	shellcheck -x -f diff filter | git apply --allow-empty

# Run installation script
install:
	./install.sh

# Run shellcheck on all shell scripts
lint:
	shellcheck -x -e SC1091 map
	shellcheck -x -e SC1091 filter
	shellcheck -x fs/operations/*
	shellcheck -x fs/functions/*
	shellcheck -x install.sh
	shellcheck -x update-sha256.sh
	shellcheck -x it-test-setup.sh

# Setup development environment with required tools
setup:
	@echo "Setting up the environment..."
	@brew install shellcheck bats parallel

# Run all Bats tests
test:
	bats -j 15 tests/

# Update SHA256 checksums
update-sha256:
	./update-sha256.sh


### Python

# Run Python CI pipeline: install deps, install locally, run integration tests
ci-py: install-py-deps local-install-ci it-test

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