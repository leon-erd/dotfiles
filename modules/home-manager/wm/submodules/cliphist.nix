{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cliphist
    rofi-wayland
    wl-clipboard
    wtype
  ];

  wayland.windowManager.hyprland.settings = {
    bind = [ "$mainMod, V, exec, cliphist list | rofi -dmenu -theme Arc-Dark | cliphist decode | wl-copy && wtype -M ctrl v -m ctrl" ];
    exec-once = [
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
    ];
    windowrule = [ "stayfocused, Rofi" ];
  };
}
