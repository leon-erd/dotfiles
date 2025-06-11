{ ... }:

{
  services.blueman-applet.enable = true;

  wayland.windowManager.hyprland.settings.exec-once = [
    "sleep 5 && systemctl --user restart blueman-applet.service"
  ];
}
