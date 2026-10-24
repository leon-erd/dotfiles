{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Halle Papa! Hier deine Packages untereinander hinschreiben und danach diesen Befehl ausführen im Terminal (Strg+Alt+T): "homie"
    # Die Namen der packages findest du auf: https://search.nixos.org/packages?channel=unstable&
    vlc
    kdePackages.audiocd-kio
    zoom-us
  ];
}
