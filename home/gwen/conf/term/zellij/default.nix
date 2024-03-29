{config, ...}:
with config.colorscheme.palette; {
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
  };
  home.shellAliases = {
    zr = "zellij run --";
    zrf = "zellij run --floating --";
    ze = "zellij edit";
    zef = "zellij edit --floating";
  };

  xdg.configFile."zellij/config.kdl".text = ''
    default_layout "layout"
    mouse_mode true
    copy_on_select true
    simplified_ui  false
    scrollback_editor "/home/gwen/.nix-profile/bin/nvim"
    pane_frames false
    on_force_close "detach"

    ui {
      pane_frames {
        rounded_corners true
      }
    }

    keybinds {
            normal {
                    bind "Alt m" {
                            LaunchPlugin "file:~/.config/zellij/plugins/monocle.wasm" {
                                    in_place true
                                    kiosk true
                            };
                            SwitchToMode "Normal"
                    }
                    bind "Ctrl f" {
                            LaunchOrFocusPlugin "file:~/.config/zellij/plugins/monocle.wasm" {
                                    floating true
                            }
                            SwitchToMode "Normal"
                    }
                  bind "Alt x" { WriteChars "kubie ctx"; Write 13; SwitchToMode "Normal"; }
            }

            shared_except "locked" {
                    bind "Ctrl y" {
                            LaunchOrFocusPlugin "file:~/.config/zellij/plugins/room.wasm" {
                                    floating true
                                    ignore_case true
                            }
                    }
            }
          unbind "Ctrl b" "Ctrl h" "Ctrl g"
        }

        themes {
          default {
           bg  "#${mbg}"
           fg  "#${foreground}"
           black  "#${background}"
           red  "#${color9}"
           green  "#${color2}"
           yellow  "#${color3}"
           blue  "#${color4}"
           magenta  "#${color5}"
           cyan  "#${color6}"
           white  "#${color7}"
           orange  "#${color11}"
         }
       }
  '';
  xdg.configFile."zellij/layouts/layout.kdl".text = ''
    layout {
        pane split_direction="vertical" {
            pane
    }

     pane size=1 borderless=true {
         plugin location="file:/home/gwen/.nix-profile/bin/zjstatus.wasm" {
             format_left  "{mode} #[fg=#${comment},bold]{session} {tabs}"
             format_center "{command_git_branch}"
             format_right "{datetime}"
             format_space ""

             hide_frame_for_single_pane "true"

             mode_normal  "#[bg=#${accent}] "
             mode_pane    "#[bg=#${color4}] {name} "
             mode_tab     "#[bg=#${color2}] {name} "
             mode_locked  "#[bg=#${color9}] {name} "

             tab_normal              "#[fg=#${comment}] {index}:{name} "
             tab_normal_fullscreen   "#[fg=#${comment}] {index}:{name} {fullscreen_indicator}"
             tab_normal_sync         "#[fg=#${comment}] {index}:{name} <> "
             tab_normal_floating     "#[fg=#${comment}] {index}:{name} {floating_indicator}"

             tab_active              "#[fg=#${accent},bold,dashed-underscore,bg=default,us=white] {name} "
             tab_active_fullscreen   "#[fg=#${accent},bold,italic] {name} {fullscreen_indicator}"
             tab_active_sync         "#[fg=#${accent},bold,italic] {name} {sync_indicator}"
             tab_active_floating     "#[fg=#${accent},bold,italic] {name} {floating_indicator}"

             datetime        "#[fg=#${comment},bold] {format} "
             datetime_format "%A, %d %b %Y %H:%M"
             datetime_timezone "Europe/Paris"

             tab_fullscreen_indicator "[] "
             tab_floating_indicator   "⬚ "
             tab_sync_indicator      "<>"
         }
     }
    }
  '';
}
