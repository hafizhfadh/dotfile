# Zellij Installation Setup

This document outlines the comprehensive Zellij installation and configuration setup implemented across all platforms in this dotfiles project.

## Overview

Zellij is a terminal workspace manager that provides session management, pane splitting, and tab functionality. This project includes complete installation and configuration for:

- **macOS** (via Homebrew)
- **Fedora** (via DNF with cargo fallback)
- **Fedora Kinoite** (via rpm-ostree with cargo fallback)

## Installation Methods by Platform

### macOS (`scripts/install-macos.sh`)
- Primary: Homebrew cask installation
- Fallback: Homebrew formula installation
- Function: `install_terminal_apps()`

### Fedora (`scripts/install-fedora.sh`)
- Primary: DNF package installation
- Fallback: Cargo installation (if Rust is available)
- Function: `install_terminal_apps()`

### Fedora Kinoite (`scripts/install-fedora-kinoite.sh`)
- Primary: rpm-ostree package installation (requires reboot)
- Fallback: Cargo installation (if Rust is available)
- Function: `install_terminal_apps()`
- Package included in base rpm-ostree packages list

## Configuration Management

### Configuration Files
- **Location**: `zellij/config.kdl`
- **Target**: `~/.config/zellij/config.kdl`
- **Backup**: Automatic timestamped backups of existing configs

### Platform-Specific Adjustments

#### macOS
- Copy command: `pbcopy`
- Applied automatically during config installation

#### Linux (Fedora/Kinoite)
- Wayland: `wl-copy` (preferred)
- X11: `xclip -selection clipboard` (fallback)
- Auto-detection based on available commands

### Shell Integration

#### Auto-start Setup
- **File**: `.zshrc`
- **Command**: `eval "$(zellij setup --generate-auto-start zsh)"`
- **Behavior**: Automatically starts Zellij session when opening terminal

#### Configuration Validation
- Syntax checking via `zellij setup --check`
- Automatic validation after config installation
- Graceful handling of validation failures

## Installation Flow

1. **Package Installation**
   - Platform-specific package manager installation
   - Intelligent fallback to cargo if package unavailable
   - Duplicate installation prevention

2. **Configuration Setup** (via `install.sh`)
   - Backup existing configuration
   - Copy new configuration files
   - Apply platform-specific adjustments
   - Validate configuration syntax

3. **Shell Integration**
   - Auto-start setup in `.zshrc`
   - Cross-platform compatibility

## Key Features

### Smart Installation Detection
- Checks for existing installations via multiple methods:
  - Command availability (`command -v zellij`)
  - Package manager records (`rpm -q`, `brew list`)
  - Flatpak installations (where applicable)

### Robust Error Handling
- Graceful fallbacks when primary installation fails
- Detailed logging for troubleshooting
- Non-blocking failures with helpful guidance

### Cross-Platform Consistency
- Unified configuration across all platforms
- Platform-specific optimizations
- Consistent user experience

## Usage

### Manual Installation
```bash
# Run platform-specific script
./scripts/install-fedora-kinoite.sh  # For Kinoite
./scripts/install-fedora.sh          # For Fedora
./scripts/install-macos.sh           # For macOS

# Setup configurations
./install.sh
```

### Verification
```bash
# Check installation
command -v zellij

# Validate configuration
zellij setup --check

# Test auto-start (restart shell)
exec zsh
```

## Troubleshooting

### Common Issues

1. **Kinoite: Package conflicts**
   - Solution: Reboot after rpm-ostree installation
   - Fallback: Use cargo installation

2. **Configuration validation fails**
   - Check: `~/.config/zellij/config.kdl` syntax
   - Restore: Use timestamped backup files

3. **Auto-start not working**
   - Verify: `.zshrc` contains auto-start command
   - Restart: Shell session or terminal

### Manual Recovery
```bash
# Reinstall configuration
cp -r zellij ~/.config/

# Restore from backup
cp ~/.config/zellij.backup.YYYYMMDD_HHMMSS ~/.config/zellij

# Reset auto-start
zellij setup --generate-auto-start zsh >> ~/.zshrc
```

## Integration with Project

Zellij installation is fully integrated into the main installation workflow:

- **Dependencies**: Installed before configuration setup
- **Configuration**: Handled by enhanced config management system
- **Testing**: Included in configuration validation tests
- **Documentation**: This comprehensive setup guide

The setup ensures Zellij is properly installed and configured across all supported platforms with robust error handling and platform-specific optimizations.