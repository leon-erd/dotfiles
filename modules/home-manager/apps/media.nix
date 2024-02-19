{ pkgs, ... }:

{
  home.packages = with pkgs; [
    mpv
    qpwgraph
    spotify
    vlc
  ];
}

