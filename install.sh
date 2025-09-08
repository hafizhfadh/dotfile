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
    
    # Create config directories if they don't exist
    mkdir -p "$HOME/.config"
    
    # Setup .zshrc
    setup_zshrc
    
    # Setup terminal configurations
    setup_terminal_configs
    
    log_success "Configuration files installed"
}

# Setup .zshrc with proper backup and validation
setup_zshrc() {
    log_info "Setting up .zshrc configuration..."
    
    # Validate source file exists
    if [[ ! -f ".zshrc" ]]; then
        log_error "Source .zshrc file not found in current directory"
        return 1
    fi
    
    # Backup existing .zshrc with timestamp
    if [[ -f "$HOME/.zshrc" ]]; then
        local backup_file="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        log_warning "Backing up existing .zshrc to $backup_file"
        if ! cp "$HOME/.zshrc" "$backup_file"; then
            log_error "Failed to backup existing .zshrc"
            return 1
        fi
    fi
    
    # Copy new .zshrc
    if cp ".zshrc" "$HOME/.zshrc"; then
        log_success ".zshrc configuration installed"
    else
        log_error "Failed to install .zshrc configuration"
        return 1
    fi
}

# Setup terminal configurations (WezTerm and Zellij)
setup_terminal_configs() {
    log_info "Setting up terminal configurations..."
    
    # Setup WezTerm configuration
    if [[ -d "wezterm" ]]; then
        setup_wezterm_config
    else
        log_warning "WezTerm configuration directory not found, skipping"
    fi
    
    # Setup Zellij configuration
    if [[ -d "zellij" ]]; then
        setup_zellij_config
    else
        log_warning "Zellij configuration directory not found, skipping"
    fi
}

# Setup WezTerm configuration with validation
setup_wezterm_config() {
    log_info "Installing WezTerm configuration..."
    
    local wezterm_config_dir="$HOME/.config/wezterm"
    
    # Validate source configuration
    if [[ ! -f "wezterm/wezterm.lua" ]]; then
        log_error "WezTerm configuration file (wezterm.lua) not found"
        return 1
    fi
    
    # Backup existing WezTerm config
    if [[ -d "$wezterm_config_dir" ]]; then
        local backup_dir="$wezterm_config_dir.backup.$(date +%Y%m%d_%H%M%S)"
        log_warning "Backing up existing WezTerm config to $backup_dir"
        if ! mv "$wezterm_config_dir" "$backup_dir"; then
            log_error "Failed to backup existing WezTerm configuration"
            return 1
        fi
    fi
    
    # Copy WezTerm configuration
    if cp -r "wezterm" "$HOME/.config/"; then
        log_success "WezTerm configuration installed"
        
        # Apply platform-specific adjustments
        apply_wezterm_platform_adjustments "$wezterm_config_dir/wezterm.lua"
        
        # Validate the installed configuration
        if command -v wezterm >/dev/null 2>&1; then
            if wezterm --config-file="$wezterm_config_dir/wezterm.lua" --version >/dev/null 2>&1; then
                log_success "WezTerm configuration validated successfully"
            else
                log_warning "WezTerm configuration may have syntax errors"
            fi
        fi
    else
        log_error "Failed to install WezTerm configuration"
        return 1
    fi
}

# Apply platform-specific adjustments to WezTerm config
apply_wezterm_platform_adjustments() {
    local config_file="$1"
    
    if [[ ! -f "$config_file" ]]; then
        log_error "WezTerm config file not found: $config_file"
        return 1
    fi
    
    case "$OS" in
        "macos")
            log_info "Applying macOS-specific WezTerm settings"
            # macOS settings are already in the base config
            ;;
        "fedora"*)
            log_info "Applying Linux-specific WezTerm settings"
            # Disable macOS-specific settings for Linux
            sed -i 's/config.macos_window_background_blur = 15/-- config.macos_window_background_blur = 15 -- macOS only/' "$config_file"
            
            # Add Linux-specific font fallbacks if needed
            if ! grep -q "font_dirs" "$config_file"; then
                sed -i '/config.font = wezterm.font/a\
-- Linux font directories\nconfig.font_dirs = { "/usr/share/fonts", "/usr/local/share/fonts", "~/.local/share/fonts" }' "$config_file"
            fi
            ;;
        *)
            log_warning "Unknown OS: $OS, using default WezTerm configuration"
            ;;
    esac
}

# Setup Zellij configuration with validation
setup_zellij_config() {
    log_info "Installing Zellij configuration..."
    
    local zellij_config_dir="$HOME/.config/zellij"
    
    # Validate source configuration
    if [[ ! -f "zellij/config.kdl" ]]; then
        log_error "Zellij configuration file (config.kdl) not found"
        return 1
    fi
    
    # Backup existing Zellij config
    if [[ -d "$zellij_config_dir" ]]; then
        local backup_dir="$zellij_config_dir.backup.$(date +%Y%m%d_%H%M%S)"
        log_warning "Backing up existing Zellij config to $backup_dir"
        if ! mv "$zellij_config_dir" "$backup_dir"; then
            log_error "Failed to backup existing Zellij configuration"
            return 1
        fi
    fi
    
    # Copy Zellij configuration
    if cp -r "zellij" "$HOME/.config/"; then
        log_success "Zellij configuration installed"
        
        # Apply platform-specific adjustments
        apply_zellij_platform_adjustments "$zellij_config_dir/config.kdl"
        
        # Validate the installed configuration
        if command -v zellij >/dev/null 2>&1; then
            # Test config syntax by running zellij setup with the config
            if zellij setup --check >/dev/null 2>&1; then
                log_success "Zellij configuration validated successfully"
            else
                log_warning "Zellij configuration may have syntax errors"
            fi
        fi
    else
        log_error "Failed to install Zellij configuration"
        return 1
    fi
}

# Apply platform-specific adjustments to Zellij config
apply_zellij_platform_adjustments() {
    local config_file="$1"
    
    if [[ ! -f "$config_file" ]]; then
        log_error "Zellij config file not found: $config_file"
        return 1
    fi
    
    case "$OS" in
        "macos")
            log_info "Applying macOS-specific Zellij settings"
            # Enable pbcopy for macOS
            if ! grep -q "copy_command" "$config_file"; then
                echo '' >> "$config_file"
                echo '// macOS copy command' >> "$config_file"
                echo 'copy_command "pbcopy"' >> "$config_file"
            fi
            ;;
        "fedora"*)
            log_info "Applying Linux-specific Zellij settings"
            # Check for available copy commands and configure accordingly
            if command -v wl-copy >/dev/null 2>&1; then
                # Wayland
                if ! grep -q "copy_command" "$config_file"; then
                    echo '' >> "$config_file"
                    echo '// Wayland copy command' >> "$config_file"
                    echo 'copy_command "wl-copy"' >> "$config_file"
                fi
            elif command -v xclip >/dev/null 2>&1; then
                # X11
                if ! grep -q "copy_command" "$config_file"; then
                    echo '' >> "$config_file"
                    echo '// X11 copy command' >> "$config_file"
                    echo 'copy_command "xclip -selection clipboard"' >> "$config_file"
                fi
            else
                log_warning "No suitable copy command found for clipboard integration"
            fi
            ;;
        *)
            log_warning "Unknown OS: $OS, using default Zellij configuration"
            ;;
    esac
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