{ ... }:

{
  flake.modules.homeManager.gammastep =
    { ... }:

    {
      services.gammastep = {
        enable = true;
        provider = "geoclue2";
        tray = true;
      };
    };
}
