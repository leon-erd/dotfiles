{ ... }:
let
  # hyprlockCmd = "pgrep hyprlock || hyprlock";
  # hyprlockCmd = "pgrep hyprlock || ${./hyprlock_with_apps/hyprlock.sh}";
  hyprlockCmd = "caelestia shell lock lock";
in
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = hyprlockCmd;
        before_sleep_cmd = hyprlockCmd;
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = hyprlockCmd;
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
