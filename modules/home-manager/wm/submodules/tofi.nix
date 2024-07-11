{ pkgs, ... }:

{
  programs.tofi = {
    enable = true;
    settings = {
      # General
      font = "/run/current-system/sw/share/X11/fonts/NotoSansNerdFont-Regular.ttf";
      font-size = 14;
      background-color = "#00000099";
      border-color = "#6400c8";
      prompt-text = ''" run: "'';
      min-input-width = 120;
      result-spacing = 15;

      # Dmenu
#       anchor = "top";
#       width = "100%";
#       height = 36;
#       horizontal = true;
#       outline-width = 0;
#       border-width = 0;
#       padding-top = 5;
#       padding-bottom = 0;
#       padding-left = 0;
#       padding-right = 0;

      # Rofi
      width = "50%";
      height = "50%";
      outline-width = 2;
      border-width = 2;
      corner-radius = 15;
    };
  };

  wayland.windowManager.hyprland.settings = {
    bindr = [ "$mainMod, $mainMod_L, exec, pkill --exact tofi-drun || tofi-drun --drun-launch=true" ];
    exec-once = [ "rm ~/.cache/tofi-drun" ];
    layerrule = [
      "blur, launcher"
      "animation slide, launcher"
    ];
  };
}
