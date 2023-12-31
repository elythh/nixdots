{ config, inputs, lib, pkgs, ... }:
let
  split-monitor-workspaces = inputs.split-monitor-workspaces;
in
{
  imports = [

    ./config/default.nix

    ./programs/swaylock.nix
    ./programs/waybar.nix
    ./programs/wofi.nix

    ./services/cliphist.nix
    ./services/dunst.nix
    ./services/polkit-agent.nix
    ./services/swaybg.nix
    ./services/swayidle.nix
  ];

  home = {
    packages = with pkgs; [
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      config.wayland.windowManager.hyprland.package

      cliphist
      dbus
      libnotify
      libcanberra-gtk3
      wf-recorder
      brightnessctl
      pamixer
      slurp
      glib
      grim
      gtk3
      hyprpicker
      swappy
      wl-clipboard
      wl-screenrec
      wlr-randr
      xdg-utils
      ydotool
    ];

    sessionVariables = {
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      GDK_BACKEND = "wayland,x11";
      XDG_SESSION_TYPE = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };

  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce [ "hyprland-session.target" ];

  wayland.windowManager.hyprland = {
    plugins = [
      split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];

    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    systemd = {
      enable = true;
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  xdg = {
    enable = true;
    cacheHome = config.home.homeDirectory + "/.cache";
    mimeApps.enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
