{ pkgs, ... }:

{
  imports = [
    ../../modules/system/basic/settings.nix
    ../../modules/system/basic/macos-settings.nix
    ../../modules/system/apps/cli-apps.nix
  ];

  fonts.packages = with pkgs.nerd-fonts; [
    hack
    jetbrains-mono
  ];

  system.primaryUser = "leon.erd";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
