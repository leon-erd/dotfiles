{ pkgs, ... }:

{
  imports = [
    ./submodules/thunderbird.nix
  ];

  home.packages = with pkgs; [
    signal-desktop
    slack
    telegram-desktop
    webcord
    wasistlos # whatsapp-for-linux
  ];
}
