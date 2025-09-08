# Cross-Platform Dotfiles Configuration
# Supports macOS, Fedora, and Fedora Kinoite

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# ---- OS Detection ----
if [[ "$OSTYPE" == "darwin"* ]]; then
    export DOTFILES_OS="macos"
elif [[ -f /etc/os-release ]]; then
    . /etc/os-release
    if [[ "$ID" == "fedora" ]] && [[ "$VARIANT_ID" == "kinoite" ]]; then
        export DOTFILES_OS="fedora-kinoite"
    elif [[ "$ID" == "fedora" ]]; then
        export DOTFILES_OS="fedora"
    else
        export DOTFILES_OS="linux"
    fi
else
    export DOTFILES_OS="unknown"
fi

# ---- Zellij ----
eval "$(zellij setup --generate-auto-start zsh)"

# ---- Package Manager Setup ----
if [[ "$DOTFILES_OS" == "macos" ]]; then
    # HOMEBREW (macOS)
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ---- Sail ----
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"
alias cd="z"

# ---- Better ls (Cross-Platform) -----
# Note: Actual aliases are set at the end of this file based on available tools

# ---- NVM ----
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# ---- Android Configuration (Cross-Platform) ----
if [[ "$DOTFILES_OS" == "macos" ]]; then
    export ANDROID_HOME=$HOME/Library/Android/sdk
elif [[ "$DOTFILES_OS" == "fedora"* ]]; then
    export ANDROID_HOME=$HOME/Android/Sdk
else
    export ANDROID_HOME=$HOME/Android/Sdk
fi

if [[ -d "$ANDROID_HOME" ]]; then
    PATH=$PATH:$ANDROID_HOME/build-tools
    PATH=$PATH:$ANDROID_HOME/platform-tools
    PATH=$PATH:$ANDROID_HOME/tools
    PATH=$PATH:$ANDROID_HOME/tools/bin/
fi

# ---- FlutterFire ----
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# History Setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# Auto Completion
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# ---- Zsh Plugins (Cross-Platform) ----
if [[ "$DOTFILES_OS" == "macos" ]]; then
    # macOS Homebrew paths
    [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ "$DOTFILES_OS" == "fedora"* ]]; then
    # Fedora/Kinoite Oh My Zsh custom plugins
    [[ -f $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    [[ -f $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f $HOME/.dart-cli-completion/zsh-config.zsh ]] && . $HOME/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

# ---- Local OS-Specific Configuration ----
# Load local configuration file if it exists
[[ -f $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

# ---- Cross-Platform Aliases ----
# Override ls alias based on available tools
if command -v eza >/dev/null 2>&1; then
    alias ls='eza -lh --group-directories-first --icons'
    alias lsa='eza -lha --group-directories-first --icons'
    alias lt='eza --tree --level=2 --long --icons --git'
    alias lta='eza --tree --level=2 --long --icons --git -a'
elif command -v exa >/dev/null 2>&1; then
    alias ls='exa -lh --group-directories-first --icons'
    alias lsa='exa -lha --group-directories-first --icons'
    alias lt='exa --tree --level=2 --long --icons --git'
    alias lta='exa --tree --level=2 --long --icons --git -a'
else
    alias ls='ls -lh --color=auto'
    alias lsa='ls -lha --color=auto'
fi

# ---- Headless Mode Detection ----
if [[ -z "$DISPLAY" ]] && [[ -z "$WAYLAND_DISPLAY" ]] && [[ "$XDG_SESSION_TYPE" != "x11" ]] && [[ "$XDG_SESSION_TYPE" != "wayland" ]]; then
    export HEADLESS_MODE=true
    # Disable GUI applications in headless mode
    alias code='echo "GUI applications not available in headless mode"'
else
    export HEADLESS_MODE=false
fi

# ---- OS-Specific Aliases ----
if [[ "$DOTFILES_OS" == "macos" ]]; then
    # macOS specific aliases
    alias brewup='brew update && brew upgrade && brew cleanup'
    alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
elif [[ "$DOTFILES_OS" == "fedora-kinoite" ]]; then
    # Fedora Kinoite specific aliases
    alias update-system='rpm-ostree upgrade && flatpak update'
    alias install-pkg='rpm-ostree install'
    alias search-pkg='rpm-ostree search'
elif [[ "$DOTFILES_OS" == "fedora" ]]; then
    # Fedora specific aliases
    alias update-system='sudo dnf update && flatpak update'
    alias install-pkg='sudo dnf install'
    alias search-pkg='dnf search'
fi
