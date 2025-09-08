#!/bin/bash

# Fedora Installation Script for Headless Configuration
# Uses DNF for package management

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[Fedora]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[Fedora]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[Fedora]${NC} $1"
}

log_error() {
    echo -e "${RED}[Fedora]${NC} $1"
}

# Update system
update_system() {
    log_info "Updating system packages..."
    sudo dnf update -y
    log_success "System updated"
}

# Install essential packages
install_essentials() {
    log_info "Installing essential packages..."
    
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
        "util-linux-user"        # For chsh command
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
        sudo dnf install -y "${to_install[@]}"
    else
        log_info "All essential packages already installed"
    fi
    
    log_success "Essential packages installation completed"
}

# Install development tools
install_dev_tools() {
    log_info "Installing development tools..."
    
    # Check if Development Tools group is installed
    if ! dnf group list --installed | grep -q "Development Tools"; then
        log_info "Installing Development Tools group..."
        sudo dnf groupinstall -y "Development Tools"
    else
        log_info "Development Tools group already installed"
    fi
    
    local dev_packages=(
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
        "java-11-openjdk-devel" # Java development kit
    )
    
    # Check which packages are already installed
    local to_install=()
    for package in "${dev_packages[@]}"; do
        if ! rpm -q "$package" >/dev/null 2>&1; then
            to_install+=("$package")
        else
            log_info "$package already installed"
        fi
    done
    
    if [[ ${#to_install[@]} -gt 0 ]]; then
        log_info "Installing development packages: ${to_install[*]}"
        sudo dnf install -y "${to_install[@]}"
    else
        log_info "All development packages already installed"
    fi
    
    log_success "Development tools installation completed"
}

# Setup Flatpak
setup_flatpak() {
    log_info "Setting up Flatpak..."
    
    # Install Flatpak if not already installed
    if ! command -v flatpak >/dev/null 2>&1; then
        sudo dnf install -y flatpak
    fi
    
    # Add Flathub repository if not already added
    if ! flatpak remotes | grep -q flathub; then
        log_info "Adding Flathub repository..."
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    else
        log_info "Flathub repository already configured"
    fi
    
    log_success "Flatpak setup completed"
}

# Install terminal applications
install_terminal_apps() {
    log_info "Installing terminal applications..."
    
    # Check and install WezTerm
    if command -v wezterm >/dev/null 2>&1; then
        log_info "WezTerm already installed"
    elif rpm -q wezterm >/dev/null 2>&1; then
        log_info "WezTerm already installed via DNF"
    elif flatpak list | grep -q "org.wezfurlong.wezterm"; then
        log_info "WezTerm already installed via Flatpak"
    else
        # Try to install WezTerm from Fedora repos, fallback to Flatpak
        if ! sudo dnf install -y wezterm 2>/dev/null; then
            log_info "Installing WezTerm via Flatpak..."
            flatpak install -y flathub org.wezfurlong.wezterm
        fi
    fi
    
    # Check and install Zellij
    if command -v zellij >/dev/null 2>&1; then
        log_info "Zellij already installed"
    elif rpm -q zellij >/dev/null 2>&1; then
        log_info "Zellij already installed via DNF"
    else
        # Install Zellij
        if ! sudo dnf install -y zellij 2>/dev/null; then
            log_info "Installing Zellij via cargo..."
            if command -v cargo >/dev/null 2>&1; then
                cargo install zellij
            else
                log_warning "Could not install Zellij - cargo not available"
            fi
        fi
    fi
    
    log_success "Terminal applications installation completed"
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
            "exa"                # Better ls (if not available via dnf)
            "bat"                # Better cat (if not available via dnf)
            "ripgrep"            # Fast grep (if not available via dnf)
            "fd-find"            # Fast find (if not available via dnf)
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

# Setup Android development
setup_android_dev() {
    log_info "Setting up Android development environment..."
    
    # Install Android Studio via Flatpak
    if ! flatpak list | grep -q "com.google.AndroidStudio"; then
        log_info "Installing Android Studio..."
        flatpak install -y flathub com.google.AndroidStudio
    else
        log_info "Android Studio already installed"
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
    log_info "Starting Fedora installation..."
    
    update_system
    install_essentials
    install_dev_tools
    setup_flatpak
    install_terminal_apps
    install_oh_my_zsh
    install_zsh_plugins
    install_nvm
    install_rust
    setup_dev_environment
    setup_android_dev
    setup_flutter_dev
    
    log_success "Fedora installation completed successfully!"
}

# Run main function
main "$@"