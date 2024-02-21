{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Execute at launch
    exec-once = [
      "/nix/store/$(ls -la /nix/store | grep polkit-kde-agent | grep '^d' | awk '{print $9}' | head -n 1)/libexec/polkit-kde-authentication-agent-1"
      "nm-applet --indicator"
      "blueman-applet"
      "sleep 1 && nextcloud --background"
      "~/scripts/hibernate_on_low_battery.sh"
      "hyprctl setcursor breeze_cursors 24"
    ];
  };
}
