{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    workspace = [
      "2, on-created-empty:dolphin"
      "5, on-created-empty:firefox"
    ];
    misc.initial_workspace_tracking = false;
  };
}
