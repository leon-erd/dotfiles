{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    grimblast
    swappy
    wl-clipboard
  ];

  wayland.windowManager.hyprland.settings = {
    bind = [
      "CTRL + ALT, S, exec, wl-paste | swappy -f -"
      ", Print, exec, grimblast --notify --freeze copy area"
    ];
    layerrule = [
      "noanim, hyprpicker"
      "noanim, selection"
    ];
    permission = [
      "${lib.getExe pkgs.grim}, screencopy, allow"
      "${lib.getExe pkgs.hyprpicker}, screencopy, allow" # required for freezing the screen when selecting area
    ];
  };
}
