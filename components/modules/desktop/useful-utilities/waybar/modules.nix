{ ... }:

{
  flake.modules.homeManager.waybarModules =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
      xdg.configFile."waybar/modules.json".text = ''
        {
            // Workspaces
            "hyprland/workspaces": {
                "on-click": "activate",
                "active-only": false,
                "all-outputs": true,
                "format": "{}",
                "format-icons": {
                    "urgent": "",
                    "active": "",
                    "default": ""
                },
                "persistent_workspaces": {

                }
            },
            // Taskbar
            "wlr/taskbar": {
                "format": "{icon}",
                "icon-size": 20,
                "tooltip-format": "{title}",
                "on-click": "activate",
                "on-click-middle": "close",
            },
            // Hyprland Window
            "hyprland/window": {
                "rewrite": {
                    "(.*) — Mozilla Firefox": "🌎 $1",
                },
                "separate-outputs": true
            },
            // Pulseaudio
            "pulseaudio": {
                "format": "{icon}  {volume}%",
                "format-bluetooth": " {icon}  {volume}%",
                "format-bluetooth-muted": "   ",
                "format-muted": "  ",
                "format-icons": {
                    "headphone": "",
                    "hands-free": "",
                    "headset": "",
                    "phone": "",
                    "portable": "",
                    "car": "",
                    "default": [
                        "󰕿",
                        "󰖀",
                        "󰕾"
                    ]
                },
                "scroll-step": 1,
                "reverse-scrolling": true,
                "on-click-right": "pavucontrol",
                "on-click": "pamixer -t",
                "on-scroll-up": "pamixer -i 1",
                "on-scroll-down": "pamixer -d 1",
            },
            "pulseaudio#microphone": {
                "format": "{format_source}",
                "format-source": " {volume}%",
                "format-source-muted": "  ",
                "scroll-step": 1,
                "reverse-scrolling": true,
                "on-click-right": "pavucontrol",
                "on-click": "pamixer --default-source -t",
                "on-scroll-up": "pamixer --default-source -i 1",
                "on-scroll-down": "pamixer --default-source -d 1",
            },
            // Cliphist
            "custom/cliphist": {
                "format": "",
                "on-click": "sleep 0.1 && ~/dotfiles/scripts/cliphist.sh",
                "on-click-right": "sleep 0.1 && ~/dotfiles/scripts/cliphist.sh d",
                "on-click-middle": "sleep 0.1 && ~/dotfiles/scripts/cliphist.sh w",
                "tooltip": false
            },
            // Keyboard State
            "keyboard-state": {
                "numlock": true,
                "capslock": true,
                "format": "{name} {icon}",
                "format-icons": {
                    "locked": "",
                    "unlocked": ""
                }
            },
            // System tray
            "tray": {
                "icon-size": 20,
                "spacing": 10
            },
            // Clock
            "clock": {
                "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
                "format-alt": "{:%Y-%m-%d}"
            },
            // CPU
            "cpu": {
                "interval": 1,
                "format": "C {usage}% / ",
                "on-click": "${lib.getExe pkgs.alacritty} -e htop"
            },
            // Memory
            "memory": {
                "interval": 1,
                "format": "M {percentage}% / ",
                "on-click": "${lib.getExe pkgs.alacritty} -e htop"
            },
            // Temperature
            "temperature": {
                "thermal-zone": 6,
                "format": "T {temperatureC}°C",
                "interval": 1,
                "on-click": "${lib.getExe pkgs.alacritty} -e htop"
            },
            // Group hardware
            "group/hardware": {
                "orientation": "horizontal",
                "modules": [
                    "memory",
                    "cpu",
                    "temperature"
                ]
            },
            // Network
            "network": {
                "interval": 1,
                "format": "{ifname}",
                "format-wifi": "   {signalStrength}%",
                "format-ethernet": "",
                "format-disconnected": "", //An empty format will hide the module.
                "tooltip-format": "{ifname} via {gwaddri}",
                "tooltip-format-wifi": "   {essid} ({signalStrength}%)",
                "tooltip-format-ethernet": "  {ifname} ({ipaddr}/{cidr})",
                "tooltip-format-disconnected": "Disconnected",
                "max-length": 50
            },
            // Battery
            "battery": {
                "interval": 1,
                "states": {
                    "good": 95,
                    "warning": 30,
                    "critical": 15
                },
                "format": "{icon}   {capacity}%",
                "format-charging": "    {capacity}%",
                "format-plugged": "   {capacity}%",
                "format-full": "   {capacity}%",
                "format-alt": "{icon}  {time}",
                "format-icons": [
                    " ",
                    " ",
                    " ",
                    " ",
                    " "
                ]
            },
            // Bluetooth
            "bluetooth": {
                "format-disabled": "",
                "format-off": "",
                "interval": 30,
                "on-click-right": "blueman-manager"
            },
            // Idle Inhibitor
            "idle_inhibitor": {
                "format": "{icon}",
                "format-icons": {
                    "activated": " ",
                    "deactivated": " "
                }
            },
            // Backlight
            "backlight": {
                "device": "intel_backlight",
                "format": "{icon} {percent}%",
                "format-icons": [
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    ""
                ],
                "reverse-scrolling": true,
            },
            // Custom media
            "custom/media": {
                "format": "{icon} {}",
                "return-type": "json",
                "max-length": 40,
                "format-icons": {
                    "spotify": "",
                    "default": "🎜"
                },
                "escape": true,
                // "exec": "${config.programs.waybar.package}/bin/waybar-mediaplayer.py 2> /dev/null" // Script in resources folder
                "exec": "${config.programs.waybar.package}/bin/waybar-mediaplayer.py --player spotify 2> /dev/null" // Filter player based on name
            },
            //Custom notification
            "custom/notification": {
               "tooltip": false,
               "format": "{icon} ",
               "format-icons": {
                 "notification": "<span foreground='red'><sup></sup></span>",
                 "none": "",
                 "dnd-notification": "<span foreground='red'><sup></sup></span>",
                 "dnd-none": "",
                 "inhibited-notification": "<span foreground='red'><sup></sup></span>",
                 "inhibited-none": "",
                 "dnd-inhibited-notification": "<span foreground='red'><sup></sup></span>",
                 "dnd-inhibited-none": ""
               },
               "return-type": "json",
               "exec-if": "which swaync-client",
               "exec": "swaync-client -swb",
               "on-click": "sleep 0.2 && swaync-client -t -sw",
               "on-click-right": "swaync-client -d -sw",
               "escape": true
             },
        }
      '';
    };
}
