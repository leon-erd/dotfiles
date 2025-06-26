{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  #walColor = (builtins.fromJSON (builtins.readFile ./colors-rgb.json)).colors.color1;
  labelColor = "rgba(255, 255, 255, 1)";
in
{
  programs.hyprlock = {
    enable = true;
    package = inputs.hyprlock.packages.${pkgs.system}.default;
    settings = {
      general = {
        grace = 3;
        hide_cursor = true;
      };
      background = [
        {
          monitor = "HDMI-A-1";
          path = "~/scripts/wallpaper/wallpaper.jpg";
          blur_size = 4;
          blur_passes = 4;
        }
        {
          monitor = "DP-2";
          path = "~/scripts/wallpaper/wallpaper.jpg";
          blur_size = 4;
          blur_passes = 4;
        }
        {
          monitor = "eDP-1";
          color = "rgba(0, 0, 0, 0)";
          path = "";
          blur_passes = 0;
        }
      ];
      input-field = [
        {
          placeholder_text = ''<span foreground="##FFFFFF80"><i>Input Password...</i></span>'';
          size = "200, 50";
          outline_thickness = 1;
          dots_spacing = 0.3;
          inner_color = "rgba(0, 0, 0, 0)";
          outer_color = "rgba(0, 0, 0, 0)";
          font_color = "rgba(255, 255, 255, 1)";
          capslock_color = "rgba(130, 0, 255, 1)";
          fade_on_empty = false;
          hide_input = false;
          fail_text = ''<span foreground="##FFFFFF"><i>$FAIL <b>($ATTEMPTS)</b></i></span>'';
          position = "0, -30";
          halign = "center";
          valign = "center";
        }
      ];
      label = [
        {
          text = ''cmd[update:500] echo "$(date +'%H:%M:%S')"'';
          font_size = 50;
          font_family = "NotoMonoNerdFont";
          color = labelColor;
          position = "0, 250";
          halign = "center";
          valign = "center";
          shadow_passes = 1;
        }
        {
          text = ''cmd[update:10000] echo "$(date +'%a %d. %b')"'';
          font_size = 15;
          font_family = "NotoSansNerdFont";
          color = labelColor;
          position = "0, 330";
          halign = "center";
          valign = "center";
          shadow_passes = 1;
        }
        {
          text = ''󱁕 Hey <span foreground="##880000" style="italic">$USER</span> 󱁕'';
          font_size = 25;
          font_family = "NotoSansNerdFont";
          color = labelColor;
          position = "0, 30";
          halign = "center";
          valign = "center";
          shadow_passes = 1;
        }
        {
          text = ''<span> </span>'';
          font_size = 25;
          color = labelColor;
          position = "0, 80";
          halign = "center";
          valign = "center";
          shadow_passes = 1;
        }
      ];
    };
  };

  wayland.windowManager.hyprland.settings = {
    bindr = [ "$mainMod, L, exec, ${./hyprlock.sh}" ];
    workspace = [
      "name:hyprlock, monitor:eDP-1"
      "name:hyprlock, decorate:false"
      "name:hyprlock, border:false"
      "name:hyprlock, shadow:false"
      "special:hyprlock, monitor:eDP-1"
      "special:hyprlock, decorate:false"
      "special:hyprlock, border:false"
      "special:hyprlock, shadow:false"
    ];
    permission = [
      "${lib.escapeRegex (lib.getExe config.programs.hyprlock.package)}, screencopy, allow"
    ];
  };

  home.packages = with pkgs; [
    alacritty
    cmatrix
    asciiquarium-transparent
  ];

  programs.cava = {
    enable = true;
    settings.color = {
      gradient = 1;
      gradient_color_1 = "'#59cc33'";
      gradient_color_2 = "'#80cc33'";
      gradient_color_3 = "'#a6cc33'";
      gradient_color_4 = "'#cccc33'";
      gradient_color_5 = "'#cca633'";
      gradient_color_6 = "'#cc8033'";
      gradient_color_7 = "'#cc5933'";
      gradient_color_8 = "'#cc3333'";
    };
  };
}
