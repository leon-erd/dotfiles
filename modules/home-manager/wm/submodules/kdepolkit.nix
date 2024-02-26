{ pkgs, ... }:

{
  home.packages = [ pkgs.libsForQt5.polkit-kde-agent ];

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "/nix/store/$(ls -la /nix/store | grep polkit-kde-agent | grep '^d' | awk '{print $9}' | head -n 1)/libexec/polkit-kde-authentication-agent-1"
    ];
  };
}
