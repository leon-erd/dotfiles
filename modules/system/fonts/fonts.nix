{ pkgs, lib, ... }:

{
  fonts.packages = [

  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  
  fonts.fontDir.enable = true;
}
