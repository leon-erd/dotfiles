{ self, ... }:

{
  flake.modules.homeManager.hyprlandPluginsDefault =
    { ... }:

    {
      imports = with self.modules.homeManager; [
        hyprDynamicCursors
      ];
    };
}
