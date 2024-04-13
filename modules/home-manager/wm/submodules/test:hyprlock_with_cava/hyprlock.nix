{ pkgs, inputs, ... }:
let
  #walColor = (builtins.fromJSON (builtins.readFile ./colors-rgb.json)).colors.color1;
  labelColor = "rgba(255, 255, 255, 1)";
in
{
  imports = [
    inputs.hyprlock.homeManagerModules.hyprlock
  ];

  #home.packages = [ inputs.hyprlock.packages."x86_64-linux".hyprlock ];

  programs.hyprlock = {
    enable = true;
    general.grace = 3;
    backgrounds = [
      {
        monitor = "HDMI-A-1";
        path = "~/scripts/wallpaper/wallpaper.png";
        blur_size = 4;
        blur_passes = 4;
      }
      {
        monitor = "DP-2";
        path = "~/scripts/wallpaper/wallpaper.png";
        blur_size = 4;
        blur_passes = 4;
      }
      {
        monitor = "eDP-1";
        color = "rgba(0, 0, 0, 0)";
      }
    ];
    labels = [
      {
        text = ''cmd[update:500] echo "$(date +'%H:%M:%S')"'';
        color = labelColor;
        font_size = 50;
        font_family = "NotoMonoNerdFont";
        position = {x=0; y=250;};
        shadow_passes = 1;
      }
      {
        text = ''cmd[update:10000] echo "$(date +'%a %d. %b')"'';
        color = labelColor;
        font_size = 15;
        font_family = "NotoSansNerdFont";
        position = {x=0; y=330;};
        shadow_passes = 1;
      }
      {
        text = ''󱁕 Hey <span foreground="##880000" style="italic">$USER</span> 󱁕'';
        color = labelColor;
        position = {x=0; y=30;};
        font_family = "NotoSansNerdFont";
        shadow_passes = 1;
      }
      {
        text = "";
        color = labelColor;
        position = {x=0; y=80;};
        valign = "center";
        shadow_passes = 1;
      }
    ];

    input-fields = [
      {
        outline_thickness = 1;
        dots_spacing = 0.3;
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(0, 0, 0, 0)";
        font_color = "rgba(255, 255, 255, 1)";
        fade_on_empty = false;
        placeholder_text = ''<span foreground="##FFFFFF80"><i>Input Password...</i></span>'';
        hide_input = false;
        fail_text = ''<span foreground="##FFFFFF"><i>$FAIL <b>($ATTEMPTS)</b></i></span>'';
        capslock_color = "rgba(130, 0, 255, 1)";
        position = {x=0; y=-30;};
      }
    ];
  };

  wayland.windowManager.hyprland.settings = {
    bindr = [ "$mainMod, L, exec, ${./hyprlock.sh}" ];
  };

  home.packages = with pkgs; [
    alacritty
    cava
  ];

}

