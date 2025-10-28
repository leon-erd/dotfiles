{
  lib,
  pkgs,
  inputs,
  userSettings,
  ...
}:

let
  remote-deployment-home-script = builtins.readFile ../../scripts/remote-deployment-home.sh;
  remote-deployment-system-script = builtins.readFile ../../scripts/remote-deployment-system.sh;

  remoteDeploymentHome = pkgs.writeShellApplication {
    name = "remote-deployment-home";
    text = remote-deployment-home-script;
  };
  remoteDeploymentSystem = pkgs.writeShellApplication {
    name = "remote-deployment-system";
    text = remote-deployment-system-script;
  };
in

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../../modules/home-manager/basic.nix
    ../../modules/home-manager/apps/media.nix
    ../../modules/home-manager/apps/office.nix
    ../../modules/home-manager/apps/qt-apps.nix
    ../../modules/home-manager/apps/social.nix
    ../../modules/home-manager/apps/misc.nix
    ../../modules/home-manager/devel/alacritty.nix
    ../../modules/home-manager/devel/shell
    ../../modules/home-manager/devel/git.nix
    ../../modules/home-manager/devel/latex.nix
    # ../../modules/home-manager/devel/python.nix
    ../../modules/home-manager/devel/vscode
    ../../modules/home-manager/devel/wezterm.nix
    ../../modules/home-manager/theming/theming.nix
    ../../modules/home-manager/wm/hyprland # needs hyprland.nix import in configuration.nix
    ../../modules/home-manager/wm/kde
  ];

  home.sessionVariables = {
    DEPLOY_FLAKE = "${userSettings.flakeDirectory}/hosts/raspberrypi";
    DEPLOY_USER = "leon";
    DEPLOY_HOST = "raspberry.pi";
    DEPLOY_USER_CONFIG_NAME = "leon@raspberrypi";
    DEPLOY_SYSTEM_CONFIG_NAME = "raspberrypi";
  };

  home.packages = [
    remoteDeploymentHome
    remoteDeploymentSystem
  ];

  home.activation = {
    myScripts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ln -Tsf ${userSettings.flakeDirectory}/scripts ~/scripts
    '';
  };

  home.stateVersion = "23.11"; # Do not modify
}
