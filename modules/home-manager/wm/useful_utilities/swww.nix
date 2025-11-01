{ pkgs, ... }:

{
  home.packages = [ pkgs.swww ];
  wayland.windowManager.hyprland.settings = {
    bind = [
      "CTRL + ALT, W, exec, ~/scripts/wallpaper/select_image.sh && ~/scripts/wallpaper/update_wallpaper_swww.sh"
    ];
    exec-once = [
      "sleep 1 && swww-daemon"
      "sleep 2 && ~/scripts/wallpaper/update_wallpaper_swww.sh"
    ];
  };
}
