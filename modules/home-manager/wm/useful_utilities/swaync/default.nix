{ pkgs, ... }:

{
  home.packages = [
    pkgs.swaynotificationcenter
  ];

  wayland.windowManager.hyprland.settings = {
    bind = [ "$mainMod, N, exec, swaync-client -t -sw" ];
    exec-once = [ "swaync" ];
    layerrule = [
      "match:namespace swaync-control-center, blur on, ignore_alpha, animation popin 90%"
      "match:namespace swaync-notification-window, blur on, ignore_alpha, animation popin"
    ];
  };

  xdg.configFile."swaync" = {
    source = ./configs;
    recursive = true;
  };
}
