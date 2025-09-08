#!/bin/bash

# Simple test script for config setup functionality
# This script validates the config functions without running full installation

echo "=== Testing Config Setup Functions ==="

# Test 1: Check if config files exist
echo "\n1. Checking config file existence:"
if [[ -f ".zshrc" ]]; then
    echo "✓ .zshrc found"
else
    echo "✗ .zshrc not found"
fi

if [[ -d "wezterm" ]] && [[ -f "wezterm/wezterm.lua" ]]; then
    echo "✓ WezTerm config found"
else
    echo "✗ WezTerm config not found"
fi

if [[ -d "zellij" ]] && [[ -f "zellij/config.kdl" ]]; then
    echo "✓ Zellij config found"
else
    echo "✗ Zellij config not found"
fi

# Test 2: Check function definitions in install.sh
echo "\n2. Checking function definitions:"
functions_to_check=("setup_configs" "setup_zshrc" "setup_terminal_configs" "setup_wezterm_config" "setup_zellij_config" "apply_wezterm_platform_adjustments" "apply_zellij_platform_adjustments")

for func in "${functions_to_check[@]}"; do
    if grep -q "^$func()" install.sh; then
        echo "✓ Function $func defined"
    else
        echo "✗ Function $func not found"
    fi
done

# Test 3: Syntax check
echo "\n3. Syntax validation:"
if bash -n install.sh; then
    echo "✓ install.sh syntax is valid"
else
    echo "✗ install.sh has syntax errors"
fi

# Test 4: Check OS detection
echo "\n4. OS Detection test:"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "✓ Detected macOS"
elif [[ -f /etc/os-release ]]; then
    . /etc/os-release
    if [[ "$ID" == "fedora" ]] && [[ "$VARIANT_ID" == "kinoite" ]]; then
        echo "✓ Detected Fedora Kinoite"
    elif [[ "$ID" == "fedora" ]]; then
        echo "✓ Detected Fedora"
    else
        echo "✓ Detected Linux ($ID)"
    fi
else
    echo "? Unknown OS detected"
fi

echo "\n=== Config Setup Test Complete ==="