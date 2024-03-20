{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Execute at launch
    exec-once = [
      "nm-applet --indicator"
      "blueman-applet"
      "sleep 5 && nextcloud --background"
      "~/scripts/hibernate_on_low_battery.sh"
    ];
  };
}
