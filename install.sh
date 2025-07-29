#!/usr/bin/env bash

#
# This script installs map and filter so that they are available on your $PATH
#
# It clones the repo, moves the files to /usr/local/bin and /usr/local/lib and
# finally removes the cloned repo
#

set -euo pipefail

readonly tmp_dir="/tmp/functional-shell"
readonly repo_url="https://github.com/simeg/functional-shell"
readonly expected_sha256="160a085aa649b90a55c704e8a46c1d8c73241fc88fae62f0095baadece0f3c32"

# Check if we need sudo for installation
check_permissions() {
    if [[ ! -w /usr/local/bin ]] || [[ ! -w /usr/local/lib ]]; then
        echo "-- Root permissions required for installation to /usr/local"
        if command -v sudo >/dev/null 2>&1; then
            echo "-- Will use sudo for installation"
            USE_SUDO="sudo"
        else
            echo "-- Error: No write permissions and sudo not available" >&2
            exit 1
        fi
    else
        USE_SUDO=""
    fi
}

# Verify repository integrity
verify_integrity() {
    echo "-- Verifying repository integrity..."
    
    if [[ "${expected_sha256}" == "PLACEHOLDER_SHA256" ]]; then
        echo "-- Warning: Checksum verification disabled (no expected hash provided)"
        return 0
    fi
    
    # Calculate SHA256 of the git tree
    local actual_sha256
    actual_sha256=$(cd "${tmp_dir}" && git ls-tree HEAD | sha256sum | cut -d' ' -f1)
    
    if [[ "${actual_sha256}" != "${expected_sha256}" ]]; then
        echo "-- Error: Repository integrity check failed!" >&2
        echo "-- Expected: ${expected_sha256}" >&2
        echo "-- Actual:   ${actual_sha256}" >&2
        echo "-- This could indicate tampering or an unexpected version" >&2
        exit 1
    fi
    
    echo "-- Repository integrity verified ✓"
}

echo "-- Cloning repo..."

git clone "${repo_url}" "${tmp_dir}"

echo "-- Repo cloned!"

verify_integrity

check_permissions

echo "-- Installing..."

# Install map and filter
${USE_SUDO} cp -f "${tmp_dir}/map" /usr/local/bin/
${USE_SUDO} cp -f "${tmp_dir}/filter" /usr/local/bin/

# Install operations
${USE_SUDO} cp -rf "${tmp_dir}/fs" /usr/local/lib/

echo "-- Cleaning up temp files..."

rm -rf ${tmp_dir}

echo "-- All done!"

