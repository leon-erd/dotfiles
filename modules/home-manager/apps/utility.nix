{ pkgs, ... }:

{
  imports = [
    ./submodules/firefox.nix
  ];

  home.packages = with pkgs; [
    bitwarden
    brave
    meld
    nextcloud-client
    wireguard-tools
  ];
}

