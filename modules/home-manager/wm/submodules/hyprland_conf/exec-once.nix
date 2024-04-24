{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Execute at launch
    exec-once = [
      "sleep 5 && nextcloud --background"
      "~/scripts/hibernate_on_low_battery.sh"
    ];
  };
}
