{ pkgs, ... }:

{
  imports = [
    ./submodules/alacritty.nix
    ./submodules/cliphist.nix
    ./submodules/gammastep.nix
    ./submodules/hypridle.nix
    ./submodules/hyprland_conf/hyprland_conf.nix
    ./submodules/hyprland_plugins/hyprexpo.nix
    ./submodules/hyprlock.nix
    # ./submodules/kanshi.nix
    ./submodules/myKanshiPlus/myKanshiPlus.nix
    ./submodules/kdeconnect.nix
    ./submodules/kdepolkit.nix
    ./submodules/media_controls.nix
    ./submodules/nwg-displays.nix
    ./submodules/tofi.nix
    ./submodules/screenshot.nix
    ./submodules/swaync/swaync.nix
    ./submodules/swww.nix
    ./submodules/waybar/waybar.nix
  ];
}
