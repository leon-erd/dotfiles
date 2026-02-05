{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Halle Mama! Hier deine Packages untereinander hinschreiben und danach diesen Befehl ausführen im Terminal (Strg+Alt+T): "homie"
    # Die Namen der packages findest du auf: https://search.nixos.org/packages?channel=unstable&
    bitwarden-desktop
    gimp
    krita
    handbrake
    gthumb
    mpv
    qpwgraph
    spotify
    vlc
    signal-desktop
    kdePackages.audiocd-kio
  ];
}
