{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.hypridle.homeManagerModules.hypridle
  ];

  services.hypridle = {
    enable = true;
    listeners = [
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
    lockCmd = "hyprlock";
    beforeSleepCmd = "hyprlock";
  };
}

