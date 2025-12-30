{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gthumb
    mpv
    qpwgraph
    spotify
    vlc
  ];
}
