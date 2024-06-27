{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.default.bar == "waybar") {
    services = {
      blueman-applet.enable = true;
      network-manager-applet.enable = true;
    };
    programs.waybar = {
      enable = true;
      # package = inputs.waybar.packages."${pkgs.system}".waybar;
      settings = {
        mainBar = {
          inherit (config.var.theme.waybar.position) layer position;
          spacing = 0;
          "margin-top" =
            if
              config.var.theme.waybar.float
              && config.var.theme.waybar.position == "top"
            then config.var.theme.gaps-out
            else 0;
          "margin-bottom" =
            if
              config.var.theme.waybar.float
              && config.var.theme.waybar.position == "bottom"
            then config.var.theme.gaps-out
            else 0;
          "margin-left" =
            if config.var.theme.waybar.float
            then config.var.theme.gaps-out
            else 0;
          "margin-right" =
            if config.var.theme.waybar.float
            then config.var.theme.gaps-out
            else 0;
          height = 44;
          modules-left = ["custom/logo" "hyprland/window"];
          modules-center = ["hyprland/workspaces"];
          modules-right = ["tray" "backlight" "pulseaudio" "battery" "clock" "custom/power"];

          "wlr/taskbar" = {
            format = "{icon}";
            "on-click" = "activate";
            "on-click-right" = "fullscreen";

            "icon-size" = 25;
            "tooltip-format" = "{title}";
          };
          "hyprland/window" = {
            "format" = "{title:30}";
            "max-length" = 30;
            "separate-outputs" = true;
          };

          "hyprland/workspaces" = {
            "on-click" = "activate";
            format = "{icon}";
            "format-icons" = {
              "default" = "";
              "1" = "1";
              "2" = "2";
              "3" = "3";
              "4" = "4";
              "5" = "5";
              "6" = "6";
              "7" = "7";
              "8" = "8";
              "9" = "9";
              "active" = "󱓻";
              "urgent" = "󱓻";
            };
            "persistent-workspaces" = {
              "1" = [];
              "2" = [];
              "3" = [];
              "4" = [];
              "5" = [];
            };
          };

          tray = {spacing = 16;};

          clock = {
            "tooltip-format" = "<tt>{calendar}</tt>";
            "format-alt" = "  {:%a, %d %b %Y}";
            format = "󰥔  {:%I:%M %p}";
          };

          pulseaudio = {
            format = "{icon}";
            "format-bluetooth" = "󰂰";
            nospacing = 1;
            "tooltip-format" = "Volume : {volume}%";
            "format-muted" = "󰝟";
            "format-icons" = {
              "headphone" = "";
              "default" = ["󰖀" "󰕾" ""];
            };
            "on-click" = "pamixer -t";
            "scroll-step" = 1;
          };

          "custom/logo" = {
            format = "  ";
            tooltip = false;
            on-click = "menu";
          };

          battery = {
            format = "{capacity}% {icon}";
            "format-icons" = {
              "charging" = ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
              "default" = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            };
            "format-full" = "󰁹 ";
            interval = 10;
            states = {
              warning = 20;
              critical = 10;
            };
            tooltip = false;
          };

          "custom/power" = {
            format = "󰤆";
            tooltip = false;
            on-click = "powermenu";
          };

          backlight = {
            device = "nvidia_0";
            format = "{icon}";
            "format-icons" = [" " " " "" "" "" "" "" "" ""];
          };
        };
      };
      style = ''
        * {
          border: none;
          border-radius: 0;
          min-height: 0;
          font-family: "${config.var.theme.font}";
          color: #${config.lib.stylix.colors.base05};
          font-weight: 700;
        }

        window#waybar {
          background-color: ${
          if config.var.theme.waybar.transparent
          then "rgba(0, 0, 0, 0)"
          else "#${config.lib.stylix.colors.base00}"
        };
          transition-property: background-color;
          transition-duration: 0.5s;
          border-radius: ${
          if config.var.theme.waybar.float
          then toString config.var.theme.rounding
          else "0"
        }px;
          font-size: ${toString config.var.theme.waybar.font-size}px;
        }

        .modules-left, .modules-center, .modules-right {
          border-radius: ${
          if config.var.theme.waybar.float
          then toString config.var.theme.rounding
          else "0"
        }px;
          background-color: #${config.lib.stylix.colors.base00};
          padding: 2px 6px;
        }

        window#waybar.hidden {
          opacity: 0.5;
        }

        #workspaces {
          background-color: transparent;
        }

        #workspaces button {
          all: initial; /* Remove GTK theme values (waybar #1351) */
          min-width: 0; /* Fix weird spacing in materia (waybar #450) */
          box-shadow: inset 0 -3px transparent; /* Use box-shadow instead of border so the text isn't offset */
          padding: 6px 18px;
          margin: 6px 3px;
          border-radius: 4px;
          background-color: #${config.lib.stylix.colors.base01};
          color: #${config.var.theme.colors.fgalt};
        }

        #workspaces button.active {
          color: #${config.lib.stylix.colors.base05};
          background-color: #${config.lib.stylix.colors.base0E};
        }

        #workspaces button:hover {
         box-shadow: inherit;
         text-shadow: inherit;
         opacity: 0.8;
        }

        #workspaces button.urgent {
          background-color: #${config.var.theme.colors.c1};
        }

        #workspaces button.empty {
          background-color: #${config.lib.stylix.colors.base00};
        }

        #window > * {
          font-family: "${config.var.theme.font-mono}";
        }

        #memory,
        #custom-power,
        #battery,
        #backlight,
        #pulseaudio,
        #network,
        #clock,
        #tray,
        #backlight{
          border-radius: 9px;
          margin: 6px 3px;
          padding: 6px 12px;
          background-color: #${config.lib.stylix.colors.base01};
          color: #${config.var.theme.colors.fgalt};
        }

        #tray menu {
          background-color: #${config.lib.stylix.colors.base01};
          color: #${config.var.theme.colors.fgalt};
        }

        #custom-logo {
          padding-right: 7px;
          font-size: ${toString config.var.theme.waybar.font-size}px;
          color: #${config.lib.stylix.colors.base0E};
        }

        @keyframes blink {
          to {
            background-color: #f38ba8;
            color: #181825;
          }
        }

        #battery.warning,
        #battery.critical,
        #battery.urgent {
          background-color: #ff0048;
          color: #181825;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #battery.charging {
          background-color: #${config.lib.stylix.colors.base01};
          color: #${config.var.theme.colors.fgalt};
          animation: none;
        }

        #custom-power {
          background-color: #${config.lib.stylix.colors.base0E};
          color: #${config.lib.stylix.colors.base05};
        }


        tooltip {
          border-radius: 8px;
          padding: 15px;
          background-color: #${config.lib.stylix.colors.base01};
          color: #${config.var.theme.colors.fgalt};
        }

        tooltip label {
          padding: 5px;
          background-color: #${config.lib.stylix.colors.base01};
          color: #${config.var.theme.colors.fgalt};
        }
      '';
    };
  };
}
