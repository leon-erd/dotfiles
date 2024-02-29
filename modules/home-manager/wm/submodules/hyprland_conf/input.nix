{ systemSettings, ... }:

{
  wayland.windowManager.hyprland.settings = {
    input = {
      kb_layout = systemSettings.kblayout;
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

    gestures = {
      workspace_swipe = true;
      workspace_swipe_forever = true;
    };
  };
}
