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
    ln -sf "$script_dir/cmd/map" "$bin_dir/map"
    ln -sf "$script_dir/cmd/filter" "$bin_dir/filter"
    
    # Create symlink for operations library
    ln -sf "$script_dir/lib" "$lib_dir/functional-shell"
    
    # Install shell completions for development
    completion_dir="$HOME/.local/share/bash-completion/completions"
    zsh_completion_dir="$HOME/.local/share/zsh/site-functions"
    
    mkdir -p "$completion_dir" "$zsh_completion_dir"
    ln -sf "$script_dir/scripts/completion/bash_completion" "$completion_dir/functional-shell"
    ln -sf "$script_dir/scripts/completion/zsh_completion" "$zsh_completion_dir/_functional-shell"
    
    echo "-- Symlinks created:"
    echo "   $bin_dir/map -> $script_dir/cmd/map"
    echo "   $bin_dir/filter -> $script_dir/cmd/filter"
    echo "   $lib_dir/functional-shell -> $script_dir/lib"
    echo "   $completion_dir/functional-shell -> $script_dir/scripts/completion/bash_completion"
    echo "   $zsh_completion_dir/_functional-shell -> $script_dir/scripts/completion/zsh_completion"
    echo ""
    echo "-- Make sure $bin_dir is in your PATH:"
    echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
    echo "-- Shell completion available after restarting your shell"
}

uninstall_symlinks() {
    echo "-- Removing symlinks for integration testing..."
    
    # Remove symlinks if they exist
    [ -L "$bin_dir/map" ] && rm "$bin_dir/map" && echo "   Removed $bin_dir/map"
    [ -L "$bin_dir/filter" ] && rm "$bin_dir/filter" && echo "   Removed $bin_dir/filter"
    [ -L "$lib_dir/functional-shell" ] && rm "$lib_dir/functional-shell" && echo "   Removed $lib_dir/functional-shell"
    
    # Remove completion symlinks
    completion_dir="$HOME/.local/share/bash-completion/completions"
    zsh_completion_dir="$HOME/.local/share/zsh/site-functions"
    [ -L "$completion_dir/functional-shell" ] && rm "$completion_dir/functional-shell" && echo "   Removed $completion_dir/functional-shell"
    [ -L "$zsh_completion_dir/_functional-shell" ] && rm "$zsh_completion_dir/_functional-shell" && echo "   Removed $zsh_completion_dir/_functional-shell"
    
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