{ pkgs, ... }:

{
  home.packages = [ pkgs.swaynotificationcenter ];
  wayland.windowManager.hyprland.settings = {
    bind = [ "$mainMod, N, exec, swaync-client -t -sw" ];
    exec-once = [ "swaync" ];
    layerrule = [
      "blur, swaync-control-center"
      "blur, swaync-notification-window"
      "ignorezero, swaync-control-center"
      "ignorezero, swaync-notification-window"
    ];
  };
  xdg.configFile."swaync/config.json".source = ./config.json;
  xdg.configFile."swaync/style.css".source = ./style.css;
}
