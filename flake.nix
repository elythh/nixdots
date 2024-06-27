{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    devshell.url = "github:numtide/devshell";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    nixos-extra-modules.url = "github:oddlama/nixos-extra-modules";

    # Nixpkgs Stable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Nixpkgs uunstable
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-23.11";

    # awesome-git
    nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";

    # Home-manager
    hm.url = "github:nix-community/home-manager";

    # nix helper
    nh.url = "github:viperML/nh";

    # Nixos hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Nix colors, used for app theming
    nix-colors.url = "github:misterio77/nix-colors";

    # Stylix, nix-colors alertnative
    stylix.url = "github:danth/stylix";

    # matugen
    matugen.url = "github:InioX/matugen?ref=v2.2.0";

    # Zellij plugin for statusbar
    zjstatus.url = "github:dj95/zjstatus";

    # Anyrun, an app launcher
    anyrun.url = "github:Kirottu/anyrun";

    # Ags, a customizable and extensible shell
    ags.url = "github:Aylur/ags";

    # Waybar, the wayland bar
    waybar.url = "github:/alexays/waybar";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    # SuperScreenShot
    sss.url = "github:/SergioRibera/sss";

    # Hyprland, the modern compositor for wayland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    # Hyprspacem workspace overview plugin
    hyprspace.url = "github:KZDKM/Hyprspace";
    hyprspace.inputs.hyprland.follows = "hyprland";

    # Hyprpaper, wallpaper manager for hyprland
    hyprpaper.url = "github:hyprwm/hyprpaper";

    # hyprpicker, color picker for hyprland
    hyprpicker.url = "github:hyprwm/hyprpicker";

    # Split monitor workspaces, a plugin to get per monitor workspaces (similar to awesomewm)
    #split-monitor-workspaces.url = "github:Duckonaut/split-monitor-workspaces";
    #split-monitor-workspaces.inputs.hyprland.follows = "hyprland";

    # Spicetify, a spotify theming tool
    spicetify-nix.url = "github:the-argus/spicetify-nix";

    # My personal nixvim config
    nixvim.url = "github:elythh/nixvim";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./nix/devshell.nix
        ./nix/hosts.nix
        ./nix/pkgs.nix
        ./nix/globals.nix
      ];

      systems = [
        "x86_64-linux"
      ];
    };
}
