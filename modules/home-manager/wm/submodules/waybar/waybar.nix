{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pavucontrol
    pywal
  ];

  programs.waybar = {
    enable = true;
  };

  wayland.windowManager.hyprland.settings = {
    bind = [ "CTRL + ALT, B, exec, ~/scripts/launch_waybar.sh" ];
    exec-once = [ "~/scripts/launch_waybar.sh" ];
    layerrule = [
      "blur, waybar"
      "ignorezero, waybar"
    ];
  };

  xdg.configFile."waybar" = {
    source = ./configs;
    recursive = true;
  };
}

