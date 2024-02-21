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
    layerrule = [ "blur, waybar" ];
  };

  xdg.configFile."waybar/colors.css".source = ./colors.css;
  xdg.configFile."waybar/config".source = ./config;
  xdg.configFile."waybar/mediaplayer.py".source = ./mediaplayer.py;
  xdg.configFile."waybar/modules.json".source = ./modules.json;
  xdg.configFile."waybar/style.css".source = ./style.css;
}

