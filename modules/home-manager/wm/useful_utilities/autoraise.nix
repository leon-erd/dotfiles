{ pkgs, ... }:

{
  home.packages = with pkgs; [
    autoraise
  ];

  # never raise
  xdg.configFile."AutoRaise".text = "delay=0";
}
