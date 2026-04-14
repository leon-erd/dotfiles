{ ... }:

{
  flake.modules.homeManager.hyprlandInput =
    { config, ... }:

    {
      wayland.windowManager.hyprland.settings = {
        input = {
          kb_layout = config.myUserConfig.kblayout;
          kb_options = "ctrl:nocaps"; # remap Caps lock to Ctrl (https://wiki.hypr.land/Configuring/Uncommon-tips--tricks/#remapping-caps-lock)
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

        cursor = {
          no_hardware_cursors = 1;
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
    };
}
