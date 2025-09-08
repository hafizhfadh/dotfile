#!/bin/bash

# Fedora Kinoite Installation Script for Headless Configuration
# Uses rpm-ostree for system packages and Flatpak for applications

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[Kinoite]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[Kinoite]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[Kinoite]${NC} $1"
}

log_error() {
    echo -e "${RED}[Kinoite]${NC} $1"
}

# Check if we're running on Fedora Kinoite
check_kinoite() {
    if [[ ! -f /etc/os-release ]]; then
        log_error "Cannot detect OS release information"
        exit 1
    fi
    
    . /etc/os-release
    if [[ "$ID" != "fedora" ]] || [[ "$VARIANT_ID" != "kinoite" ]]; then
        log_error "This script is designed for Fedora Kinoite only"
        exit 1
    fi
    
    log_info "Confirmed running on Fedora Kinoite"
}

# Install essential packages via rpm-ostree
install_rpm_ostree_packages() {
    log_info "Installing essential packages via rpm-ostree..."
    
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
        "fd-find"                # Fast find alternative
        "bat"                    # Better cat
        "eza"                    # Better ls
        "zoxide"                 # Smart cd
        "fzf"                    # Fuzzy finder
        "tmux"                   # Terminal multiplexer
        "vim"                    # Text editor
        "nano"                   # Simple text editor
        "nodejs"                 # Node.js
        "npm"                    # Node package manager
        "python3"                # Python 3
        "python3-pip"            # Python package manager
        "golang"                 # Go language
        "rust"                   # Rust language
        "cargo"                  # Rust package manager
        "podman"                 # Container runtime
        "podman-compose"         # Container orchestration
        "buildah"                # Container builder
        "skopeo"                 # Container image utility
    )
    
    # Check which packages are already installed
    local to_install=()
    for package in "${packages[@]}"; do
        if ! rpm -q "$package" >/dev/null 2>&1; then
            to_install+=("$package")
        else
            log_info "$package already installed"
        fi
    done
    
    if [[ ${#to_install[@]} -gt 0 ]]; then
        log_info "Installing packages: ${to_install[*]}"
        sudo rpm-ostree install "${to_install[@]}"
        log_warning "System packages installed. Reboot required to apply changes."
    else
        log_info "All essential packages already installed"
    fi
    
    log_success "rpm-ostree package installation completed"
}

# Setup Flatpak
setup_flatpak() {
    log_info "Setting up Flatpak..."
    
    # Add Flathub repository if not already added
    if ! flatpak remotes | grep -q flathub; then
        log_info "Adding Flathub repository..."
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    else
        log_info "Flathub repository already configured"
    fi
    
    log_success "Flatpak setup completed"
}

# Install Flatpak applications
install_flatpak_apps() {
    log_info "Installing Flatpak applications..."
    
    local flatpak_apps=(
        "org.wezfurlong.wezterm"     # Terminal emulator
        "com.visualstudio.code"      # VS Code
        "org.mozilla.firefox"        # Firefox browser
        "org.libreoffice.LibreOffice" # Office suite
        "org.gimp.GIMP"              # Image editor
        "org.videolan.VLC"           # Media player
    )
    
    for app in "${flatpak_apps[@]}"; do
        if flatpak list | grep -q "$app"; then
            log_info "$app already installed"
        else
            log_info "Installing $app..."
            flatpak install -y flathub "$app"
        fi
    done
    
    log_success "Flatpak applications installed"
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
    
    local plugin_dir="$HOME/.oh-my-zsh/custom/plugins"
    
    # Install zsh-autosuggestions
    if [[ ! -d "$plugin_dir/zsh-autosuggestions" ]]; then
        log_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$plugin_dir/zsh-autosuggestions"
    else
        log_info "zsh-autosuggestions already installed"
    fi
    
    # Install zsh-syntax-highlighting
    if [[ ! -d "$plugin_dir/zsh-syntax-highlighting" ]]; then
        log_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$plugin_dir/zsh-syntax-highlighting"
    else
        log_info "zsh-syntax-highlighting already installed"
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

# Install Rust via rustup
install_rust() {
    if ! command -v rustup >/dev/null 2>&1; then
        log_info "Installing Rust via rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        log_success "Rust installed via rustup"
    else
        log_info "Rust already installed"
    fi
}

# Setup development environment
setup_dev_environment() {
    log_info "Setting up development environment..."
    
    # Create common development directories
    mkdir -p "$HOME/Development"
    mkdir -p "$HOME/.local/bin"
    
    # Install additional development tools via cargo if Rust is available
    if command -v cargo >/dev/null 2>&1; then
        local cargo_tools=(
            "exa"                # Better ls (if not available via rpm-ostree)
            "bat"                # Better cat (if not available via rpm-ostree)
            "ripgrep"            # Fast grep (if not available via rpm-ostree)
            "fd-find"            # Fast find (if not available via rpm-ostree)
        )
        
        for tool in "${cargo_tools[@]}"; do
            if ! command -v "$tool" >/dev/null 2>&1; then
                log_info "Installing $tool via cargo..."
                cargo install "$tool"
            fi
        done
    fi
    
    log_success "Development environment setup completed"
}

# Setup Android development (if needed)
setup_android_dev() {
    log_info "Setting up Android development environment..."
    
    # Install Android Studio via Flatpak
    if ! flatpak list | grep -q "com.google.AndroidStudio"; then
        log_info "Installing Android Studio..."
        flatpak install -y flathub com.google.AndroidStudio
    else
        log_info "Android Studio already installed"
    fi
    
    # Install OpenJDK
    if ! rpm -q java-11-openjdk-devel >/dev/null 2>&1; then
        log_info "Installing OpenJDK 11..."
        sudo rpm-ostree install java-11-openjdk-devel
        log_warning "OpenJDK installed. Reboot required to apply changes."
    else
        log_info "OpenJDK already installed"
    fi
    
    log_success "Android development environment setup completed"
}

# Setup Flutter development
setup_flutter_dev() {
    if [[ ! -d "$HOME/Development/flutter" ]]; then
        log_info "Installing Flutter..."
        cd "$HOME/Development"
        git clone https://github.com/flutter/flutter.git -b stable
        
        # Add Flutter to PATH in .zshrc
        echo 'export PATH="$PATH:$HOME/Development/flutter/bin"' >> "$HOME/.zshrc.local"
        
        log_success "Flutter installed"
    else
        log_info "Flutter already installed"
    fi
}

# Main installation function
main() {
    log_info "Starting Fedora Kinoite installation..."
    
    check_kinoite
    install_rpm_ostree_packages
    setup_flatpak
    install_flatpak_apps
    install_oh_my_zsh
    install_zsh_plugins
    install_nvm
    install_rust
    setup_dev_environment
    setup_android_dev
    setup_flutter_dev
    
    log_success "Fedora Kinoite installation completed successfully!"
    log_warning "If system packages were installed, please reboot to apply changes."
}

# Run main function
main "$@"