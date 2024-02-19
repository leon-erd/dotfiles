{ systemSettings, ... }:

{
  imports = [
    ./xserver.nix
  ];

  services.xserver.desktopManager.plasma5.enable = true;
}
