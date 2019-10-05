.PHONY: fmt format lint test

fmt: format

format:
	shellcheck -f diff operations/* | git apply
	shellcheck -f diff map | git apply
	shellcheck -f diff filter | git apply

lint:
	shellcheck operations/*
	shellcheck -x functions/*

test:
	bats tests/
