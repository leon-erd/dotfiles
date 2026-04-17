{ ... }:

{
  flake.modules.nixos.automount =
    { pkgs, ... }:

    {
      services.devmon.enable = true;
      services.gvfs.enable = true;
      services.udisks2.enable = true;
      environment.systemPackages = with pkgs; [
        ntfs3g
      ];
    };
}
