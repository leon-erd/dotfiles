{ config, lib, pkgs, inputs, userSettings, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ../../modules/home-manager/devel/git.nix
    ../../modules/home-manager/devel/shellStable.nix
    # ../../modules/home-manager/devel/python.nix
  ];

  home.stateVersion = "24.11"; # Do not modify
}
