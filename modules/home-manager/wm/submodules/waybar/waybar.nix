{ pkgs, ... }:

{
  imports = [
    ./modules.nix
    ./settings.nix
  ];

  home.packages = with pkgs; [
    pavucontrol
    pywal
  ];

  programs.waybar = {
    enable = true;
    package = (pkgs.waybar.override {
      withMediaPlayer = true;
    });
    style = ./style.css;
  };

  wayland.windowManager.hyprland.settings = {
    bind = [ "CTRL + ALT, B, exec, ~/scripts/launch_waybar.sh" ];
    exec-once = [ "~/scripts/launch_waybar.sh" ];
    layerrule = [
      "blur, waybar"
      "blurpopups, waybar"
      "ignorealpha 0.1, waybar"
    ];
  };
}

