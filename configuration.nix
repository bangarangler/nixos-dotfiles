# configuration.nix
{ config, pkgs, inputs, lib, ... }:

let
  # ==========================================
  # USER CONFIGURATION (Change this for new systems)
  # ==========================================
  username = "jon";
  userDescription = "Jon";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # ==========================================
  # KERNEL: BLEEDING EDGE (Always Latest)
  # ==========================================
  # Force the absolute latest kernel. This is the Arch-style approach:
  # - Get newest drivers, fixes, and features immediately
  # - NixOS makes rollback trivial if something breaks
  # - Framework AI 300 benefits from ongoing Strix Point improvements
  # 
  # nixos-hardware only sets latest when nixpkgs default < 6.15.
  # We override to ALWAYS use latest for true bleeding edge.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hibernation (Resume from Swap)
  boot.resumeDevice = "/dev/disk/by-label/nixos"; 
  boot.kernelParams = [ 
    # Must be updated with 'btrfs inspect-internal map-swapfile -r ...'
    "resume_offset=533760"
    
    # AMD P-State Active Mode (Preferred for Zen 5 / Kernel 6.12+)
    # 'active' allows firmware to manage freq (EPP) which is faster than OS 'guided' mode.
    # Reference: https://docs.kernel.org/admin-guide/pm/amd-pstate.html
    "amd_pstate=active"

    # Framework 13 AMD AI 300 series: Required for suspend-then-hibernate
    # NixOS removes this for kernels >= 6.8, but Framework 13 HX 370 still needs it.
    # Without this, HibernateDelaySec timer never fires and battery drains during suspend.
    # Ref: https://community.frame.work/t/laptop-13-ryzen-hx370-hibernation-problems/75092
    "rtc_cmos.use_acpi_alarm=1"

    # Optional: Enable IOMMU Passthrough (better virtualization performance)
    "iommu=pt" 

    # --- LEGACY / DEBUG PARAMETERS (Uncomment only if issues arise) ---
    # "amd_pstate=guided"   
    #   Why removed: Downgrade from 'active'. Adds OS scheduler latency. 
    #   Use only if 'active' causes instability.
    
    # "amd_iommu=fullflush" 
    #   Why removed: Workaround for Ryzen 6000/7040 stuttering. 
    #   Incurs significant I/O performance penalty. 
    #   Enable ONLY if experiencing random system freezes or "AMD-Vi completion-wait" errors.
  ];
  
  # Note: Audio module blacklists (snd_acp70, snd_acp_pci) and PSR fix
  # (amdgpu.dcdebugmask=0x10) are handled by nixos-hardware module.
  
  # ==========================================
  # FRAMEWORK AUDIO ENHANCEMENT (Built-in DSP)
  # ==========================================
  # The nixos-hardware module includes a PipeWire filter chain for Framework speakers.
  # This provides bass enhancement, loudness compensation, EQ, and compression.
  # Superior to manual EasyEffects presets.
  # DISABLED: Audio enhancement filter breaks volume controls (Feb 2026)
  # Issue: Filter's volume control binding doesn't work, wpctl can't adjust volume
  # PR #1709 changed default device name to HiFi__Speaker__sink but our device uses analog-stereo
  # 
  # To check if fixed:
  #   1. nix flake update nixos-hardware
  #   2. Enable below, rebuild, restart audio: systemctl --user restart wireplumber pipewire pipewire-pulse
  #   3. Test: wpctl set-volume @DEFAULT_SINK@ 5%+ && wpctl get-volume @DEFAULT_SINK@
  #   4. If volume changes, it's fixed. If stuck at 1.00, still broken.
  #
  # When fixed, enable with:
  #   hardware.framework.laptop13.audioEnhancement.enable = true;
  #   hardware.framework.laptop13.audioEnhancement.rawDeviceName = "alsa_output.pci-0000_c1_00.6.analog-stereo";
  hardware.framework.laptop13.audioEnhancement.enable = false;

  # ==========================================
  # LOCALE & TIMEZONE
  # ==========================================
  # Set your timezone (find yours: timedatectl list-timezones)
  time.timeZone = "America/New_York";
  
  # System locale
  i18n.defaultLocale = "en_US.UTF-8";
  
  # Console keymap (for TTY)
  console.keyMap = "us";

  # ==========================================
  # NETWORKING & POWER
  # ==========================================
  networking.hostName = "achilles";
  networking.networkmanager.enable = true;
  # iwd backend for modern WiFi stability (RZ616)
  networking.networkmanager.wifi.backend = "iwd"; 

  # Power profiles - nixos-hardware already enables this by default for AMD Framework,
  # but we keep it explicit for clarity. PPD is better than TLP for AMD battery life.
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true; 
  
  # Ensure HibernateMode is set to shutdown
  # Defend: This forces ACPI S5 (shutdown) after writing to swap, ensuring zero battery drain.
  # Best practice for Framework laptops to prevent "hot bag" issues.
  # HibernateDelaySec: After 1hr of suspend, auto-hibernate to save battery
  # REMOVE ONCE FIXED - CHANGE BACK TO 1Hr - below is notes on what happened - not happening all the time.
  # HibernateDelaySec=1h -   USB controller c1:00.4 (AMD 1022:151e) failed to resume:
  # xhci_hcd 0000:c1:00.4: WARN: xHC restore state timeout
  # xhci_hcd 0000:c1:00.4: HC died; cleaning up
  # 6. This left a hub_event workqueue stuck, preventing hibernate
  # 7. System entered suspend→fail→retry loop every 40 seconds for hours
  systemd.sleep.extraConfig = ''
    HibernateMode=shutdown
    HibernateDelaySec=90m
  '';
  
  # Lid close → suspend-then-hibernate (suspend now, hibernate after 1hr)
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
  };
  
  # ==========================================
  # USB & REMOVABLE MEDIA
  # ==========================================
  # udisks2: D-Bus service that allows apps to query and mount storage devices.
  # This is what lets Nautilus (and other file managers) see and mount USB drives,
  # external SSDs, SD cards, etc. Without this, you'd need to manually `mount` devices.
  services.udisks2.enable = true;
  
  # gvfs: GNOME Virtual File System - provides a unified interface for accessing
  # local and remote filesystems. Enables features like:
  # - Trash support (files go to trash instead of permanent delete)
  # - MTP support (Android phone file transfer)
  # - SMB/CIFS (Windows network shares)
  # - Automount popups when you plug in USB drives
  # Note: GNOME enables this by default, but we set it explicitly so it works
  # in Niri/Hyprland sessions too (not just when running full GNOME).
  services.gvfs.enable = true;

  # ==========================================
  # SWAP & HIBERNATION
  # ==========================================
  # Swap subvolume mount (created manually in Phase 2)
  #fileSystems."/swap" = {
  #  device = "/dev/disk/by-label/nixos";
  #  fsType = "btrfs";
  #  options = [ "subvol=swap" "noatime" ];
  #};

  # Swapfile (68GB for 64GB RAM + hibernation buffer)
  swapDevices = [{
    device = "/swap/swapfile";
  }];
  
  # AUDIO (PipeWire)
  # Defend: Required for audio to work. Replaces PulseAudio/JACK.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true; # Uncomment if you need JACK for pro audio apps
  };

  # ==========================================
  # GRAPHICS & WAYLAND
  # ==========================================
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ 
      #vulkan-radeon 
      #vulkan-loader 
      libva 
      libva-utils 
    ];
  };

  # Portals (Critical for Screen Sharing)
  # wlr.enable kept for Hyprland compatibility - Niri has built-in screencasting
  # and uses gnome/gtk portals, but wlr doesn't conflict when both are available.
  xdg.portal = {
    enable = true;
    wlr.enable = true;  # Required for Hyprland; harmless for Niri
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gnome 
      pkgs.xdg-desktop-portal-gtk 
    ];
    # Prioritize GNOME/GTK implementation for consistent dialogs
    config.common.default = [ "gnome" "gtk" ];
  };
  
  # Enable dconf for GTK settings persistence
  # Defend: Required for apps like EasyEffects, Nautilus, and GTK themes to save settings.
  # Without this, your theme or audio presets might reset on reboot.
  programs.dconf.enable = true;

  # ==========================================
  # DESKTOP ENVIRONMENT
  # ==========================================
  
  # === COMPOSITORS ===
  # Both are installed; choose which to start via .zprofile or shell-switch script
  
  # NIRI (Scrolling tiling compositor - PRIMARY)
  programs.niri.enable = true;
  
  # HYPRLAND (Dynamic tiling compositor - ALTERNATIVE)
  # The flake provides bleeding-edge Hyprland; this enables system integration
  programs.hyprland = {
    enable = true;
    # Use the flake's Hyprland package for bleeding edge
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  
  # === SHELLS ===
  # NOCTALIA (Shell/Bar for Niri - Rust/Iced based)
  services.noctalia-shell.enable = true;

  # DMS and Caelestia are enabled via flake modules when uncommented

  # SWAYIDLE (Lock & Idle Manager)
  # Defend: This replicates the behavior from the Arch guide (Phase 8) + Omarchy screensaver.
  # It manages the idle timeline: screensaver -> lock -> suspend -> hibernate.
  # Note: Noctalia handles the actual "lock screen" UI, but swayidle triggers it.
  #
  # Timeline (matches Omarchy's hypridle behavior):
  #   1.5 min (90s)  → Screensaver (tte visual effects on logo)
  #   2.5 min (150s) → Lock screen (Noctalia)
  #   5.5 min (330s) → Suspend-then-hibernate (hibernate after 1hr via HibernateDelaySec)
  #
  # swayidle 1.9+ requires config file format.
  environment.etc."swayidle/config".text =
    let
      pgrep = "${pkgs.procps}/bin/pgrep";
      pkill = "${pkgs.procps}/bin/pkill";
      systemctl = "${pkgs.systemd}/bin/systemctl";
      noctalia = "/run/current-system/sw/bin/noctalia-shell";
      screensaver = "/home/jon/.local/bin/nox-launch-screensaver";
    in ''
      timeout 90 '(${pgrep} -x hyprlock || ${pgrep} -x swaylock) || ${screensaver}'
      timeout 150 '${pkill} -f "nox-cmd-[s]creensaver" 2>/dev/null; ${pkill} -f "[g]hostty.*screensaver" 2>/dev/null; ${noctalia} ipc call lockScreen lock'
      timeout 330 '${systemctl} suspend-then-hibernate'
    '';
  
  systemd.user.services.swayidle = {
    description = "Idle Manager for Wayland";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.swayidle}/bin/swayidle -w -C /etc/swayidle/config";
      Restart = "on-failure";
      RestartSec = "1s";
      Environment = [
        "PATH=${pkgs.procps}/bin:/home/jon/.local/bin:/run/current-system/sw/bin"
        "WAYLAND_DISPLAY=wayland-1"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
    };
  };
  
  # MAKO (Notification daemon)
  # Required for Discord and other apps that send desktop notifications.
  # Using systemd instead of compositor exec-once for consistent behavior across Niri/Hyprland.
  systemd.user.services.mako = {
    description = "Mako Notification Daemon";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.mako}/bin/mako";
      Restart = "on-failure";
      RestartSec = "1s";
    };
  };

  # Lock screen before sleep (systemd hook - more reliable than swayidle before-sleep)
  systemd.services.lock-before-sleep = {
    description = "Lock screen before sleep";
    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" ];
    environment = {
      XDG_RUNTIME_DIR = "/run/user/1000";
      WAYLAND_DISPLAY = "wayland-1";
    };
    serviceConfig = {
      Type = "oneshot";
      User = username;
      ExecStart = "/run/current-system/sw/bin/noctalia-shell ipc call lockScreen lock";
    };
  };
  
  # EASYEFFECTS SERVICE (Optional - disabled when using built-in audio enhancement)
  # The nixos-hardware module's audioEnhancement option is preferred.
  # Uncomment this only if you prefer manual EasyEffects presets instead.
  # systemd.user.services.easyeffects = {
  #   description = "EasyEffects Daemon";
  #   wantedBy = [ "graphical-session.target" ];
  #   partOf = [ "graphical-session.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
  #     Restart = "on-failure";
  #   };
  # };

  # Polkit Authentication Agent (GUI sudo prompts)
  systemd.user.services.polkit-gnome = {
    description = "PolicyKit Authentication Agent";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };
  };

  # Clipboard History Daemon (cliphist)
  # Stores clipboard history for Super+Ctrl+V picker
  systemd.user.services.cliphist = {
    description = "Clipboard History Service";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
    };
  };

  # GNOME (Fallback Session - accessible via TTY2)
  # To access: Ctrl+Alt+F2 → login → run 'gnome-session'
  services.xserver.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.displayManager.lightdm.enable = false;
  
  # Auto-login to TTY1 (matches Arch behavior)
  # Niri starts via .bash_profile (or .zprofile if using zsh), Noctalia provides lock screen
  # services.getty.autologinUser = username;
  services.greetd = {
      enable = true;
      settings = {
          default_session = {
              command = "${pkgs.niri}/bin/niri-session";
              user = "jon";
            };
        };
    };

  # Security
  security.pam.services.login.fprintAuth = true;
  services.fprintd.enable = true;
  services.fwupd.enable = true;
  
  # Polkit (GUI authentication prompts for sudo actions in graphical apps)
  security.polkit.enable = true;

  # ==========================================
  # PACKAGES
  # ==========================================
  # Allow unfree packages (Required for Discord, Slack, Zoom, Postman, etc.)
  nixpkgs.config.allowUnfree = true;

  # Add ~/.local/bin to PATH for user scripts (screensaver, etc.)
  environment.localBinInPath = true;

  environment.systemPackages = with pkgs; [
    # Window Managers
    niri
    
    # Shells
    bash
    blesh      # Bash Line Editor - syntax highlighting, autosuggestions, vim mode
    zsh
    nushell    # Structured data shell (used via nush() helper in .bashrc)
    
    # Core Tools
    git
    stow
    neovim
    wget
    curl
    btop
    fzf
    ripgrep
    tmux
    eza
    zoxide
    starship
    fastfetch    # System info display (like neofetch)
    bat          # cat with syntax highlighting
    # mise # Env manager (Commented out - uncomment in .zshrc when ready)
    
    # TUI Tools
    lazygit      # Git TUI
    lazydocker   # Docker TUI
    caligula     # Disk imaging TUI (USB writer)
    
    # Wayland/Audio Utils
    wl-clipboard
    cliphist  # Clipboard history manager (use with wl-paste | cliphist store)
    wtype     # Wayland keyboard input simulator (for universal copy/paste)
    brightnessctl
    pavucontrol
    easyeffects
    swayosd
    swayidle
    swaylock
    cava
    lm_sensors
    impala # WiFi TUI
    inputs.bluetui.packages.${pkgs.system}.default # Bluetooth TUI from Flake
    # Note: lsp-plugins and bankstown-lv2 are auto-installed by audioEnhancement module
    
    # ==========================================
    # COMPOSITOR & SHELL UTILITIES
    # ==========================================
    # These packages support Niri, Hyprland, and the various shells (Noctalia, DMS, Caelestia)
    
    # Waybar (Status bar - used by Hyprland, optional for Niri)
    waybar
    
    # Hyprland ecosystem
    hyprpaper      # Wallpaper daemon for Hyprland
    hyprlock       # Lock screen for Hyprland
    hypridle       # Idle daemon for Hyprland
    hyprpicker     # Color picker
    
    # Notification daemon (used by DMS and standalone Hyprland)
    mako           # Lightweight notification daemon
    libnotify      # notify-send command
    polkit_gnome   # GUI authentication agent for polkit
    
    # Launchers / Menus
    wofi           # Wayland rofi alternative
    fuzzel         # Fast app launcher
    
    # Screenshot / Screen recording
    grim           # Screenshot tool
    slurp          # Region selector
    wf-recorder    # Screen recorder
    
    # Wallpaper
    swaybg         # Simple wallpaper setter (works with Niri too)
    
    # File manager (GUI)
    nautilus       # GNOME Files (integrates with GTK portal)
    thunar         # Lightweight file manager (XFCE)
    yazi           # TUI file manager
    
    # Theme tools
    nwg-look       # GTK theme configurator for Wayland
    adw-gtk3       # GTK3 port of libadwaita for Noctalia theming
    # bibata-cursors # Cursor theme (uncomment for standalone Hyprland/Waybar setups)
    # yaru-theme     # Icon/GTK theme (uncomment for standalone Hyprland/Waybar setups)
    # Note: Noctalia-shell handles theming via Mutagen - cursors, icons, GTK, and app configs
    # are auto-generated/synced. These packages only needed if using Hyprland without Noctalia.
    
    # Quickshell (required for DMS and Caelestia shells)
    # Note: This may come from the shell flakes, but having it explicit ensures availability
    # inputs.dms provides quickshell, but we need qs command for shell switching
    
    # Python Utils
    python3Packages.terminaltexteffects
    
    # Apps
    firefox-devedition
    google-chrome
    vivaldi
    inputs.zen-browser.packages.${pkgs.system}.default # Zen Browser from Flake
    
    # Vesktop - Discord client with Vencord built-in
    # Standalone Electron build, no native Discord modules, better Wayland support
    # TOS warning: client mod - use at own risk
    vesktop
    slack
    zoom-us
    ghostty  # Terminal
    insomnia # API Client
    postman  # API Client
    # notion-app DARWIN ONLY?
    hey-mail
    obsidian
    
    # ==========================================
    # AI CODING ASSISTANTS (TUI-focused)
    # ==========================================
    # These are CLI/TUI tools for AI-assisted coding. GUI apps (like VS Code extensions)
    # are excluded in favor of terminal-native workflows.
    #
    # API keys should be set in environment variables:
    #   export ANTHROPIC_API_KEY="sk-ant-..."
    #   export OPENAI_API_KEY="sk-..."
    # Or in tool-specific config: ~/.config/<tool>/
    
    # ENABLED: Multi-provider TUI for AI coding
    # nixpkgs version (1.1.53) is newer than flake (1.0.203) and has working plugins
    # opencode
    inputs.opencode.packages.${pkgs.system}.default  # flake version - broken anthropic-auth plugin
    
    # ENABLED: Claude-focused TUI (numtide/nix-ai-tools)
    # inputs.nix-ai-tools.packages.${pkgs.system}.crush
    nur.repos.charmbracelet.crush
    
    # AVAILABLE (uncomment in flake.nix inputs first, then uncomment here):
    # inputs.claude-code.packages.${pkgs.system}.default  # Anthropic's official CLI
    # inputs.codex.packages.${pkgs.system}.default        # OpenAI's CLI tool
    
    # IN NIXPKGS (uncomment if wanted):
    # gemini-cli  # Google's Gemini CLI
    
    # ==========================================
    # DEVELOPMENT: LSPs & Formatters (Nix-managed)
    # ==========================================
    # These are installed system-wide via Nix. LazyVim/Mason will find them in PATH.
    # 
    # WHY BOTH NIX AND MASON?
    # - Nix: Declarative, reproducible, always available, no runtime downloads
    # - Mason: Quick iteration, auto-updates, works on non-NixOS too
    #
    # STRATEGY: Install core tools via Nix (below). For work emergencies, 
    # Mason can install additional tools on-demand (nix-ld makes them work).
    # Mason-installed tools live in ~/.local/share/nvim/mason/
    #
    # If you want ONLY Nix-managed tools, configure LazyVim to skip Mason auto-install.
    
    # TypeScript / JavaScript
    #nodePackages.typescript-language-server
    #nodePackages.vscode-langservers-extracted  # HTML, CSS, JSON, ESLint LSPs
    #prettierd  # Fast Prettier daemon
    
    # Go
    #gopls
    
    # Lua
    #lua-language-server
    #stylua
    
    # Nix
    #nil  # Nix LSP
    #nixpkgs-fmt  # Nix formatter
    
    # Zig
    #zls
    
    # Python
    #pyright
    #ruff  # Fast Python linter/formatter
    
    # Ruby
    #ruby-lsp
    
    # General
    tree-sitter  # Syntax parsing (LazyVim uses this heavily)
    gcc
    go
    # stylua
    unzip
    fd
  ];
  
  # Virtualization (Docker)
  virtualisation.docker.enable = true;
  #users.users.${username}.extraGroups = [ "docker" ]; # Added to user groups below
  
  # Fonts 
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    nerd-fonts.inconsolata-lgc # The specific mono font you requested
    font-awesome
  ];

  # ==========================================
  # USER
  # ==========================================
  users.users.${username} = {
    isNormalUser = true;
    description = userDescription;
    # Added 'docker' to groups
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" "docker" ];
    # DEFAULT: bash with ble.sh (superior vim mode, text objects, macros, registers)
    # TO SWITCH TO ZSH: Change pkgs.bash to pkgs.zsh, then rebuild
    shell = pkgs.bash;
  };

  # Git configuration (declarative, NixOS-native without Home Manager)
  # WARNING: This overwrites ~/.gitconfig on every rebuild. Edit here, not the file directly.
  system.activationScripts.gitconfig = ''
    cat > /home/jon/.gitconfig << 'EOF'
[user]
	name = Jon
	email = bangarangler@gmail.com

[core]
	editor = nvim
	autocrlf = input

[init]
	defaultBranch = main

[push]
	default = simple

[pull]
	rebase = false
EOF
    chown jon:users /home/jon/.gitconfig
  '';
  
  # ==========================================
  # SHELL CONFIGURATION
  # ==========================================
  # DEFAULT: Bash with ble.sh
  # - Superior vim mode (ciw, di", visual block, macros, registers, vim-surround)
  # - Fast startup (~100ms vs ~300ms with oh-my-zsh)
  # - Universal script compatibility
  # - Starship handles prompt (git, language versions, etc.)
  #
  # ALTERNATIVE: Zsh (if you need advanced globbing or contextual completion)
  # To switch: 
  #   1. Change shell = pkgs.bash to shell = pkgs.zsh above
  #   2. Uncomment the programs.zsh.ohMyZsh section below (or use standalone plugins)
  #   3. Rebuild: sudo nixos-rebuild switch --flake .#achilles
  #   4. Stow zsh: cd ~/nixos-dotfiles && stow zsh
  # ==========================================
  
  # Bash + ble.sh (DEFAULT)
  # ble.sh provides: syntax highlighting, autosuggestions, advanced vim mode
  programs.bash = {
    # Enable bash completions
    completion.enable = true;
  };

  # Zsh (AVAILABLE - enable if you switch to zsh)
  # Even when not default shell, zsh should be available for scripts that use #!/usr/bin/env zsh
  programs.zsh = {
    enable = true;
    # Standalone plugins (lighter than oh-my-zsh, ~80ms vs ~300ms startup)
    # These are sourced directly in .zshrc without the oh-my-zsh framework
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };
  
  # ==========================================
  # OH-MY-ZSH (COMMENTED - optional heavyweight alternative)
  # ==========================================
  # Uncomment this section if you prefer oh-my-zsh over standalone plugins.
  # Note: Adds ~200ms to shell startup time but provides more plugins.
  #
  # programs.zsh = {
  #   enable = true;
  #   ohMyZsh = {
  #     enable = true;
  #     # Custom plugins not bundled with oh-my-zsh (installed via Nix)
  #     customPkgs = with pkgs; [
  #       zsh-you-should-use        # Reminds you of aliases you should use
  #       zsh-syntax-highlighting   # Fish-like syntax highlighting
  #       zsh-autosuggestions       # Fish-like autosuggestions
  #     ];
  #   };
  # };

  # ==========================================
  # NIX-LD (Dynamic Linker for Mason.nvim)
  # ==========================================
  # NixOS doesn't have /lib64/ld-linux-x86-64.so.2 which breaks precompiled binaries.
  # nix-ld provides a stub that makes Mason-downloaded LSPs/formatters work.
  # Libraries below cover: TypeScript, JavaScript, Go, Zig, Nix, Lua, Ruby, Python, HTML, CSS
  #
  # If Mason fails to run a tool, add its missing library here.
  # Find missing libs with: ldd /path/to/binary | grep "not found"
  # Then search nixpkgs: nix-locate libname.so (requires nix-index)
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # C/C++ Runtime (most binaries need these)
      stdenv.cc.cc.lib
      glib
      zlib
      
      # Network/TLS (LSPs that fetch schemas, linters that phone home)
      openssl
      curl
      
      # Node.js ecosystem (typescript-language-server, prettier, eslint)
      icu
      libuv
      
      # Python ecosystem (pyright, ruff)
      libffi
      readline
      ncurses
      
      # Git integration (for LSPs that check git state)
      libgit2
      
      # SQLite (some tools cache data)
      sqlite
      
      # --- Add more as needed ---
      # Example: If a Ruby LSP fails, you might need:
      # libyaml
      # libxml2
    ];
  };

  # ==========================================
  # SSH
  # ==========================================
  # SSH Agent: Caches passphrases so you don't re-enter for every git push
  programs.ssh.startAgent = false;
  
  # SSH Server (Uncomment if you want to SSH into this machine)
  # services.openssh = {
  #   enable = true;
  #   settings = {
  #     PasswordAuthentication = false;  # Key-only auth (more secure)
  #     PermitRootLogin = "no";
  #   };
  # };

  # ==========================================
  # NIX SETTINGS
  # ==========================================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;  # Dedup identical files in store
  
  # Garbage Collection: Clean old generations weekly
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # ==========================================
  # DIRENV (Auto-load dev environments)
  # ==========================================
  # When you `cd` into a project with a .envrc file, direnv auto-loads it.
  # nix-direnv makes `use flake` fast by caching the devShell.
  #
  # Per-project workflow:
  #   1. Create flake.nix with devShells.default
  #   2. Create .envrc with: use flake
  #   3. Run: direnv allow
  #   4. Now every `cd` into the dir loads your dev environment
  #
  # For complex projects, consider devenv.sh (per-project, not system-wide):
  #   nix flake init --template github:cachix/devenv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ==========================================
  # SYSTEM STATE VERSION
  # ==========================================
  system.stateVersion = "26.05";
}
