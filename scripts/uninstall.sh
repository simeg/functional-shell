#!/usr/bin/env bash

#
# Functional Shell Uninstaller
#
# Removes all files installed by the functional-shell installer.
#

set -euo pipefail

# Find installation manifest
find_manifest() {
    local manifest_paths=(
        "$HOME/.local/lib/functional-shell/install_manifest"
        "/usr/local/lib/functional-shell/install_manifest"
    )
    
    for path in "${manifest_paths[@]}"; do
        if [[ -f "$path" ]]; then
            echo "$path"
            return 0
        fi
    done
    
    return 1
}

# Parse manifest and remove files
remove_files() {
    local manifest="$1"
    local use_sudo=""
    
    echo "-- Found installation manifest: $manifest"
    
    # Check if we need sudo
    local lib_dir
    lib_dir=$(grep "^LIB_DIR=" "$manifest" | cut -d'=' -f2)
    
    if [[ ! -w "$(dirname "$lib_dir")" ]]; then
        if command -v sudo >/dev/null 2>&1; then
            echo "-- Root permissions required for uninstallation"
            echo "-- Will use sudo for removal"
            use_sudo="sudo"
        else
            echo "-- Error: No write permissions and sudo not available" >&2
            exit 1
        fi
    fi
    
    echo "-- Removing installed files..."
    
    # Remove files listed in manifest (skip comments and variable assignments)
    while IFS= read -r line; do
        if [[ "$line" =~ ^[^#] ]] && [[ "$line" =~ ^/ ]]; then
            if [[ -f "$line" ]]; then
                echo "   Removing: $line"
                $use_sudo rm -f "$line"
            elif [[ -d "$line" ]]; then
                echo "   Removing directory: $line"
                $use_sudo rm -rf "$line"
            fi
        fi
    done < "$manifest"
    
    # Remove the manifest and containing directory if empty
    echo "   Removing: $manifest"
    $use_sudo rm -f "$manifest"
    
    # Try to remove lib directory if empty
    if [[ -d "$lib_dir" ]]; then
        $use_sudo rmdir "$lib_dir" 2>/dev/null || true
    fi
}

echo "-- Functional Shell Uninstaller"
echo ""

# Try to find installation manifest
if manifest=$(find_manifest); then
    remove_files "$manifest"
    echo "-- Uninstallation complete!"
    echo ""
    echo "-- You may want to remove ~/.local/bin from your PATH if no longer needed"
else
    echo "-- No installation manifest found."
    echo "-- Attempting manual cleanup..."
    
    # Manual cleanup for legacy installations or if manifest is missing
    removed_any=false
    
    for bin_dir in "$HOME/.local/bin" "/usr/local/bin"; do
        for cmd in "map" "filter"; do
            if [[ -f "$bin_dir/$cmd" ]]; then
                echo "   Found and removing: $bin_dir/$cmd"
                if [[ -w "$bin_dir" ]]; then
                    rm -f "$bin_dir/$cmd"
                else
                    sudo rm -f "$bin_dir/$cmd"
                fi
                removed_any=true
            fi
        done
    done
    
    for lib_dir in "$HOME/.local/lib/functional-shell" "/usr/local/lib/functional-shell" "/usr/local/lib/fs"; do
        if [[ -d "$lib_dir" ]]; then
            echo "   Found and removing: $lib_dir"
            if [[ -w "$(dirname "$lib_dir")" ]]; then
                rm -rf "$lib_dir"
            else
                sudo rm -rf "$lib_dir"
            fi
            removed_any=true
        fi
    done
    
    # Remove completion files
    for completion_file in \
        "$HOME/.local/share/bash-completion/completions/functional-shell" \
        "/usr/share/bash-completion/completions/functional-shell" \
        "$HOME/.local/share/zsh/site-functions/_functional-shell" \
        "/usr/share/zsh/site-functions/_functional-shell"; do
        if [[ -f "$completion_file" ]]; then
            echo "   Found and removing: $completion_file"
            if [[ -w "$(dirname "$completion_file")" ]]; then
                rm -f "$completion_file"
            else
                sudo rm -f "$completion_file"
            fi
            removed_any=true
        fi
    done
    
    if [[ "$removed_any" == "true" ]]; then
        echo "-- Manual cleanup complete!"
    else
        echo "-- No functional-shell installation found."
    fi
fi