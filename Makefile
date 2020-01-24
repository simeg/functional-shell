.PHONY: fmt format lint test

ci: lint install-bats test

fmt: format

format:
	shellcheck -f diff operations/* | git apply
	shellcheck -f diff map | git apply
	shellcheck -f diff filter | git apply

install-bats:
	git clone https://github.com/bats-core/bats-core.git /tmp/ && \
		cd /tmp/bats-core && \
		./install.sh /usr/local

lint:
	shellcheck operations/*
	shellcheck -x functions/*

test:
	bats -j 10 tests/
