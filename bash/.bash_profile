# ==========================================
# .bash_profile - Login shell initialization
# ==========================================
# This runs on login shell initialization (before .bashrc)
#
# NOTE: This is the bash equivalent of .zprofile
# If you switch to zsh, the .zprofile handles the same logic

# Niri auto-start on TTY1 (disabled - greetd handles this now)
# if [[ -z "$DISPLAY" ]] && [[ -z "$WAYLAND_DISPLAY" ]] && [[ "$(tty)" == "/dev/tty1" ]]; then
#   # Set Wayland-specific environment variables
#   # export XDG_SESSION_TYPE=wayland
#   # export XDG_CURRENT_DESKTOP=niri
#   # export XDG_SESSION_DESKTOP=niri
#
#   # Qt Wayland support
#   # export QT_QPA_PLATFORM=wayland
#   # export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
#
#   # GTK Wayland support (most apps auto-detect, but explicit doesn't hurt)
#   # export GDK_BACKEND=wayland,x11
#
#   # Firefox Wayland
#   # export MOZ_ENABLE_WAYLAND=1
#
#   # Electron apps (Slack, Discord, VSCode, etc.)
#   # export ELECTRON_OZONE_PLATFORM_HINT=wayland
#
#   # SDL games/apps
#   # export SDL_VIDEODRIVER=wayland
#
#   # Clutter (GNOME apps)
#   # export CLUTTER_BACKEND=wayland
#
#   # Start Niri via niri-session (handles dbus, portals, etc.)
#   # exec niri-session
#   exec niri-session 2>&1 &
#   sleep 2 echo "niri started with pid $!" >>/tmp/bash_profile_debug
# fi

# TTY2+ can be used for GNOME fallback:
#   Ctrl+Alt+F2 → login → gnome-session

# Source .bashrc for interactive non-login shells spawned from login shell
# This ensures aliases and functions are available in tmux, etc.
if [[ -f "$HOME/.bashrc" ]]; then
  source "$HOME/.bashrc"
fi
