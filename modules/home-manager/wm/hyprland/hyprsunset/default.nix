{
  pkgs,
  lib,
  config,
  ...
}:

let
  myHyprsunsetTemperature = pkgs.writers.writePython3Bin "myHyprsunsetTemperature" {
    libraries = with pkgs.python3Packages; [
      astral
      dbus-python
      tzlocal
    ];
    flakeIgnore = [ "E501" ];
  } ./script.py;
in
{
  systemd.user.services = {
    hyprsunset = {
      Install = {
        WantedBy = [ config.wayland.systemd.target ];
      };

      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "hyprsunset - Hyprland's blue-light filter";
        After = [ config.wayland.systemd.target ];
        PartOf = [ config.wayland.systemd.target ];
      };

      Service = {
        ExecStart = "${lib.getExe pkgs.hyprsunset}";
        Restart = "always";
        RestartSec = "10";
      };
    };

    myHyprsunsetTemperature = {
      Install = {
        WantedBy = [ "hyprsunset.service" ];
      };

      Unit = {
        Description = "Custom hyprsunset temperature adjustment service";
        ConditionEnvironment = "WAYLAND_DISPLAY";
        After = [ "hyprsunset.service" ];
        PartOf = [ "hyprsunset.service" ];
        Requires = [ "hyprsunset.service" ];
      };

      Service = {
        ExecStart = "${lib.getExe myHyprsunsetTemperature}";
        Restart = "on-failure";
        RestartSec = "5s";
        Environment = "PYTHONUNBUFFERED=1"; # print statements will go to journalctl immediately
      };
    };
  };

  home.sessionVariables = {
    HYPRSUNSET_DAY_TEMP = "6000";
    HYPRSUNSET_NIGHT_TEMP = "3000";
  };
}
