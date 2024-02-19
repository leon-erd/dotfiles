{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    # Fonts
    nerdfonts
  ];
  
  fonts.fontDir.enable = true;
}
