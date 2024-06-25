{ pkgs, ... }:

{
  home.packages = [
#     (pkgs.swaynotificationcenter.overrideAttrs (previousAttrs:  rec {
#       nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
#         pkgs.sassc
#       ];
#       buildInputs = previousAttrs.buildInputs ++ [
#         pkgs.gvfs
#         pkgs.pantheon.granite
#       ];
#     }))
    pkgs.swaynotificationcenter
  ];

  wayland.windowManager.hyprland.settings = {
    bind = [ "$mainMod, N, exec, swaync-client -t -sw" ];
    exec-once = [ "swaync" ];
    layerrule = [
      "blur, swaync-control-center"
      "blur, swaync-notification-window"
      "ignorezero, swaync-control-center"
      "ignorezero, swaync-notification-window"
      "animation popin 90%, swaync-control-center"
      "animation popin, swaync-notification-window"
    ];
  };

  xdg.configFile."swaync" = {
    source = ./configs;
    recursive = true;
  };
}
