{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gammastep
  ];

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "gammastep-indicator -l 47.26266:11.39454"
    ];
  };
}
