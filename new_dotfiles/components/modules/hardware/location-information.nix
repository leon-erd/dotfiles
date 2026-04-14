{ ... }:

{
  flake.modules.nixos.locationInformation =
    { ... }:

    {
      services.geoclue2.enable = true;
    };
}
