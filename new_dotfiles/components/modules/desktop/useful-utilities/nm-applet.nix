{ ... }:

{
  flake.modules.homeManager.nmApplet =
    { ... }:

    {
      services.network-manager-applet.enable = true;
    };
}
