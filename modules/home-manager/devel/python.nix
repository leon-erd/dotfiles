{ pkgs, ... }:

{
  home.packages = with pkgs; [
    micromamba
  ];

  programs.zsh = {
    initExtra = "eval \"$(micromamba shell hook --shell zsh)\"";
  };
}
