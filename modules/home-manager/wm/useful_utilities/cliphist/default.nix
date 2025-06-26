{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard
  ];

  services.cliphist.enable = true;

  wayland.windowManager.hyprland.settings = {
    bind = [
      # "$mainMod, V, exec, cliphist list | ${lib.getExe pkgs.rofi-wayland} -dmenu -theme ${./spotlight-dark.rasi} | cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy && ${lib.getExe pkgs.wtype} -M ctrl v -m ctrl"
      "$mainMod, V, exec, [float; size 60% 60%; center; animation slide; dimaround] ${lib.getExe pkgs.alacritty} -e ${pkgs.cliphist}/bin/cliphist-fzf && ${lib.getExe pkgs.wtype} -M ctrl v -m ctrl"
    ];
    # layerrule = [
    #   "animation slide, rofi"
    #   "blur, rofi"
    # ];
  };
}
