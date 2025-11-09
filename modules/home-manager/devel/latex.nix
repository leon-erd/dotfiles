{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ipe
    # jabref
    pympress
  ];

  programs.texlive = {
    enable = true;
    extraPackages = (tpkgs: { inherit (tpkgs) scheme-full; });
  };
}
