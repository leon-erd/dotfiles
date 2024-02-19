{ pkgs, ... }:

{
  home.packages = [ pkgs.swaylock-effects ];
  wayland.windowManager.hyprland.settings = {
    bindr = [ "$mainMod, L, exec, swaylock -f" ];
    bindl = [ ", switch:Lid Switch, exec, swaylock -f" ];
  };
  xdg.configFile."swaylock/config".text = ''
    indicator-idle-visible
    indicator-caps-lock
    ignore-empty-password
    show-failed-attempts
    image=~/scripts/wallpaper/wallpaper.jpg

    # swaylock-effects features
    clock
    datestr=
    grace=3
    effect-blur=15x5
  '';
}
