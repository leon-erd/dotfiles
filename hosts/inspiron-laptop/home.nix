{
  config,
  lib,
  pkgs,
  inputs,
  userSettings,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";
  xdg.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ../../modules/home-manager/apps/media.nix
    ../../modules/home-manager/apps/office.nix
    ../../modules/home-manager/apps/qt-apps.nix
    ../../modules/home-manager/apps/social.nix
    ../../modules/home-manager/apps/utility.nix
    ../../modules/home-manager/devel/git.nix
    ../../modules/home-manager/devel/latex.nix
    ../../modules/home-manager/devel/shell.nix
    ../../modules/home-manager/devel/python.nix
    ../../modules/home-manager/devel/vscodium/vscode.nix
    #     ../../modules/home-manager/devel/vscodium/vscodium.nix
    ../../modules/home-manager/theming/theming.nix
    ../../modules/home-manager/wm/hyprland.nix # needs hyprland.nix import in configuration.nix
  ];

  home.activation = {
    myScripts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ln -Tsf ${userSettings.flakeDirectory}/scripts ~/scripts
    '';
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
