{ pkgs, ... }:

{
  imports = [
    ./submodules/firefox.nix
  ];

  home.packages = with pkgs; [
    bitwarden-desktop
    brave
    meld
    nextcloud-client
    distrobox
  ];
}

