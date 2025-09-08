#!/bin/bash

# macOS Installation Script for Headless Configuration
# Uses Homebrew for package management

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[macOS]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[macOS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[macOS]${NC} $1"
}

log_error() {
    echo -e "${RED}[macOS]${NC} $1"
}

# Check if Homebrew is installed
check_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        log_info "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        
        log_success "Homebrew installed successfully"
    else
        log_info "Homebrew already installed"
        brew update
    fi
}

# Install essential packages
install_essentials() {
    log_info "Installing essential packages..."
    
    # Core utilities
    local packages=(
        "zsh"                    # Z shell
        "git"                    # Version control
        "curl"                   # HTTP client
        "wget"                   # File downloader
        "tree"                   # Directory tree viewer
        "htop"                   # Process viewer
        "neofetch"               # System info
        "jq"                     # JSON processor
        "ripgrep"                # Fast grep alternative
        "fd"                     # Fast find alternative
        "bat"                    # Better cat
        "eza"                    # Better ls
        "zoxide"                 # Smart cd
        "fzf"                    # Fuzzy finder
        "tmux"                   # Terminal multiplexer
        "vim"                    # Text editor
        "nano"                   # Simple text editor
    )
    
    for package in "${packages[@]}"; do
        if brew list "$package" >/dev/null 2>&1; then
            log_info "$package already installed"
        else
            log_info "Installing $package..."
            brew install "$package"
        fi
    done
    
    log_success "Essential packages installed"
}

# Install development tools
install_dev_tools() {
    log_info "Installing development tools..."
    
    local dev_packages=(
        "node"                   # Node.js
        "python@3.11"           # Python 3.11
        "go"                     # Go language
        "rust"                   # Rust language
        "docker"                 # Containerization
        "docker-compose"         # Docker orchestration
    )
    
    for package in "${dev_packages[@]}"; do
        if brew list "$package" >/dev/null 2>&1; then
            log_info "$package already installed"
        else
            log_info "Installing $package..."
            brew install "$package"
        fi
    done
    
    log_success "Development tools installed"
}

# Install terminal applications
install_terminal_apps() {
    log_info "Installing terminal applications..."
    
    local terminal_apps=(
        "wezterm"                # Terminal emulator
        "zellij"                 # Terminal workspace
    )
    
    for app in "${terminal_apps[@]}"; do
        if brew list --cask "$app" >/dev/null 2>&1 || brew list "$app" >/dev/null 2>&1; then
            log_info "$app already installed"
        else
            log_info "Installing $app..."
            # Try as cask first, then as formula
            if ! brew install --cask "$app" 2>/dev/null; then
                brew install "$app"
            fi
        fi
    done
    
    log_success "Terminal applications installed"
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh My Zsh installed"
    else
        log_info "Oh My Zsh already installed"
    fi
}

# Install Zsh plugins
install_zsh_plugins() {
    log_info "Installing Zsh plugins..."
    
    # Install zsh-autosuggestions
    if ! brew list zsh-autosuggestions >/dev/null 2>&1; then
        brew install zsh-autosuggestions
    fi
    
    # Install zsh-syntax-highlighting
    if ! brew list zsh-syntax-highlighting >/dev/null 2>&1; then
        brew install zsh-syntax-highlighting
    fi
    
    log_success "Zsh plugins installed"
}

# Install NVM (Node Version Manager)
install_nvm() {
    if [[ ! -d "$HOME/.nvm" ]]; then
        log_info "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        log_success "NVM installed"
    else
        log_info "NVM already installed"
    fi
}

# Setup Android development (if needed)
setup_android_dev() {
    log_info "Setting up Android development environment..."
    
    # Install Android SDK command line tools
    if ! brew list --cask android-commandlinetools >/dev/null 2>&1; then
        log_info "Installing Android command line tools..."
        brew install --cask android-commandlinetools
    fi
    
    # Install Java (required for Android development)
    if ! brew list openjdk@11 >/dev/null 2>&1; then
        log_info "Installing OpenJDK 11..."
        brew install openjdk@11
    fi
    
    log_success "Android development environment setup completed"
}

# Setup Flutter development
setup_flutter_dev() {
    if ! command -v flutter >/dev/null 2>&1; then
        log_info "Installing Flutter..."
        brew install --cask flutter
        log_success "Flutter installed"
    else
        log_info "Flutter already installed"
    fi
}

# Main installation function
main() {
    log_info "Starting macOS installation..."
    
    check_homebrew
    install_essentials
    install_dev_tools
    install_terminal_apps
    install_oh_my_zsh
    install_zsh_plugins
    install_nvm
    setup_android_dev
    setup_flutter_dev
    
    log_success "macOS installation completed successfully!"
}

# Run main function
main "$@"