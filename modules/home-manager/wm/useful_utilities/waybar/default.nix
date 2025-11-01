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
    package = (
      pkgs.waybar.override {
        withMediaPlayer = true;
      }
    );
    style = ./style.css;
  };

  wayland.windowManager.hyprland.settings = {
    bind = [
      "CTRL + ALT, B, exec, ${./launch_waybar.sh}"
      "CTRL + ALT, W, exec, ${./launch_waybar.sh}"
    ];
    exec-once = [ "sleep 2 && ${./launch_waybar.sh}" ];
    layerrule = [
      "blur, waybar"
      "blurpopups, waybar"
      "ignorealpha 0.1, waybar"
    ];
  };
}
