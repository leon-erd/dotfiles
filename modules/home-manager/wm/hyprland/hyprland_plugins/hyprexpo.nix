{ inputs, pkgs, ... }:

let
  inherit (inputs.hyprland-plugins.packages.${pkgs.system}) hyprexpo;
in
{
  wayland.windowManager.hyprland = {
    plugins = [
      hyprexpo
    ];
    settings = {
      plugin.hyprexpo = {
        columns = 3;
        gap_size = 5;
        bg_col = "rgb(111111)";
        workspace_method = "first 1"; # [center/first] [workspace] e.g. first 1 or center m+1
        enable_gesture = true; # laptop touchpad, 4 fingers
        gesture_distance = 300; # how far is the "max"
        gesture_positive = false; # positive = swipe down. Negative = swipe up.
      };
      bind = [ "$mainMod, W, hyprexpo:expo, toggle" ];
      permission = [
        "${hyprexpo}/lib/libhyprexpo.so, plugin, allow"
      ];
    };
  };
}
