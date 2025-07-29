.PHONY: clean ci-bash ci-py fmt format install install-py-deps it-test it-test-install it-test-uninstall lint local-install local-install-ci setup setup-py test update-sha256

### Bash

clean:
	rm /usr/local/bin/map
	rm /usr/local/bin/filter
	rm -rf /usr/local/lib/fs

ci-bash: lint test

fmt: format

format:
	shellcheck -x -f diff fs/operations/* | git apply --allow-empty
	shellcheck -x -f diff
	shellcheck -x -f diff filter | git apply --allow-empty

install:
	./install.sh

lint:
	shellcheck -x -e SC1091 map
	shellcheck -x -e SC1091 filter
	shellcheck -x fs/operations/*
	shellcheck -x fs/functions/*
	shellcheck -x install.sh
	shellcheck -x update-sha256.sh
	shellcheck -x it-test-setup.sh

setup:
	@echo "Setting up the environment..."
	@brew install shellcheck bats parallel

test:
	bats -j 15 tests/

update-sha256:
	./update-sha256.sh


### Python

ci-py: install-py-deps local-install-ci it-test

setup-py:
	poetry env use python3.11

install-py-deps:
	poetry install --only=test

it-test: it-test-install
	poetry run pytest -s tests/integration-tests/tests.py
	./it-test-setup.sh uninstall

local-install-ci:
	sudo cp -f ./map /usr/local/bin/
	sudo cp -f ./filter /usr/local/bin/
	sudo cp -rf ./fs /usr/local/lib/

it-test-install:
	./it-test-setup.sh install

it-test-uninstall:
	./it-test-setup.sh uninstall