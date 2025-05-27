{
  config,
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
    ../../modules/home-manager/devel/git.nix
    ../../modules/home-manager/devel/shell.nix
    # ../../modules/home-manager/devel/python.nix
  ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };

  home.stateVersion = "24.11"; # Do not modify
}
