#!/usr/bin/env bash

#
# Integration test setup script using symlinks
# This allows running it-test without needing sudo or copying files
#
# Usage: ./it-test-setup.sh [install|uninstall]
#

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly script_dir
readonly bin_dir="$HOME/.local/bin"
readonly lib_dir="$HOME/.local/lib"

usage() {
    echo "Usage: $0 [install|uninstall]"
    echo "  install   - Create symlinks for integration testing"
    echo "  uninstall - Remove symlinks created for integration testing"
    exit 1
}

install_symlinks() {
    echo "-- Setting up symlinks for integration testing..."
    
    # Ensure directories exist
    mkdir -p "$bin_dir" "$lib_dir"
    
    # Create symlinks for executables
    ln -sf "$script_dir/map" "$bin_dir/map"
    ln -sf "$script_dir/filter" "$bin_dir/filter"
    
    # Create symlink for operations library
    ln -sf "$script_dir/fs" "$lib_dir/fs"
    
    echo "-- Symlinks created:"
    echo "   $bin_dir/map -> $script_dir/map"
    echo "   $bin_dir/filter -> $script_dir/filter"
    echo "   $lib_dir/fs -> $script_dir/fs"
    echo ""
    echo "-- Make sure $bin_dir is in your PATH:"
    echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
}

uninstall_symlinks() {
    echo "-- Removing symlinks for integration testing..."
    
    # Remove symlinks if they exist
    [ -L "$bin_dir/map" ] && rm "$bin_dir/map" && echo "   Removed $bin_dir/map"
    [ -L "$bin_dir/filter" ] && rm "$bin_dir/filter" && echo "   Removed $bin_dir/filter"
    [ -L "$lib_dir/fs" ] && rm "$lib_dir/fs" && echo "   Removed $lib_dir/fs"
    
    echo "-- Symlinks removed"
}

# Parse command line argument
case "${1:-install}" in
    install)
        install_symlinks
        ;;
    uninstall)
        uninstall_symlinks
        ;;
    *)
        usage
        ;;
esac