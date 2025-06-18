{ pkgs, ... }:

{
  imports = [
    ./submodules/firefox.nix
  ];

  home.packages = with pkgs; [
    bitwarden-desktop
    meld
    nextcloud-client
    distrobox
  ];
}
