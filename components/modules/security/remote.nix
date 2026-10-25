{ ... }:

{
  flake.modules.nixos.remote =
    { pkgs, ... }:

    {
      environment.systemPackages = [ pkgs.rustdesk-flutter ];
    };
}
