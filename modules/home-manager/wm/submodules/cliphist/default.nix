{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cliphist
    rofi-wayland
    wl-clipboard
    wtype
  ];

  wayland.windowManager.hyprland.settings = {
    bind = [
      "$mainMod, V, exec, cliphist list | rofi -dmenu -theme ${./spotlight-dark.rasi} | cliphist decode | wl-copy && wtype -M ctrl v -m ctrl"
    ];
    exec-once = [
      "wl-paste --primary --type text --watch wl-copy" # copy primary clipboard (selected text) to regular clipboard (ctrg + c)
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
    ];
    layerrule = [
      "animation slide, rofi"
      "blur, rofi"
    ];
  };
}
