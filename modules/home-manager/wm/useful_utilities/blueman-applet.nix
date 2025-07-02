{ ... }:

{
  services.blueman-applet.enable = true;

  wayland.windowManager.hyprland.settings.exec-once = [
    "sleep 10 && systemctl --user restart blueman-applet.service"
  ];
}
