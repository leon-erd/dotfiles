{ pkgs, ... }:

{
  imports = [
    ./submodules/alacritty.nix
    ./submodules/blueman-applet.nix
    ./submodules/cliphist
    ./submodules/gammastep.nix
    ./submodules/hypridle.nix
    ./submodules/hyprland_conf
    ./submodules/hyprland_plugins/hyprexpo.nix
    # ./submodules/hyprlock.nix
    ./submodules/hyprlock_with_apps
    # ./submodules/kanshi.nix
    ./submodules/myKanshiPlus
    ./submodules/kdeconnect.nix
    ./submodules/kdepolkit.nix
    ./submodules/media_controls.nix
    ./submodules/nm-applet.nix
    ./submodules/nwg-displays.nix
    ./submodules/tofi.nix
    ./submodules/screenshot.nix
    ./submodules/swaync
    ./submodules/swww.nix
    ./submodules/waybar
  ];
}
