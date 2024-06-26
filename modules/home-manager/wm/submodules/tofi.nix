{ pkgs, ... }:

{
  programs.tofi = {
    enable = true;
    settings = {
      anchor = "top";
      width = "100%";
      height = 36;
      horizontal = true;
      font-size = 14;
      prompt-text = ''" run: "'';
      outline-width = 0;
      border-width = 0;
      background-color = "#00000099";
      min-input-width = 120;
      result-spacing = 15;
      padding-top = 5;
      padding-bottom = 0;
      padding-left = 0;
      padding-right = 0;
      font = "/run/current-system/sw/share/X11/fonts/NotoSansNerdFont-Regular.ttf";
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
