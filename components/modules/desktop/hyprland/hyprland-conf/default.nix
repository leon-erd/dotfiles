{ self, ... }:

{
  flake.modules.homeManager.hyprlandConfigDefault =
    { ... }:

    {
      imports = with self.modules.homeManager; [
        hyprlandBindings
        hyprlandExecOnce
        hyprlandGraphics
        hyprlandInput
        hyprlandLayouts
        hyprlandMisc
        hyprlandMonitors
        hyprlandScratchpads
        hyprlandWindowrules
        hyprlandWorkspacerules
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        systemd.variables = [ "--all" ];
        package = null;
        portalPackage = null;
      };
    };
}
