{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    general = {
      snap.enabled = true;
      resize_on_border = true;
      layout = "master";
    };
    misc = {
      animate_manual_resizes = true;
      animate_mouse_windowdragging = true;
      focus_on_activate = true;
      force_default_wallpaper = 0;
      initial_workspace_tracking = false;
      new_window_takes_over_fullscreen = 2;
    };
    debug = {
      disable_logs = false;
    };
  };
}

