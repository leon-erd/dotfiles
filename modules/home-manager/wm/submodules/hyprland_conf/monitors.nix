{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Monitor setup:
    # Usually handled by kanshi
    # You can also use nwg-displays to arrange monitors (you then have to source monitors.conf)
    # source = ["~/.config/hypr/monitors.conf"];

    # Fallback rule
    monitor = ", preferred, auto, 1";
  };
}
