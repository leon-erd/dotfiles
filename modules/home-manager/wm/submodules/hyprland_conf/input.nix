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


    # All the below is me trying to map the pen to laptop screen
      tablet = {
        output = "eDP-1";
      };

      touchdevice = {
        output = "eDP-1";
      };
    };

    "device:cust0000:00-04f3:2a4a-stylus" = {
      output = "eDP-1";
    };

    gestures = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      workspace_swipe = true;
      workspace_swipe_forever = true;
    };
  };
}
