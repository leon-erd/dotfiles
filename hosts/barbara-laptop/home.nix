{
  lib,
  inputs,
  userSettings,
  ...
}:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./mamas-packages.nix
    ../../modules/home-manager/basic/basic.nix
    ../../modules/home-manager/apps/office.nix
    ../../modules/home-manager/apps/qt-apps.nix
    ../../modules/home-manager/apps/social.nix
    ../../modules/home-manager/apps/submodules/firefox.nix
    ../../modules/home-manager/devel/alacritty.nix
    ../../modules/home-manager/devel/shell
    ../../modules/home-manager/devel/git.nix
    ../../modules/home-manager/devel/vscode
    ../../modules/home-manager/devel/wezterm.nix
    ../../modules/home-manager/theming/theming.nix
    ../../modules/home-manager/wm/hyprland # needs hyprland.nix import in configuration.nix
    ../../modules/home-manager/wm/kde
  ];

  home.activation = {
    myScripts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ln -Tsf ${userSettings.flakeDirectory}/scripts ~/scripts
    '';
  };

  programs.firefox.profiles.${userSettings.username} = {
    bookmarks = lib.mkForce { };
  };

  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;

  wayland.windowManager.hyprland.settings = {
    # Fallback rule
    monitor = lib.mkForce ", preferred, auto, 1.25";
  };

  home.stateVersion = "23.11"; # Do not modify
}
