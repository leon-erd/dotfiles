{ ... }:

{
  programs.waybar.settings.mainBar = {
    layer = "top"; # Waybar at top layer
    # position = "bottom"; # Waybar position (top|bottom|left|right)
    height = 30; # Waybar height (to be removed for auto height)
    # width = 1280; # Waybar width
    spacing = 4; # Gaps between modules (4px)

    # Load modules
    include = ["~/.config/waybar/modules.json"];
    # include = ["~/.config/waybar/modules.json.orig"];

    # Choose the order of the modules
    modules-left = [
      "wlr/taskbar"
      "hyprland/window"
      "custom/media"
    ];
    modules-center = ["hyprland/workspaces"];
    modules-right = [
      "tray"
      "idle_inhibitor"
      "pulseaudio"
      "pulseaudio#microphone"
      "backlight"
      "battery"
      "clock"
      "custom/notification"
    ];
  };
}
