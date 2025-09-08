#!/bin/bash

# Headless OS Configuration Installer
# Supports macOS and Fedora Kinoite

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        log_info "Detected macOS"
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        if [[ "$ID" == "fedora" ]] && [[ "$VARIANT_ID" == "kinoite" ]]; then
            OS="fedora-kinoite"
            log_info "Detected Fedora Kinoite"
        elif [[ "$ID" == "fedora" ]]; then
            OS="fedora"
            log_info "Detected Fedora"
        else
            log_error "Unsupported Linux distribution: $ID"
            exit 1
        fi
    else
        log_error "Unsupported operating system"
        exit 1
    fi
}

# Check if running in headless mode
check_headless() {
    if [[ -z "$DISPLAY" ]] && [[ -z "$WAYLAND_DISPLAY" ]] && [[ "$XDG_SESSION_TYPE" != "x11" ]] && [[ "$XDG_SESSION_TYPE" != "wayland" ]]; then
        HEADLESS=true
        log_info "Running in headless mode"
    else
        HEADLESS=false
        log_info "Running with display server"
    fi
}

# Install dependencies based on OS
install_dependencies() {
    log_info "Installing dependencies for $OS..."
    
    case $OS in
        "macos")
            ./scripts/install-macos.sh
            ;;
        "fedora-kinoite")
            ./scripts/install-fedora-kinoite.sh
            ;;
        "fedora")
            ./scripts/install-fedora.sh
            ;;
        *)
            log_error "No installation script for $OS"
            exit 1
            ;;
    esac
}

# Setup configuration files
setup_configs() {
    log_info "Setting up configuration files..."
    
    # Backup existing configs
    if [[ -f "$HOME/.zshrc" ]]; then
        log_warning "Backing up existing .zshrc to .zshrc.backup"
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
    fi
    
    # Copy new configs
    cp .zshrc "$HOME/.zshrc"
    
    # Create config directories if they don't exist
    mkdir -p "$HOME/.config"
    
    # Copy terminal configs
    if [[ -d "wezterm" ]]; then
        cp -r wezterm "$HOME/.config/"
        log_success "WezTerm configuration installed"
    fi
    
    if [[ -d "zellij" ]]; then
        cp -r zellij "$HOME/.config/"
        log_success "Zellij configuration installed"
    fi
    
    log_success "Configuration files installed"
}

# Post-installation setup
post_install() {
    log_info "Running post-installation setup..."
    
    # Source the new zshrc if we're in zsh
    if [[ "$SHELL" == *"zsh"* ]]; then
        log_info "Sourcing new .zshrc configuration"
        # Note: This won't work in the script context, user needs to restart shell
        log_warning "Please restart your shell or run 'source ~/.zshrc' to apply changes"
    fi
    
    # Set zsh as default shell if it isn't already
    if [[ "$SHELL" != *"zsh"* ]]; then
        log_info "Setting zsh as default shell"
        if command -v zsh >/dev/null 2>&1; then
            chsh -s "$(which zsh)"
            log_success "Default shell changed to zsh"
        else
            log_error "zsh not found, cannot set as default shell"
        fi
    fi
}

# Main installation function
main() {
    log_info "Starting headless OS configuration installation..."
    
    # Check if we're in the right directory
    if [[ ! -f "install.sh" ]]; then
        log_error "Please run this script from the dotfiles directory"
        exit 1
    fi
    
    detect_os
    check_headless
    
    # Create scripts directory if it doesn't exist
    mkdir -p scripts
    
    install_dependencies
    setup_configs
    post_install
    
    log_success "Installation completed successfully!"
    log_info "Please restart your shell to apply all changes"
}

# Run main function
main "$@"