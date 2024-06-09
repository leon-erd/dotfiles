{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Execute at launch
    exec-once = [
      "sleep 5 && nextcloud --background"
      "sleep 5 && ~/scripts/hibernate_on_low_battery.sh"
      "sleep 5 && ~/scripts/restart_failed_systemd_user_services.sh"
    ];
  };
}
