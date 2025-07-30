#!/usr/bin/env bash

#
# Functional Shell Installer
#
# Install map and filter commands with functional programming operations.
# By default installs to ~/.local (no sudo required).
# Use --system for system-wide installation to /usr/local.
#

set -euo pipefail

readonly tmp_dir="/tmp/functional-shell"
readonly repo_url="https://github.com/simeg/functional-shell"

# Default installation directories (user-local)
install_bin_dir="$HOME/.local/bin"
install_lib_dir="$HOME/.local/lib/functional-shell"
USE_SUDO=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --system)
            install_bin_dir="/usr/local/bin"
            install_lib_dir="/usr/local/lib/functional-shell"
            shift
            ;;
        --prefix=*)
            prefix="${1#*=}"
            install_bin_dir="$prefix/bin"
            install_lib_dir="$prefix/lib/functional-shell"
            shift
            ;;
        --help|-h)
            echo "Functional Shell Installer"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --system           Install system-wide to /usr/local (requires sudo)"
            echo "  --prefix=PATH      Install to custom prefix (PATH/bin, PATH/lib)"
            echo "  --help, -h         Show this help message"
            echo ""
            echo "Default: Installs to ~/.local (no sudo required)"
            echo "Make sure ~/.local/bin is in your PATH:"
            echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            echo "Use --help for usage information" >&2
            exit 1
            ;;
    esac
done

# Check if we need sudo for installation
check_permissions() {
    if [[ ! -w "$(dirname "$install_bin_dir")" ]] || [[ ! -w "$(dirname "$install_lib_dir")" ]]; then
        if command -v sudo >/dev/null 2>&1; then
            echo "-- Root permissions required for installation to $install_bin_dir"
            echo "-- Will use sudo for installation"
            USE_SUDO="sudo"
        else
            echo "-- Error: No write permissions to $install_bin_dir and sudo not available" >&2
            exit 1
        fi
    fi
}

echo "-- Cloning repo..."

git clone "${repo_url}" "${tmp_dir}"

echo "-- Repo cloned!"

check_permissions

echo "-- Installing to $install_bin_dir and $install_lib_dir..."

# Create directories
${USE_SUDO} mkdir -p "$install_bin_dir" "$install_lib_dir"

# Install executables
${USE_SUDO} cp -f "${tmp_dir}/cmd/map" "$install_bin_dir/"
${USE_SUDO} cp -f "${tmp_dir}/cmd/filter" "$install_bin_dir/"

# Install VERSION file for version detection
if [ -f "${tmp_dir}/VERSION" ]; then
    ${USE_SUDO} cp -f "${tmp_dir}/VERSION" "$install_lib_dir/"
fi

# Install libraries
${USE_SUDO} cp -rf "${tmp_dir}/lib/core" "${tmp_dir}/lib/operations" "$install_lib_dir/"

# Install shell completions
install_completions() {
    echo "-- Installing shell completions..."

    # Determine completion directories
    if [[ "$install_bin_dir" == "$HOME/.local/bin" ]]; then
        # User-local completion directories
        bash_completion_dir="$HOME/.local/share/bash-completion/completions"
        zsh_completion_dir="$HOME/.local/share/zsh/site-functions"
    else
        # System-wide completion directories
        bash_completion_dir="/usr/share/bash-completion/completions"
        zsh_completion_dir="/usr/share/zsh/site-functions"
    fi

    # Install bash completion
    ${USE_SUDO} mkdir -p "$bash_completion_dir"
    ${USE_SUDO} cp "${tmp_dir}/scripts/completion/bash_completion" "$bash_completion_dir/functional-shell"
    echo "   Installed bash completion to $bash_completion_dir/functional-shell"

    # Install zsh completion
    ${USE_SUDO} mkdir -p "$zsh_completion_dir"
    ${USE_SUDO} cp "${tmp_dir}/scripts/completion/zsh_completion" "$zsh_completion_dir/_functional-shell"
    echo "   Installed zsh completion to $zsh_completion_dir/_functional-shell"
}

install_completions

# Create installation manifest for uninstall
create_manifest() {
    cat > "${tmp_dir}/install_manifest" << EOF
# Functional Shell Installation Manifest
# Generated on $(date)
# Installation directories:
BIN_DIR=$install_bin_dir
LIB_DIR=$install_lib_dir

# Installed files:
$install_bin_dir/map
$install_bin_dir/filter
$install_lib_dir/VERSION
EOF

    # Add all library files to manifest
    find "${tmp_dir}/lib/core" "${tmp_dir}/lib/operations" -type f | sed "s|${tmp_dir}/lib|$install_lib_dir|" >> "${tmp_dir}/install_manifest"

    # Add completion files to manifest
    if [[ "$install_bin_dir" == "$HOME/.local/bin" ]]; then
        echo "$HOME/.local/share/bash-completion/completions/functional-shell" >> "${tmp_dir}/install_manifest"
        echo "$HOME/.local/share/zsh/site-functions/_functional-shell" >> "${tmp_dir}/install_manifest"
    else
        echo "/usr/share/bash-completion/completions/functional-shell" >> "${tmp_dir}/install_manifest"
        echo "/usr/share/zsh/site-functions/_functional-shell" >> "${tmp_dir}/install_manifest"
    fi
}

create_manifest

# Install manifest
${USE_SUDO} cp "${tmp_dir}/install_manifest" "$install_lib_dir/install_manifest"

echo "-- Cleaning up temp files..."
rm -rf ${tmp_dir}

echo "-- Installation complete!"
echo ""
if [[ "$install_bin_dir" == "$HOME/.local/bin" ]]; then
    echo "-- Add ~/.local/bin to your PATH if not already done:"
    echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
    echo "-- Shell completion installed to user directories."
    echo "   For bash: Restart your shell or run 'source ~/.bashrc'"
    echo "   For zsh: Make sure ~/.local/share/zsh/site-functions is in your fpath"
    echo ""
else
    echo "-- Shell completion installed system-wide."
    echo "   Restart your shell to enable tab completion."
    echo ""
fi
echo "-- Test the installation:"
echo "   echo 'hello world' | map to_upper"
echo "   find . -name '*.txt' | filter is_file"
echo "   map <TAB>  # Try tab completion"
echo ""
echo "-- To uninstall, run:"
echo "   curl -fsSL https://raw.githubusercontent.com/simeg/functional-shell/master/scripts/uninstall.sh | bash"
