{
  pkgs,
  lib,
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
  services.hyprsunset.enable = true;

  systemd.user.services = {
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
