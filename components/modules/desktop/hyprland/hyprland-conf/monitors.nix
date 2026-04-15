{ ... }:

{
  flake.modules.homeManager.hyprlandMonitors =
    { ... }:

    {
      wayland.windowManager.hyprland.settings = {
        # Fallback rule
        monitor = ", preferred, auto, 1";
      };
    };
}
