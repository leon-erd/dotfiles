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
      mouse_move_enables_dpms = true;
      vrr = 3;
    };
    render.new_render_scheduling = true;
    debug = {
      disable_logs = false;
      full_cm_proto = true; # https://github.com/hyprwm/Hyprland/discussions/10860#discussioncomment-13736256
    };
    ecosystem.enforce_permissions = true;
  };
}
