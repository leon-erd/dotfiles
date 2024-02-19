{ pkgs, ... }:

{
  home.packages = [ pkgs.swww ];
  wayland.windowManager.hyprland.settings = {
    bind = [ "CTRL + ALT, W, exec, ~/scripts/wallpaper/update_wallpaper.sh" ];
    exec-once = [
      "swww init"
      "sleep 1.5 && swww img --transition-type grow ~/scripts/wallpaper/wallpaper.jpg"
    ];
  };
}
