{ config, lib, pkgs, inputs, ... }:
let
  hyprlockCmd = lib.meta.getExe config.programs.hyprlock.package;
  hyprctlCmd = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
in
{
  imports = [
    inputs.hypridle.homeManagerModules.hypridle
  ];

  services.hypridle = {
    enable = true;
    listeners = [
      {
        timeout = 300;
        onTimeout = hyprlockCmd;
      }
      {
        timeout = 600;
        onTimeout = "${hyprctlCmd} dispatch dpms off";
        onResume = "${hyprctlCmd} dispatch dpms on";
      }
    ];
    lockCmd = hyprlockCmd;
    beforeSleepCmd = hyprlockCmd;
  };
}

