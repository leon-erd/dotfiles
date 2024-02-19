{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Execute at launch
    exec-once = [
      "/nix/store/$(ls -la /nix/store | grep polkit-kde-agent | grep '^d' | awk '{print $9}' | head -n 1)/libexec/polkit-kde-authentication-agent-1"
      "swayidle -w timeout 300 'swaylock -f' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock -f'"
      "nm-applet --indicator"
      "blueman-applet"
      "sleep 1 && nextcloud --background"
      "~/scripts/hibernate_on_low_battery.sh"
      "hyprctl setcursor breeze_cursors 24"
    ];
  };
}
