# ==========================================
# ZSH Configuration for NixOS + Niri
# ==========================================
# STATUS: AVAILABLE BUT NOT DEFAULT
# 
# This config is preserved as a fallback option. The system defaults to bash
# with ble.sh for better vim mode support. To switch to zsh:
#
# 1. In configuration.nix, change:
#      users.users.jon.shell = pkgs.zsh;
#    (and uncomment the zsh programs section)
#
# 2. Rebuild: sudo nixos-rebuild switch --flake .#achilles
#
# 3. Stow zsh dotfiles: cd ~/nixos-dotfiles && stow zsh
#
# WHY BASH OVER ZSH?
# - ble.sh provides superior vim mode (text objects, visual block, macros, registers)
# - Faster startup (~100ms vs ~300ms with oh-my-zsh)
# - Universal script compatibility
# - With fd, fzf, zoxide, yazi - zsh's advanced globbing isn't needed
#
# WHAT ZSH HAS THAT BASH DOESN'T:
# - Better tab completion (contextual flag completion)
# - Advanced globbing (**/*.ts, recursive patterns)
# - Spelling correction
# - If you need these, switch back to zsh!
# ==========================================

# ==========================================
# OH-MY-ZSH Setup (COMMENTED OUT - using standalone plugins instead)
# ==========================================
# Uncomment this section if you want to use oh-my-zsh instead of standalone plugins.
# Note: OMZ adds ~200ms to shell startup time.
#
# # NixOS installs oh-my-zsh system-wide; fallback to ~/.oh-my-zsh for non-NixOS
# if [[ -d /run/current-system/sw/share/oh-my-zsh ]]; then
#   export ZSH="/run/current-system/sw/share/oh-my-zsh"
# else
#   export ZSH="$HOME/.oh-my-zsh"
# fi
#
# # Theme: Using starship instead (installed via Nix)
# ZSH_THEME=""
#
# # Correction
# ENABLE_CORRECTION="true"
#
# # Plugins (requires programs.zsh.ohMyZsh in configuration.nix)
# plugins=(
#   git
#   you-should-use
#   kubectl
#   zsh-syntax-highlighting
#   zsh-autosuggestions
# )
#
# # Dracula syntax highlighting colors (must be before sourcing oh-my-zsh)
# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
# typeset -gA ZSH_HIGHLIGHT_STYLES
# ZSH_HIGHLIGHT_STYLES[comment]='fg=#6272A4'
# ZSH_HIGHLIGHT_STYLES[alias]='fg=#50FA7B'
# ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#50FA7B'
# ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#50FA7B'
# ZSH_HIGHLIGHT_STYLES[function]='fg=#50FA7B'
# ZSH_HIGHLIGHT_STYLES[command]='fg=#50FA7B'
# ZSH_HIGHLIGHT_STYLES[precommand]='fg=#50FA7B,italic'
# ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#FFB86C,italic'
# ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#FFB86C'
# ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#FFB86C'
# ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#BD93F9'
# ZSH_HIGHLIGHT_STYLES[builtin]='fg=#8BE9FD'
# ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#8BE9FD'
# ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#8BE9FD'
# ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#FF79C6'
# ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#F8F8F2'
# ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#F8F8F2'
# ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#F8F8F2'
# ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#FF79C6'
# ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#FF79C6'
# ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#FF79C6'
# ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#F1FA8C'
# ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#F1FA8C'
# ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#F1FA8C'
# ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#FF5555'
# ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#F1FA8C'
# ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#FF5555'
# ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#F1FA8C'
# ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#F8F8F2'
# ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#FF5555'
# ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#F8F8F2'
# ZSH_HIGHLIGHT_STYLES[assign]='fg=#F8F8F2'
# ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#F8F8F2'
# ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#F8F8F2'
# ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#FF5555'
# ZSH_HIGHLIGHT_STYLES[path]='fg=#F8F8F2'
# ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#FF79C6'
# ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#F8F8F2'
# ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#FF79C6'
# ZSH_HIGHLIGHT_STYLES[globbing]='fg=#F8F8F2'
# ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#BD93F9'
# ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#FF5555'
# ZSH_HIGHLIGHT_STYLES[redirection]='fg=#F8F8F2'
# ZSH_HIGHLIGHT_STYLES[arg0]='fg=#F8F8F2'
# ZSH_HIGHLIGHT_STYLES[default]='fg=#F8F8F2'
#
# source $ZSH/oh-my-zsh.sh
# ==========================================
# END OH-MY-ZSH SECTION
# ==========================================

# ------------------------------
# Standalone Plugin Setup (LIGHTWEIGHT ALTERNATIVE)
# ------------------------------
# These plugins are installed via Nix (zsh-autosuggestions, zsh-syntax-highlighting)
# and sourced directly - no oh-my-zsh framework overhead.
# Startup time: ~80ms vs ~300ms with oh-my-zsh

# Source syntax highlighting (must be before autosuggestions)
if [[ -f /run/current-system/sw/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /run/current-system/sw/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Source autosuggestions
if [[ -f /run/current-system/sw/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /run/current-system/sw/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Dracula colors for syntax highlighting (works with standalone plugin too)
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=#6272A4'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#50FA7B'
ZSH_HIGHLIGHT_STYLES[function]='fg=#50FA7B'
ZSH_HIGHLIGHT_STYLES[command]='fg=#50FA7B'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#50FA7B,italic'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#8BE9FD'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#8BE9FD'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#F1FA8C'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#F1FA8C'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#FF5555'
ZSH_HIGHLIGHT_STYLES[path]='fg=#F8F8F2'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#FF79C6'

# Autosuggestion color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6272A4'

# ------------------------------
# Environment
# ------------------------------
export EDITOR='nvim'
export VISUAL='nvim'
export BAT_THEME=Dracula

# Source secrets/env if exists
[[ -f "$HOME/dotfiles/zsh/.env" ]] && source "$HOME/dotfiles/zsh/.env"
[[ -f "$HOME/.env" ]] && source "$HOME/.env"

# Vi mode (basic - not as powerful as ble.sh in bash)
bindkey -v

# ------------------------------
# Starship Prompt (Nix-installed)
# ------------------------------
eval "$(starship init zsh)"

# ------------------------------
# Zoxide (replaces z plugin)
# ------------------------------
eval "$(zoxide init zsh)"

# ------------------------------
# FZF
# ------------------------------
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# ------------------------------
# Direnv (auto-load dev environments)
# ------------------------------
eval "$(direnv hook zsh)"

# ------------------------------
# Aliases: System
# ------------------------------
alias c="clear"
alias e="exit"
alias fuck='sudo $(fc -ln -1)'

# Use eza instead of ls (Nix-installed)
alias ls='eza --icons'
alias ll='eza -la --icons'
alias la='eza -a --icons'
alias lt='eza --tree --icons'

# ==========================================
# NIXOS OPERATIONS (Bleeding Edge Management)
# ==========================================
# Config location
export NIXOS_CONFIG="$HOME/nixos-config"

# --- UPDATE & REBUILD ---
# Update flake inputs (pull latest nixpkgs, niri, hyprland, etc.)
alias nix-update='nix flake update --flake $NIXOS_CONFIG'

# Rebuild and switch to new configuration
alias nix-rebuild='sudo nixos-rebuild switch --flake $NIXOS_CONFIG#achilles'

# Full update: update inputs + rebuild (most common operation)
alias nix-upgrade='nix-update && nix-rebuild'

# Test build without switching (dry run)
alias nix-test='sudo nixos-rebuild test --flake $NIXOS_CONFIG#achilles'

# Build but don't activate until reboot
alias nix-boot='sudo nixos-rebuild boot --flake $NIXOS_CONFIG#achilles'

# --- ROLLBACK (When things break) ---
# List all generations (boot menu entries)
alias nix-generations='sudo nix-env --list-generations --profile /nix/var/nix/profiles/system'

# Rollback to previous generation (immediate)
alias nix-rollback='sudo nixos-rebuild switch --rollback'

# Boot into specific generation (use nix-generations to find number)
# Usage: nix-switch-gen 42
nix-switch-gen() {
  sudo nix-env --profile /nix/var/nix/profiles/system --switch-generation "$1"
  sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
}

# --- GARBAGE COLLECTION ---
# Remove old generations (keeps current)
alias nix-gc='sudo nix-collect-garbage -d'

# Remove generations older than 7 days
alias nix-gc-week='sudo nix-collect-garbage --delete-older-than 7d'

# Optimize store (deduplicate)
alias nix-optimize='nix store optimise'

# Full cleanup: gc + optimize
alias nix-clean='nix-gc && nix-optimize'

# --- INSPECTION & DEBUGGING ---
# What changed between generations?
alias nix-diff='nix profile diff-closures --profile /nix/var/nix/profiles/system'

# Show current system info
alias nix-info='nix-shell -p nix-info --run "nix-info -m"'

# Check for broken packages
alias nix-check='nix-store --verify --check-contents'

# List installed packages
alias nix-list='nix-env -q'

# Search for package
nix-search() {
  nix search nixpkgs "$1"
}

# Why is this package installed? (reverse dependency)
nix-why() {
  nix-store --query --referrers $(which "$1")
}

# --- FLAKE OPERATIONS ---
# Show flake inputs and their versions
alias nix-inputs='nix flake metadata $NIXOS_CONFIG'

# Update specific input only
# Usage: nix-update-input nixpkgs
nix-update-input() {
  nix flake lock --update-input "$1" --flake $NIXOS_CONFIG
}

# --- QUICK REFERENCE ---
# Run 'nix-help' for quick reference
alias nix-help='cat << "EOF"
╔════════════════════════════════════════════════════════════════╗
║                    NIXOS QUICK REFERENCE                       ║
╠════════════════════════════════════════════════════════════════╣
║ DAILY USE:                                                     ║
║   nix-upgrade      Update all packages + rebuild               ║
║   nix-rebuild      Rebuild without updating                    ║
║                                                                ║
║ WHEN THINGS BREAK:                                             ║
║   nix-rollback     Immediately switch to previous generation   ║
║   nix-generations  List all available generations              ║
║   nix-switch-gen N Switch to specific generation number        ║
║   (Or select from boot menu at startup)                        ║
║                                                                ║
║ CLEANUP:                                                       ║
║   nix-gc           Remove all old generations                  ║
║   nix-gc-week      Keep last 7 days of generations             ║
║   nix-clean        Full cleanup + optimize                     ║
║                                                                ║
║ DEBUGGING:                                                     ║
║   nix-diff         Show what changed between generations       ║
║   nix-search foo   Search for package "foo"                    ║
║   nix-why foo      Why is "foo" installed?                     ║
║   nix-inputs       Show flake input versions                   ║
║                                                                ║
║ BLEEDING EDGE SAFETY:                                          ║
║   1. Always have 2-3 generations before major updates          ║
║   2. Use nix-test before nix-rebuild for risky changes         ║
║   3. If boot fails: select older generation from boot menu     ║
║   4. Keep nix-gc-week not nix-gc to preserve rollback options  ║
╚════════════════════════════════════════════════════════════════╝
EOF'

# ------------------------------
# Aliases: Tmux
# ------------------------------
alias t="tmux"
alias taa="t a"
alias ta="t a -t"
alias tn="t new -s"
alias tk="t kill-session"
alias tka="t kill-server"

# ------------------------------
# Aliases: Docker
# ------------------------------
alias d="docker"
alias dcu="docker compose up"
alias dcud="docker compose up -d"
alias dcd="docker compose down"
alias dcuba="docker compose up --build"
alias dcb="docker compose build"
alias dcr="docker compose run --rm"
alias dce="docker compose exec"
alias dps="d ps"
alias dpsa="d ps -a"
alias dils="d image ls"
alias dcls="d container ls"
alias dl="d logs"

# ------------------------------
# Aliases: Lazy Tools
# ------------------------------
alias ldoc="lazydocker"
alias lg="lazygit"

# ------------------------------
# Aliases: Kubernetes
# ------------------------------
alias kgp="kubectl get pods"
alias kgd="kubectl get deployments"
alias kgs="kubectl get services"
alias kgsc="kubectl get sc"
alias kgpv="kubectl get pv"
alias kgpvc="kubectl get pvc"
alias kgcm="kubectl get configmap"
alias kgns="kubectl get namespaces"
alias kns="kubens"
alias kctx="kubectx"

# ------------------------------
# Aliases: Network TUIs (NixOS)
# ------------------------------
alias wifi="impala"
alias bt="bluetui"

# ------------------------------
# Aliases: Tmuxinator
# ------------------------------
alias workFE="tmuxinator workFE"
alias workBE="tmuxinator workBE"
alias dfiles="tmuxinator df"
alias pcstatus="tmuxinator pcstatus"
alias workProd="tmuxinator workProd"
alias bangProj='tmuxinator bangProj'
alias amReact='tmuxinator amReact'
alias amGo="tmuxinator amGo"

# ------------------------------
# Functions
# ------------------------------
function logPretty() {
  figlet -f whimsy "$1" | lolcat
}

function gline() {
  git log --shortstat --author "$1" --since "10 years ago" --until "today" \
    | grep "files changed" \
    | awk '{files+=$1; inserted+=$4; deleted+=$6} END {print "files changed", files, "lines inserted:", inserted, "lines deleted:", deleted}'
}

# ------------------------------
# Nushell helper (use nu for data wrangling)
# ------------------------------
# Drop into nushell for structured data operations
# Usage: nush "open file.json | where status == 'active'"
nush() {
  nu -c "$1"
}

# ------------------------------
# Mise (uncomment when ready)
# ------------------------------
# eval "$(mise activate zsh)"
