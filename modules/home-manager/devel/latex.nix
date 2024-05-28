{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ipe
    jabref
    pympress
    texliveFull
  ];
}

