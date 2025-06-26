{ pkgs, lib, ... }:

{
  wayland.windowManager.hyprland.settings = {
    bind = [
      "CTRL + ALT, S, exec, ${pkgs.wl-clipboard}/bin/wl-paste | ${lib.getExe pkgs.swappy} -f -"
      ", Print, exec, ${lib.getExe pkgs.grimblast} --notify --freeze copy area"
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
