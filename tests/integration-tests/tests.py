#!/usr/bin/env python

import sys
import pytest
import subprocess


def run(cmd):
    proc = subprocess.Popen(cmd,
        stdout = subprocess.PIPE,
        stderr = subprocess.PIPE,
    )
    stdout, stderr = proc.communicate()

    return proc.returncode, stdout.decode("utf-8"), stderr.decode("utf-8")

def test_map__exits_w_code_1__when_no_function_provided():
    code, _, _ = run(["map"])
    assert code == 1

def test_map__exits_w_code_1__when_no_input():
    code, _, _ = run(["map", "add"])
    assert code == 1

    code, _, _ = run(["map", "add", "2"])
    assert code == 1

def test_map__writes_to_stderr__when_non_matching_function():
    code, stdout, stderr = run(["map", "non_matching_fn", "2>&1",
                                ">/dev/null"])
    assert code == 1
    assert stdout == ""
    assert "Error: 'non_matching_fn' is not a valid operation for map" in stderr

def test_filter__exits_w_code_1__when_no_function_provided():
    code, _, _ = run(["filter"])
    assert code == 1

def test_filter__exits_w_code_1__when_no_input():
    code, _, _ = run(["filter", "is_file"])
    assert code == 1

def test_filter__writes_to_stderr__when_non_matching_function():
    code, stdout, stderr = run(["filter", "non_matching_fn", "2>&1",
                                ">/dev/null"])
    assert code == 1
    assert stdout == ""
    assert "Error: 'non_matching_fn' is not a valid operation for filter" in stderr

