{ pkgs, ... }:

{
  # set some important things
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware  = true; # Enable all firmware regardless of license
  nix.optimise.automatic = true; # optimise nix store disk space by hard linking identical files

  # set zsh as default shell
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
}
