{ pkgs, ... }:

{
  home.packages = [ pkgs.libsForQt5.polkit-kde-agent ];

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
    ];
  };
}
