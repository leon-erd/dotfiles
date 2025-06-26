{ pkgs, lib, ... }:

# install all nerd fonts except Iosevka and its variants because they are huge and not needed
let
  allNerdFontsNames = builtins.attrNames pkgs.nerd-fonts;
  dropIosevka = builtins.filter (name: lib.hasPrefix "iosevka" name) allNerdFontsNames;
  customNerdFonts = builtins.removeAttrs pkgs.nerd-fonts dropIosevka;
  customNerdFontsDerivations = builtins.filter lib.attrsets.isDerivation (
    builtins.attrValues customNerdFonts
  );
in

{
  fonts.packages = [

  ] ++ customNerdFontsDerivations;

  fonts.fontDir.enable = true;
}
