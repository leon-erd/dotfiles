{
  lib,
  inputs,
  userSettings,
  ...
}:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../../modules/home-manager/basic.nix
    ../../modules/home-manager/apps/media.nix
    ../../modules/home-manager/apps/office.nix
    ../../modules/home-manager/apps/qt-apps.nix
    ../../modules/home-manager/apps/social.nix
    ../../modules/home-manager/apps/misc.nix
    ../../modules/home-manager/devel/git.nix
    ../../modules/home-manager/devel/latex.nix
    ../../modules/home-manager/devel/shell.nix
    ../../modules/home-manager/devel/python.nix
    ../../modules/home-manager/devel/vscode
    ../../modules/home-manager/theming/theming.nix
    ../../modules/home-manager/wm/hyprland # needs hyprland.nix import in configuration.nix
  ];

  home.activation = {
    myScripts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ln -Tsf ${userSettings.flakeDirectory}/scripts ~/scripts
    '';
  };

  home.stateVersion = "23.11"; # Do not modify
}
