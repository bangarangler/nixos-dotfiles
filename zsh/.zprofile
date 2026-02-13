# ==========================================
# .zprofile - Auto-start Niri on TTY1
# ==========================================
# This runs on login shell initialization (before .zshrc)
# Matches the Arch guide behavior: auto-login → auto-start compositor

# Only start Niri on TTY1, and only if not already in a graphical session
if [[ -z "$DISPLAY" ]] && [[ -z "$WAYLAND_DISPLAY" ]] && [[ "$(tty)" == "/dev/tty1" ]]; then
  # Set Wayland-specific environment variables
  export XDG_SESSION_TYPE=wayland
  export XDG_CURRENT_DESKTOP=niri
  export XDG_SESSION_DESKTOP=niri
  
  # Qt Wayland support
  export QT_QPA_PLATFORM=wayland
  export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
  
  # GTK Wayland support (most apps auto-detect, but explicit doesn't hurt)
  export GDK_BACKEND=wayland,x11
  
  # Firefox Wayland
  export MOZ_ENABLE_WAYLAND=1
  
  # Electron apps (Slack, Discord, VSCode, etc.)
  export ELECTRON_OZONE_PLATFORM_HINT=wayland
  
  # SDL games/apps
  export SDL_VIDEODRIVER=wayland
  
  # Clutter (GNOME apps)
  export CLUTTER_BACKEND=wayland
  
  # Start Niri via niri-session (handles dbus, portals, etc.)
  exec niri-session
fi

# TTY2+ can be used for GNOME fallback:
#   Ctrl+Alt+F2 → login → gnome-session
