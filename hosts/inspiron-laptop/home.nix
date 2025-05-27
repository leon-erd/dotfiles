{
  config,
  lib,
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
    inputs.sops-nix.homeManagerModules.sops
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

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };

  home.stateVersion = "23.11"; # Do not modify
}
