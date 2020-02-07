.PHONY: fmt format lint test

clean:
	rm /usr/local/bin/map
	rm /usr/local/bin/filter
	rm -rf /usr/local/lib/fs

ci: lint install-bats test

fmt: format

format:
	shellcheck -x -f diff fs/operations/* | git apply
	shellcheck -x -f diff map | git apply
	shellcheck -x -f diff filter | git apply

install:
	./install.sh

integration-tests:
	pytest -s tests/integration-tests/tests.py

install-bats:
	git clone https://github.com/bats-core/bats-core.git /tmp/bats-core && \
		cd /tmp/bats-core && \
		sudo ./install.sh /usr/local

local-install:
	cp -f ./map /usr/local/bin/
	cp -f ./filter /usr/local/bin/
	cp -rf ./fs /usr/local/lib/

lint:
	shellcheck -x -e SC1091 map
	shellcheck -x -e SC1091 filter
	shellcheck -x fs/operations/*
	shellcheck -x fs/functions/*

test:
	bats -j 15 tests/
