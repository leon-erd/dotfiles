{ pkgs, ... }:

let
  inherit (pkgs.hyprlandPlugins) hypr-dynamic-cursors;
in
{
  wayland.windowManager.hyprland = {
    plugins = [
      hypr-dynamic-cursors
    ];
    settings = {
      plugin.dynamic-cursors = {
        mode = "tilt";
      };
      permission = [
        "${hypr-dynamic-cursors}/lib/libhypr-dynamic-cursors.so, plugin, allow"
      ];
    };
  };
}
