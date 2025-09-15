{ ... }:

{
  imports = [
    ./xserver.nix
  ];

  services.desktopManager.plasma6.enable = true;
  # the plasma6 module sets itself as the default session which I don't want
  services.displayManager.defaultSession = null;
}
