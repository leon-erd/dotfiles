{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome.eog
    mpv
    qpwgraph
    spotify
    vlc
  ];
}

