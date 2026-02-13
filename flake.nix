{
  description = "Framework 13 AMD (Strix Point) - Bleeding Edge Configuration";

  inputs = {
    # NixOS Unstable (Rolling Release for Kernel 6.18+)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Framework Hardware Support (Critical for AI 300 Series)
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Niri Compositor (NixOS Flake by sodiboo - provides nixosModules.niri)
    #niri.url = "github:sodiboo/niri-flake";
    #niri.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland Compositor (Alternative to Niri)
    #hyprland.url = "github:hyprwm/Hyprland";
    #hyprland.inputs.nixpkgs.follows = "nixpkgs";

    # Noctalia Shell (Official Flake - Niri native shell)
    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";

    # Dank Material Shell (Quickshell-based - supports Niri, Hyprland, Sway, etc.)
    #dms.url = "github:AvengeMedia/DankMaterialShell";
    #dms.inputs.nixpkgs.follows = "nixpkgs";

    # Caelestia Shell (Quickshell-based - Hyprland focused)
    #caelestia-shell.url = "github:caelestia-dots/shell";
    #caelestia-shell.inputs.nixpkgs.follows = "nixpkgs";
    
    # Zen Browser (Community Flake)
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    # Bluetui (Bluetooth TUI - not in nixpkgs)
    bluetui.url = "github:pythops/bluetui";
    bluetui.inputs.nixpkgs.follows = "nixpkgs";

    # ==========================================
    # AI CODING ASSISTANTS
    # ==========================================
    # OpenCode - Multi-provider TUI (OpenAI, Anthropic, Ollama, etc.)
    # Using nixpkgs version instead - flake had broken anthropic-auth plugin
    # opencode.url = "github:aodhanhayter/opencode-flake";
    # opencode.inputs.nixpkgs.follows = "nixpkgs";

    # Crush - Claude-focused TUI from numtide's nix-ai-tools
    nix-ai-tools.url = "github:numtide/nix-ai-tools";
    nix-ai-tools.inputs.nixpkgs.follows = "nixpkgs";

    # Claude Code - Anthropic's official CLI (uncomment to enable)
    # claude-code.url = "github:sadjow/claude-code-nix";
    # claude-code.inputs.nixpkgs.follows = "nixpkgs";

    # Codex - OpenAI's CLI tool (uncomment to enable)
    # codex.url = "github:sadjow/codex-cli-nix";
    # codex.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-hardware, noctalia, nix-ai-tools, bluetui, zen-browser, ... }@inputs: {
    nixosConfigurations."achilles" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      # Pass inputs to modules so we can use them directly
      specialArgs = { inherit inputs; };
      
      modules = [
        # Hardware Profile (Specific to AI 300 / Strix Point)
        nixos-hardware.nixosModules.framework-amd-ai-300-series
        
        # === COMPOSITORS ===
        # BLOAT NOTE: Having both enabled does NOT cause bloat in the traditional sense.
        # - Nix only downloads packages when they're referenced by the active config
        # - Both compositors together = ~200MB disk space (trivial on modern SSDs)
        # - NO runtime overhead - only one compositor runs at a time
        # - You can switch compositors instantly without rebuilding
        # - If you truly want minimal, comment out the one you don't use
        
        # Niri - Scrolling tiling Wayland compositor (~100MB)
        #niri.nixosModules.niri
        
        # Hyprland - Dynamic tiling Wayland compositor (~100MB)
        # Comment this line if you only want Niri:
        #hyprland.nixosModules.default
        
        # === SHELLS ===
        # Noctalia - Native Niri shell (Rust/Iced) - ENABLED
        noctalia.nixosModules.default
        # DMS - Dank Material Shell (Niri, Hyprland, Sway, labwc) - uncomment to enable
        # dms.nixosModules.dank-material-shell
        # Caelestia - Hyprland-focused shell (Quickshell) - uncomment to enable
        # caelestia-shell.homeManagerModules.default
        
        # Main System Config
        ./configuration.nix
      ];
    };
  };
}
