# ==========================================
# Bash Configuration for NixOS + Niri
# Using ble.sh for syntax highlighting, autosuggestions, and vim mode
# ==========================================

# ------------------------------
# BLE.SH Setup (Bash Line Editor)
# ------------------------------
# ble.sh provides: syntax highlighting, autosuggestions, advanced vim mode
# Must be sourced at the START of .bashrc (before other configs)
# NixOS installs ble.sh system-wide via blesh package

# Find and source ble.sh
_ble_path=""
if [[ -f "/run/current-system/sw/share/blesh/ble.sh" ]]; then
  _ble_path="/run/current-system/sw/share/blesh/ble.sh"
elif [[ -f "$HOME/.local/share/blesh/ble.sh" ]]; then
  _ble_path="$HOME/.local/share/blesh/ble.sh"
elif command -v blesh-share &>/dev/null; then
  _ble_path="$(blesh-share)/ble.sh"
fi

if [[ -n "$_ble_path" ]]; then
  source "$_ble_path" --noattach
fi

# ------------------------------
# BLE.SH Configuration (~/.blerc equivalent, inline)
# ------------------------------
if type bleopt &>/dev/null; then
  # Enable vim mode
  set -o vi

  # Import vim-surround (ys, cs, ds commands)
  ble-import vim-surround

  # Cursor shape changes with mode (like vim)
  ble-bind -m vi_nmap --cursor block
  ble-bind -m vi_imap --cursor beam

  # Custom vim-surround shortcuts
  bleopt vim_surround_45:=$'$( \r )'   # ysiw- wraps with $( )
  bleopt vim_surround_61:=$'$(( \r ))' # ysiw= wraps with $(( ))
  bleopt vim_surround_q:=\'            # ysiwq wraps with '
  bleopt vim_surround_Q:=\"            # ysiwQ wraps with "

  # Dracula theme colors for syntax highlighting
  # These match the Dracula palette from your zsh config
  ble-face syntax_default='fg=#f8f8f2'
  ble-face syntax_command='fg=#50fa7b'
  ble-face syntax_quoted='fg=#f1fa8c'
  ble-face syntax_quotation='fg=#f1fa8c'
  ble-face syntax_error='fg=#ff5555'
  ble-face syntax_varname='fg=#bd93f9'
  ble-face syntax_delimiter='fg=#ff79c6'
  ble-face syntax_param_expansion='fg=#bd93f9'
  ble-face syntax_history_expansion='fg=#bd93f9'
  ble-face syntax_function_name='fg=#50fa7b'
  ble-face syntax_comment='fg=#6272a4'
  ble-face syntax_glob='fg=#f8f8f2'
  ble-face syntax_brace='fg=#ff79c6'
  ble-face syntax_tilde='fg=#bd93f9'
  ble-face syntax_document='fg=#8be9fd'
  ble-face syntax_document_begin='fg=#ff79c6'
  ble-face command_builtin='fg=#8be9fd'
  ble-face command_alias='fg=#50fa7b'
  ble-face command_function='fg=#50fa7b'
  ble-face command_file='fg=#50fa7b'
  ble-face command_keyword='fg=#ff79c6'
  ble-face command_directory='fg=#ffb86c'
  ble-face filename_directory='fg=#ffb86c'
  ble-face filename_executable='fg=#50fa7b'
  ble-face filename_warning='fg=#ff5555'

  # Completion menu colors
  ble-face auto_complete='fg=#6272a4'

  # Region/selection colors
  ble-face region='fg=#f8f8f2,bg=#44475a'
  ble-face region_insert='fg=#f8f8f2,bg=#44475a'

  # Performance optimizations
  bleopt complete_auto_delay=100
fi

# ------------------------------
# Environment
# ------------------------------
export EDITOR='nvim'
export VISUAL='nvim'
export BAT_THEME=Dracula

# Source secrets/env if exists
[[ -f "$HOME/dotfiles/zsh/.env" ]] && source "$HOME/dotfiles/zsh/.env"
[[ -f "$HOME/.env" ]] && source "$HOME/.env"

# ------------------------------
# Starship Prompt (Nix-installed)
# ------------------------------
eval "$(starship init bash)"

# ------------------------------
# Zoxide (smart cd replacement)
# ------------------------------
eval "$(zoxide init bash)"

# ------------------------------
# FZF
# ------------------------------
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

# Key bindings: Ctrl+R (history), Ctrl+T (files), Alt+C (cd)
# Requires fzf 0.48+ (available in NixOS 24.05+)
if command -v fzf &>/dev/null; then
  eval "$(fzf --bash)"
fi

# ------------------------------
# Direnv (auto-load dev environments)
# ------------------------------
eval "$(direnv hook bash)"

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
export NIXOS_CONFIG="$HOME/nixos-dotfiles"

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
# Aliases: Git
# ------------------------------
alias g='git'
alias ga='git add'
alias gst='git status'
alias gb='git branch'
alias gba='git branch --all'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gc='git commit --verbose'
alias gcam='git commit --all --message'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --decorate --graph'
alias gd='git diff'

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
  git log --shortstat --author "$1" --since "10 years ago" --until "today" |
    grep "files changed" |
    awk '{files+=$1; inserted+=$4; deleted+=$6} END {print "files changed", files, "lines inserted:", inserted, "lines deleted:", deleted}'
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
# eval "$(mise activate bash)"

# ------------------------------
# BLE.SH Attach (must be at END of .bashrc)
# ------------------------------
if [[ -n "$_ble_path" ]]; then
  [[ ${BLE_VERSION-} ]] && ble-attach
fi
