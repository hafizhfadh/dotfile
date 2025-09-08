# Cross-Platform Headless OS Configuration

A comprehensive dotfiles configuration designed for headless development environments on macOS and Fedora (including Kinoite). This setup provides a consistent development experience across different operating systems with automatic OS detection and platform-specific optimizations.

## Features

- 🔄 **Cross-Platform Compatibility**: Works seamlessly on macOS, Fedora, and Fedora Kinoite
- 🖥️ **Headless Mode Detection**: Automatically adapts to headless environments
- 📦 **Smart Package Management**: Uses appropriate package managers (Homebrew, DNF, rpm-ostree, Flatpak)
- 🐚 **Enhanced Zsh Configuration**: Oh My Zsh with plugins and cross-platform aliases
- 🛠️ **Development Tools**: Pre-configured for Node.js, Python, Go, Rust, Android, and Flutter development
- 🔧 **Terminal Applications**: WezTerm and Zellij configurations included
- 🎯 **OS-Specific Optimizations**: Platform-specific aliases and configurations

## Supported Operating Systems

- **macOS** (Intel and Apple Silicon)
- **Fedora** (Workstation)
- **Fedora Kinoite** (Immutable desktop)

## Quick Start

### Prerequisites

- Git
- Curl or wget
- Sudo access (for Linux systems)

### Installation

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url> ~/.config
   cd ~/.config
   ```

2. **Make scripts executable:**
   ```bash
   chmod +x install.sh
   chmod +x scripts/*.sh
   ```

3. **Run the installation:**
   ```bash
   ./install.sh
   ```

4. **Restart your shell or source the configuration:**
   ```bash
   source ~/.zshrc
   ```

## What Gets Installed

### Core Utilities
- Zsh with Oh My Zsh
- Git with enhanced configuration
- Modern CLI tools: `eza`, `bat`, `ripgrep`, `fd`, `zoxide`, `fzf`
- Terminal multiplexers: `tmux`, `zellij`
- System monitoring: `htop`, `neofetch`

### Development Tools
- **Node.js** with NVM
- **Python 3** with pip
- **Go** language
- **Rust** with Cargo
- **Java** OpenJDK 11
- **Docker/Podman** for containerization

### Platform-Specific Tools

#### macOS (via Homebrew)
- WezTerm terminal emulator
- Android command line tools
- Flutter SDK
- Zsh plugins via Homebrew

#### Fedora (via DNF)
- Development tools group
- Podman ecosystem
- Flatpak applications
- System development libraries

#### Fedora Kinoite (via rpm-ostree + Flatpak)
- Essential packages layered via rpm-ostree
- GUI applications via Flatpak
- Development tools in containers

## Configuration Structure

```
~/.config/
├── install.sh                 # Main installation script
├── .zshrc                     # Cross-platform Zsh configuration
├── headless.conf             # Headless-specific settings
├── scripts/
│   ├── install-macos.sh      # macOS installation script
│   ├── install-fedora.sh     # Fedora installation script
│   └── install-fedora-kinoite.sh # Kinoite installation script
├── packages/
│   ├── macos-packages.txt    # macOS package list
│   ├── fedora-packages.txt   # Fedora package list
│   └── fedora-kinoite-packages.txt # Kinoite package list
├── wezterm/
│   └── wezterm.lua          # WezTerm configuration
└── zellij/
    └── config.kdl           # Zellij configuration
```

## Environment Variables

The configuration sets several environment variables for cross-platform compatibility:

- `DOTFILES_OS`: Detected operating system (`macos`, `fedora`, `fedora-kinoite`)
- `HEADLESS_MODE`: Boolean indicating if running in headless mode
- `ANDROID_HOME`: Platform-specific Android SDK path
- Various development tool paths and settings

## Aliases and Commands

### Cross-Platform Aliases
- `ls`, `lsa`, `lt`, `lta`: Enhanced directory listing (uses `eza` or `exa` if available)
- `cd`: Replaced with `zoxide` for smart directory navigation

### OS-Specific Aliases

#### macOS
- `brewup`: Update Homebrew packages
- `flushdns`: Flush DNS cache

#### Fedora
- `update-system`: Update system packages
- `install-pkg`: Install packages
- `search-pkg`: Search for packages

#### Fedora Kinoite
- `update-system`: Update rpm-ostree and Flatpak
- `install-pkg`: Install via rpm-ostree
- `search-pkg`: Search rpm-ostree packages

## Headless Mode Features

When running in headless mode (no display server), the configuration:

- Disables GUI application aliases
- Sets appropriate terminal editors
- Optimizes for CLI-only workflows
- Provides alternative commands for GUI tools

## Development Environment Setup

### Node.js Development
- NVM for version management
- Global packages: yarn, pnpm (optional)
- Environment variables for development

### Python Development
- Python 3 with pip
- Virtual environment support
- Development libraries

### Go Development
- Latest Go version
- GOPATH and module settings
- Development tools

### Rust Development
- Rust via rustup
- Cargo package manager
- Additional CLI tools via Cargo

### Android Development
- Android SDK command line tools
- Platform tools and build tools
- Cross-platform ANDROID_HOME setup

### Flutter Development
- Flutter SDK
- Dart CLI completion
- Platform-specific installation paths

## Customization

### Local Configuration
Create `~/.zshrc.local` for machine-specific configurations that won't be overwritten:

```bash
# ~/.zshrc.local
export CUSTOM_VAR="value"
alias custom-command="some command"
```

### Package Lists
Modify the package lists in the `packages/` directory to add or remove software:

- `packages/macos-packages.txt`
- `packages/fedora-packages.txt`
- `packages/fedora-kinoite-packages.txt`

### Headless Configuration
Edit `headless.conf` to customize headless-specific settings.

## Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   chmod +x install.sh scripts/*.sh
   ```

2. **Homebrew Not Found (macOS)**
   The script will automatically install Homebrew if not present.

3. **rpm-ostree Packages Require Reboot (Kinoite)**
   After installing system packages on Kinoite, reboot to apply changes.

4. **Zsh Not Default Shell**
   ```bash
   chsh -s $(which zsh)
   ```

### Logs and Debugging

The installation scripts provide colored output:
- 🔵 **INFO**: General information
- 🟢 **SUCCESS**: Successful operations
- 🟡 **WARNING**: Warnings and important notes
- 🔴 **ERROR**: Errors and failures

## Updating

To update the configuration:

1. **Pull latest changes:**
   ```bash
   cd ~/.config
   git pull
   ```

2. **Re-run installation:**
   ```bash
   ./install.sh
   ```

3. **Restart shell:**
   ```bash
   source ~/.zshrc
   ```

## Backup and Restore

The installation script automatically backs up existing configurations:
- `.zshrc` → `.zshrc.backup`
- Other configs are preserved in their original locations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Test on multiple platforms
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/) for the excellent Zsh framework
- [Homebrew](https://brew.sh/) for macOS package management
- [Fedora Project](https://getfedora.org/) for the excellent Linux distribution
- All the maintainers of the CLI tools included in this configuration

---

**Note**: This configuration is designed for development environments. Review and customize according to your security and compliance requirements before use in production environments.