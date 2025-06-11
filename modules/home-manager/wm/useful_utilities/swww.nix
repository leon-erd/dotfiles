{ pkgs, ... }:

{
  home.packages = [ pkgs.swww ];
  wayland.windowManager.hyprland.settings = {
    bind = [ "CTRL + ALT, W, exec, ~/scripts/wallpaper/update_wallpaper.sh" ];
    exec-once = [
      "sleep 1 && swww-daemon"
      "sleep 2 && swww img --transition-type grow ~/scripts/wallpaper/wallpaper.jpg"
    ];
  };
}
