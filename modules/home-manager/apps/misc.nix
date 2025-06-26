{ pkgs, ... }:

{
  imports = [
    ./submodules/firefox.nix
  ];

  home.packages = with pkgs; [
    bitwarden-desktop
    meld
  ];

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  programs.distrobox = {
    enable = true;
    containers = { };
  };
}
