{ config, lib, pkgs, inputs, ... }:

{
  services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages.${pkgs.system}.default;
    settings = {
      general = {
        lockCmd = "hyprlock";
        beforeSleepCmd = "hyprlock";
      };
      listener = [
        {
          timeout = 300;
          onTimeout = "hyprlock";
        }
        {
          timeout = 600;
          onTimeout = "hyprctl dispatch dpms off";
          onResume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}

