{ userSettings, ... }:

{
  wayland.windowManager.hyprland.settings = {
    input = {
      kb_layout = userSettings.kblayout;
      numlock_by_default = true;
      touchpad = {
        natural_scroll = true;
        drag_lock = true;
      };
    };

    device = {
      name = "cust0000:00-04f3:2a4a-stylus";
      output = "eDP-1";
    };

    gesture = [
      "3, horizontal, workspace"
      "3, vertical, scale:1.5, fullscreen"
      "4, swipe, resize"
    ];
    gestures = {
      workspace_swipe_forever = true;
      workspace_swipe_touch = true;
    };
  };
}
