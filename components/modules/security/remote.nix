{ ... }:

{
  flake.modules.nixos.remote =
    { ... }:

    {
      services.teamviewer = {
        enable = true;
      };
    };
}
