#!/usr/bin/env bash

#
# Script to update the expected SHA256 hash in install.sh
# This should be run whenever the repository content changes
#

set -euo pipefail

readonly install_script="install.sh"

# Check if install.sh exists
if [[ ! -f "$install_script" ]]; then
    echo "Error: $install_script not found in current directory" >&2
    exit 1
fi

# Calculate current repository SHA256
echo "-- Calculating current repository SHA256..."
current_sha256=$(git ls-tree HEAD | sha256sum | cut -d' ' -f1)

if [[ -z "$current_sha256" ]]; then
    echo "Error: Failed to calculate SHA256" >&2
    exit 1
fi

echo "-- Current SHA256: $current_sha256"

# Create backup of install.sh
cp "$install_script" "${install_script}.backup"
echo "-- Created backup: ${install_script}.backup"

# Update the SHA256 in install.sh
if sed -i.tmp "s/readonly expected_sha256=\"[^\"]*\"/readonly expected_sha256=\"$current_sha256\"/" "$install_script"; then
    rm "${install_script}.tmp" 2>/dev/null || true
    echo "-- Updated $install_script with new SHA256"
    
    # Show the change
    echo "-- Verification:"
    grep "readonly expected_sha256" "$install_script"
    
    echo "-- SHA256 update completed successfully!"
    echo "-- Don't forget to commit this change"
else
    echo "Error: Failed to update $install_script" >&2
    # Restore from backup
    mv "${install_script}.backup" "$install_script"
    echo "-- Restored from backup"
    exit 1
fi

# Clean up backup on success
rm "${install_script}.backup"