.PHONY: fmt format lint test

ci: lint install-bats test

fmt: format

format:
	shellcheck -x -f diff fs/operations/* | git apply
	shellcheck -x -f diff fs/map | git apply
	shellcheck -x -f diff fs/filter | git apply

install:
	./install.sh

install-bats:
	git clone https://github.com/bats-core/bats-core.git /tmp/bats-core && \
		cd /tmp/bats-core && \
		sudo ./install.sh /usr/local

lint:
	shellcheck -x fs/map
	shellcheck -x fs/filter
	shellcheck -x fs/operations/*
	shellcheck -x fs/functions/*

test:
	bats -j 10 tests/
