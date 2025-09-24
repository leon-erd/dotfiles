{ pkgs, ... }:

{
  imports = [
    ./submodules/thunderbird.nix
  ];

  home.packages = with pkgs; [
    signal-desktop
    slack
    telegram-desktop
    discord
    wasistlos # whatsapp-for-linux
  ];
}
