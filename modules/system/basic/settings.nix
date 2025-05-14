{ pkgs, myPkgs, ... }:

{
  # set some important things
  nixpkgs.pkgs = myPkgs;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.channel.enable = false;
  hardware.enableAllFirmware = true; # Enable all firmware regardless of license
  nix.optimise.automatic = true; # optimise nix store disk space by hard linking identical files

  # set zsh as default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.pathsToLink = [ "/share/zsh" ]; # needed for completion for system packages
}
