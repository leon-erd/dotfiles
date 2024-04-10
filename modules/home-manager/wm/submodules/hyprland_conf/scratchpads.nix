{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    workspace = [
      "special:spotify, on-created-empty:[fullscreen] spotify"
      "special:terminal, on-created-empty:[fullscreen] alacritty"
    ];
    bind = [
      "$mainMod, S, togglespecialworkspace, spotify"
      "$mainMod, T, togglespecialworkspace, terminal"
    ];
    animation = [
      "specialWorkspace, 1, 5, default, slidefadevert"
    ];
  };
}
