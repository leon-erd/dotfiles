{inputs, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    plugins = [
      inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
    ];
    settings = {
      plugin.dynamic-cursors = {
        mode = "tilt";
      };
    };
  };
}
