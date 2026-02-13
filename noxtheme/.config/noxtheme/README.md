# noxtheme - NixOS Theme System

A simple, Omarchy-inspired theme switcher for NixOS with Niri/Noctalia integration.

## Quick Start

```bash
# List available themes
noxtheme list

# Switch theme
noxtheme set dracula
noxtheme set catppuccin-mocha
noxtheme set florida-man

# Check current theme
noxtheme current

# Reload current theme
noxtheme reload

# Random wallpaper from current theme
noxtheme wallpaper
```

## Available Themes

| Theme | Base | Description |
|-------|------|-------------|
| **dracula** | Dracula | Classic purple vampire theme |
| **catppuccin-mocha** | Catppuccin | Darkest Catppuccin variant |
| **florida-man** | Catppuccin Frappe | GTA VI-inspired, by OldJobobo |

## Theme Structure

Each theme in `~/.config/noxtheme/themes/<name>/` can contain:

```
themes/<name>/
├── colors.sh           # Shell-sourceable color variables
├── ghostty.conf        # Ghostty terminal colors
├── alacritty.toml      # Alacritty terminal colors
├── neovim.lua          # Neovim colorscheme (LazyVim compatible)
├── btop.theme          # btop system monitor theme
├── yazi.toml           # Yazi file manager theme
├── cava.conf           # Cava audio visualizer
├── gtk-3.0/            # GTK 3.0 theme
│   ├── settings.ini
│   └── gtk.css
├── gtk-4.0/            # GTK 4.0 theme
│   ├── settings.ini
│   └── gtk.css
├── qt5ct.conf          # Qt5 theme config
├── qt6ct.conf          # Qt6 theme config
├── qt5ct-colors.conf   # Qt color palette
├── hyprland.conf       # Hyprland compositor theme
├── waybar.css          # Waybar styles
└── backgrounds/        # Wallpapers (png, jpg, webp)
```

## App Integration

### Ghostty
Add to `~/.config/ghostty/config`:
```
config-file = ~/.config/noxtheme/current/theme/ghostty.conf
```

### Alacritty
Add to `~/.config/alacritty/alacritty.toml`:
```toml
import = ["~/.config/alacritty/colors.toml"]
```

### Hyprland (optional)
Add to `~/.config/hypr/hyprland.conf`:
```
source = ~/.config/hypr/themes/current.conf
```

### Waybar (optional)
Add to your `style.css`:
```css
@import "themes/current.css";
```

### btop
Set in btop config: `color_theme = "~/.config/btop/themes/current.theme"`

### Cava
Cava config is copied to `~/.config/cava/config` on theme switch.

### GTK 3.0/4.0
Settings and CSS are copied to `~/.config/gtk-3.0/` and `~/.config/gtk-4.0/`.

### Qt5/Qt6
Configs are copied to `~/.config/qt5ct/` and `~/.config/qt6ct/`.
Add to your shell profile:
```bash
export QT_QPA_PLATFORMTHEME=qt5ct
```

## Noctalia Integration & Mutagen Mode

noxtheme supports two theming modes:

### Theme Mode (Default)
When you switch themes, noxtheme:
1. Generates `~/.config/noctalia/colors.json` with Material Design 3 color roles
2. Sets wallpaper symlink at `~/.config/noxtheme/current/background`
3. Noctalia uses your curated theme colors

### Mutagen Mode (Wallpaper-Based)
Enable Mutagen mode to let Noctalia auto-generate colors from your wallpaper:

```bash
# Toggle Mutagen mode
noxtheme mutagen

# Check status
noxtheme mutagen-status
```

When Mutagen mode is enabled:
- `colors.json` is removed so Noctalia extracts colors from wallpaper
- Great for dynamic theming that matches your background
- Terminal, TUI, and editor themes still come from noxtheme

## Niri Integration

noxtheme applies focus ring and border colors to Niri:

1. **Runtime**: Colors applied immediately via `niri msg`
2. **Config**: Generates `~/.config/niri/themes/current.kdl`

To use persistent Niri theming, add to your `config.kdl`:
```kdl
include "themes/current.kdl"
```

## Browser Theming

### Zen Browser / Firefox
noxtheme generates `userChrome.css` for:
- Zen Browser (auto-detected profile)
- Firefox Developer Edition
- Firefox (default-release profile)

**Enable userChrome in Firefox/Zen:**
1. Go to `about:config`
2. Set `toolkit.legacyUserProfileCustomizations.stylesheets` to `true`
3. Restart browser

### Chrome / Chromium
noxtheme generates a Chrome theme extension at:
```
~/.config/noxtheme/chrome-theme/
```

To use:
1. Open `chrome://extensions`
2. Enable "Developer mode"
3. Click "Load unpacked"
4. Select `~/.config/noxtheme/chrome-theme/`

## Hyprland Standalone Support

When running Hyprland without Noctalia, noxtheme:
1. Sets cursor theme via `hyprctl setcursor`
2. Generates `~/.config/hypr/themes/env.conf` with cursor/icon env vars

Add to your `hyprland.conf`:
```
source = ~/.config/hypr/themes/current.conf
source = ~/.config/hypr/themes/env.conf
```

Themes can define cursor/icon preferences in `colors.sh`:
```bash
cursor_theme="Bibata-Modern-Classic"
cursor_size="24"
icon_theme="Yaru"
```

---

# shell-switch - Desktop Shell Switcher

Switch between desktop shells (Noctalia, DMS, Caelestia) on the fly.

## Quick Start

```bash
# Interactive TUI (requires fzf)
shell-switch

# List available shells
shell-switch list

# Switch shell
shell-switch set dms
shell-switch set noctalia

# Show status
shell-switch status

# Compositor info
shell-switch compositor
```

## Supported Shells

| Shell | Compositors | Framework |
|-------|-------------|-----------|
| **noctalia** | Niri | Rust/Iced |
| **dms** | Niri, Hyprland, Sway | Quickshell (Qt/QML) |
| **caelestia** | Hyprland | Quickshell (Qt/QML) |

## How It Works

### On NixOS
- Shells are enabled/disabled in `flake.nix`
- For persistent changes: edit flake.nix, run `nixos-rebuild switch`
- Runtime switching is supported but temporary

### On Arch
- Shells are managed via systemd user services
- Runtime switching via `shell-switch set <shell>`
- Changes persist until reboot or next switch

## Compositor Switching

Compositors (Niri, Hyprland) are switched at **login time** via your display manager (greetd, SDDM, GDM).

On NixOS, enable compositors in `flake.nix`:
```nix
# Uncomment ONE compositor
niri.nixosModules.niri
# hyprland.nixosModules.default
```

Then `nixos-rebuild switch` and select at login.

---

## Creating Custom Themes

1. Copy an existing theme:
   ```bash
   cp -r ~/.config/noxtheme/themes/dracula ~/.config/noxtheme/themes/my-theme
   ```

2. Edit `colors.sh` with your colors:
   ```bash
   background="#1a1b26"
   foreground="#c0caf5"
   accent="#7aa2f7"
   # ... etc
   ```

3. Update app-specific configs to match

4. Add wallpapers to `backgrounds/`

5. Apply: `noxtheme set my-theme`

## Color Variables (colors.sh)

Standard variables expected by the theme system:

```bash
# Core colors
background="#..."
foreground="#..."
cursor="#..."
accent="#..."
selection_background="#..."
selection_foreground="#..."

# Terminal 16-color palette
color0 - color15

# Extended palette (optional)
comment, pink, purple, red, yellow, green, cyan, orange
```

## Tips

- **Neovim**: Restart nvim after theme switch for colorscheme change
- **Ghostty**: Themes apply immediately on save
- **Hyprland**: Run `hyprctl reload` or restart compositor
- **Waybar**: Receives SIGUSR2 signal for hot reload
- **GTK/Qt**: May need app restart to see changes

## Credits

- Florida-man theme by [OldJobobo](https://github.com/OldJobobo/omarchy-florida-man-theme)
- Inspired by [Omarchy](https://omarchy.com) theme system
- Catppuccin colors from [catppuccin/catppuccin](https://github.com/catppuccin/catppuccin)
- Dracula colors from [dracula/dracula-theme](https://github.com/dracula/dracula-theme)
- Shell-switch inspired by [theblackdon/shell-switch](https://gitlab.com/theblackdon/shell-switch)
