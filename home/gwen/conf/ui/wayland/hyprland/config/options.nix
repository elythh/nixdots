{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "clipse -listen"
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
      "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 1"
      #"xwaylandvideobridge &"
    ];
    animations = {
      enabled = true;

      bezier = ["md3_decel, 0.05, 0.7, 0.1, 1"];

      animation = [
        "border, 1, 2, default"
        "fade, 1, 2, md3_decel"
        "windows, 1, 4, md3_decel, popin 60%"
        "workspaces, 1, 4, md3_decel, slidevert"
      ];
    };

    decoration = {
      rounding = 16;

      active_opacity = 1.0;
      inactive_opacity = 1.0;
      fullscreen_opacity = 1.0;

      drop_shadow = true;
      shadow_ignore_window = true;
      shadow_offset = "0 2";
      shadow_range = 20;
      shadow_render_power = 3;
      "col.shadow" = "rgba(00000055)";

      blur = {
        enabled = true;
        brightness = 1.0;
        contrast = 1.0;
        noise = 2.0e-2;
        passes = 3;
        popups = true;
        size = 10;
      };
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    env = ["GDK_SCALE,2" "WLR_DRM_NO_ATOMIC,1"];

    general = {
      gaps_in = 2;
      gaps_out = 4;

      border_size = 1;
      "col.active_border" = "rgba(88888888)";
      "col.inactive_border" = "rgba(00000088)";

      resize_on_border = true;
      allow_tearing = true;
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_forever = true;
    };

    group = {
      groupbar = {
        font_size = 16;
        gradients = false;
      };
    };

    input = {
      kb_layout = "us";
      kb_options = "compose:rctrl,caps:escape";

      accel_profile = "flat";
      follow_mouse = 1;

      touchpad = {
        disable_while_typing = true;
        natural_scroll = true;
        scroll_factor = 0.8;
      };
    };

    misc = {
      enable_swallow = true; # hide windows that spawn other windows
      swallow_regex = "thunar|nemo|wezterm"; # windows for which swallow is applied
      disable_autoreload = false;
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      focus_on_activate = true;
      force_default_wallpaper = 0;
      key_press_enables_dpms = true;
      mouse_move_enables_dpms = true;
      no_direct_scanout = false;
      vfr = true;
      vrr = 1;
    };

    monitor = [
      # name, resolution, position, scale
      "eDP-1, highres, 0x0, 1"
    ];

    xwayland.force_zero_scaling = true;

    workspace = [
      "1, persistent:true"
      "2, persistent:true"
      "3, persistent:true"
      "4, persistent:true"
      "5, persistent:true"
    ];
  };
}
