{ systemSettings, ... }:

{
  imports = [
    ./xserver.nix
  ];

  services.desktopManager.plasma6.enable = true;
}
